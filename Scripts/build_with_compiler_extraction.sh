#!/usr/bin/env bash

set -uo pipefail  # Remove -e to allow graceful error handling

PROJECT_PATH="${1:-YourApp.xcodeproj}"
SCHEME="${2:-YourApp}"
CONFIGURATION="${3:-Debug}"

# Detect available destinations and choose appropriate one
echo "🔍 Detecting available build destinations..."
AVAILABLE_DESTINATIONS=$(xcodebuild -project "$PROJECT_PATH" -scheme "$SCHEME" -showdestinations 2>/dev/null || echo "")

# Try to find a suitable destination (prefer iOS Simulator, fall back to macOS)
if echo "$AVAILABLE_DESTINATIONS" | grep -q "platform:iOS Simulator"; then
  DESTINATION="generic/platform=iOS Simulator"
  echo "✅ Using iOS Simulator destination"
elif echo "$AVAILABLE_DESTINATIONS" | grep -q "platform:macOS"; then
  DESTINATION="generic/platform=macOS"
  echo "✅ Using macOS destination"
else
  # Fallback: try to extract first available platform
  FIRST_PLATFORM=$(echo "$AVAILABLE_DESTINATIONS" | grep -m 1 "platform:" | sed -E 's/.*platform:([^,}]+).*/\1/' | head -1 | xargs || echo "")
  if [ -n "$FIRST_PLATFORM" ]; then
    DESTINATION="generic/platform=$FIRST_PLATFORM"
    echo "✅ Using detected destination: $DESTINATION"
  else
    # Last resort: try macOS
    DESTINATION="generic/platform=macOS"
    echo "⚠️  Could not detect destination, defaulting to macOS"
  fi
fi

echo "📍 Build destination: $DESTINATION"

echo "🏗  Ensuring String Catalog exists..."
./Scripts/ensure_string_catalog.sh "$PROJECT_PATH" "$SCHEME" || {
  echo "⚠️  Warning: Failed to ensure string catalog, continuing anyway..."
}

# If file was recreated, ensure it's added to the project
XCSTRINGS_FILE=$(find . -name "Localizable.xcstrings" -type f | head -n 1)
if [ -n "$XCSTRINGS_FILE" ] && [ -f "./Scripts/add_xcstrings_to_project.rb" ]; then
  echo "🔄 Ensuring .xcstrings file is in Xcode project..."
  ruby ./Scripts/add_xcstrings_to_project.rb "$PROJECT_PATH" "$XCSTRINGS_FILE" "$SCHEME" 2>/dev/null || echo "⚠️  Note: File may already be in project"
fi

echo "🏗  Running unsigned build with compiler-based string extraction..."

# Verify build settings before building
echo "🔍 Verifying build settings..."
VERIFY_SETTINGS=$(xcodebuild -project "$PROJECT_PATH" -scheme "$SCHEME" -showBuildSettings 2>/dev/null | grep -E "(SWIFT_EMIT_LOC_STRINGS|LOCALIZED_STRING)" || echo "")
if [ -n "$VERIFY_SETTINGS" ]; then
  echo "📋 Current build settings:"
  echo "$VERIFY_SETTINGS" | sed 's/^/   /'
else
  echo "⚠️  Could not verify build settings (will set via xcodebuild args)"
fi

# Save build output to file for debugging
BUILD_LOG="build_output.log"

# Check if xcpretty is available
if command -v xcpretty &> /dev/null; then
  echo "📝 Using xcpretty for formatted output"
  XCPRETTY_CMD="xcpretty"
else
  echo "⚠️  xcpretty not found, using raw xcodebuild output"
  XCPRETTY_CMD="cat"
fi

# Disable SwiftLint and other plugins - we only need string extraction, not linting
export SWIFTLINT_DISABLE=YES
export SWIFTLINT_SKIP_BUILD_PHASE=YES
export DISABLE_SWIFTLINT=YES

# Run xcodebuild and capture both formatted output and raw log
echo "🔨 Starting build (plugins disabled for string extraction only)..."
# Use -skipPackagePluginValidation to skip SwiftLint and other plugin validation
# Note: xcodebuild compiles files in parallel, so many files may compile successfully
# before hitting an error. Strings from successfully compiled files will be extracted.
xcodebuild \
  -project "$PROJECT_PATH" \
  -scheme "$SCHEME" \
  -configuration "$CONFIGURATION" \
  -destination "$DESTINATION" \
  CODE_SIGNING_ALLOWED=NO \
  SWIFT_EMIT_LOC_STRINGS=YES \
  LOCALIZED_STRING_SWIFTUI_SUPPORT=YES \
  -skipPackagePluginValidation \
  build 2>&1 | tee "$BUILD_LOG" | $XCPRETTY_CMD

BUILD_EXIT_CODE=${PIPESTATUS[0]}

if [ $BUILD_EXIT_CODE -eq 0 ]; then
  echo "✅ Build completed successfully. String Catalogs should be updated."
else
  echo "⚠️  Build completed with exit code $BUILD_EXIT_CODE"
  echo "📋 Showing last 50 lines of build output for debugging:"
  tail -50 "$BUILD_LOG" || true
  echo ""
  echo "⚠️  Build had errors, but attempting to merge emitted strings anyway..."
  echo "💡 Note: xcodebuild compiles files in parallel, so many Swift files may have compiled successfully"
  echo "💡 Even if the build failed, we'll try to merge strings from successfully compiled files"
fi

# Always try to merge emitted strings into the catalog
# Even on successful builds, Xcode may not merge if .xcstrings isn't in the project
echo "🔄 Attempting to merge emitted strings into string catalog..."

# Find the xcstrings file (look in common locations)
XCSTRINGS_FILE=$(find . -name "*.xcstrings" -type f | head -1)

if [ -z "$XCSTRINGS_FILE" ]; then
  echo "⚠️  No .xcstrings file found, skipping merge"
else
  echo "📋 Found string catalog: $XCSTRINGS_FILE"
  
  # Get DerivedData path from build settings
  BUILD_DIR=$(xcodebuild -project "$PROJECT_PATH" -scheme "$SCHEME" -showBuildSettings 2>/dev/null | grep -m 1 "BUILD_DIR" | sed 's/.*= *//' | xargs || echo "")
  
  if [ -n "$BUILD_DIR" ]; then
    # Convert BUILD_DIR to Intermediates path
    # BUILD_DIR is typically: .../DerivedData/Project-xxx/Build/Products
    # Intermediates is: .../DerivedData/Project-xxx/Build/Intermediates.noindex
    INTERMEDIATES_DIR=$(echo "$BUILD_DIR" | sed 's|/Build/Products|/Build/Intermediates.noindex|')
    
    echo "🔍 Searching for compiler-emitted strings files in: $INTERMEDIATES_DIR"
    
    # Only search for compiler-emitted strings in specific locations:
    # 1. en.lproj directories within build intermediates (XML plist format - most common for emitted strings)
    # 2. Objects-normal directories (traditional format, less common)
    # Exclude: Products (copied resources), SourcePackages (dependencies), frameworks
    EMITTED_STRINGS_FILES=$(find "$INTERMEDIATES_DIR" \( -path "*/en.lproj/*.strings" -o -path "*/Objects-normal/*/*.strings" \) -type f 2>/dev/null | grep -v "/SourcePackages/" | grep -v "/Products/" | grep -v ".framework/" | head -50 || echo "")
    
    if [ -n "$EMITTED_STRINGS_FILES" ]; then
      STRING_COUNT=$(echo "$EMITTED_STRINGS_FILES" | wc -l | xargs)
      echo "📁 Found $STRING_COUNT emitted strings files, merging into catalog..."
      echo "📝 Sample files found:"
      echo "$EMITTED_STRINGS_FILES" | head -5 | sed 's/^/   /'
      
      # Use Python script to merge strings
      if [ -f "./Scripts/merge_emitted_strings.py" ]; then
        # Pass all found strings files to the script
        python3 ./Scripts/merge_emitted_strings.py "$XCSTRINGS_FILE" $EMITTED_STRINGS_FILES || echo "⚠️  Failed to merge strings"
      else
        echo "⚠️  merge_emitted_strings.py not found, skipping merge"
        echo "💡 Strings may not be in catalog"
      fi
    else
      echo "⚠️  Could not find compiler-emitted strings files in DerivedData"
      echo "💡 Searched in: $INTERMEDIATES_DIR"
      echo "💡 Search pattern: */en.lproj/*.strings or */Objects-normal/*/*.strings"
      echo "💡 Excluded: SourcePackages, Products, frameworks"
      echo ""
      echo "💡 This might mean:"
      echo "   1. Strings were already merged by Xcode (check catalog)"
      echo "   2. No strings were emitted (check SWIFT_EMIT_LOC_STRINGS setting)"
      echo "   3. Strings are in a different location"
      echo "   4. Existing .strings files in project may prevent emission (we only search DerivedData, so this shouldn't affect us)"
      
      # Try to check if catalog was updated by Xcode
      if command -v jq &> /dev/null; then
        CATALOG_COUNT=$(jq '.strings | length' "$XCSTRINGS_FILE" 2>/dev/null || echo "0")
        if [ "$CATALOG_COUNT" -gt 0 ]; then
          echo "✅ Catalog contains $CATALOG_COUNT strings (Xcode may have merged them)"
        fi
      fi
    fi
  else
    echo "⚠️  Could not determine DerivedData path"
  fi
fi

# Clean up log file
rm -f "$BUILD_LOG"

