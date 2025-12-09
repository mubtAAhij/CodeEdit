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

echo "🏗  Running unsigned build with compiler-based string extraction..."

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

# Even if the build failed, try to merge emitted strings into the catalog
# Xcode only merges strings on successful builds, so we need to do it manually
echo "🔄 Attempting to merge emitted strings into string catalog..."

# Find the xcstrings file
XCSTRINGS_FILE=$(find . -name "*.xcstrings" -type f | head -1)

if [ -z "$XCSTRINGS_FILE" ]; then
  echo "⚠️  No .xcstrings file found, skipping merge"
else
  # Get DerivedData path from build settings
  DERIVED_DATA_PATH=$(xcodebuild -project "$PROJECT_PATH" -scheme "$SCHEME" -showBuildSettings 2>/dev/null | grep -m 1 "BUILD_DIR" | sed 's/.*= *//' | xargs || echo "")
  
  if [ -n "$DERIVED_DATA_PATH" ]; then
    # Find emitted strings directories (Objects-normal/arm64 and Objects-normal/x86_64)
    EMITTED_STRINGS_DIRS=$(find "$DERIVED_DATA_PATH" -type d -path "*/Objects-normal/*" 2>/dev/null || echo "")
    
    if [ -n "$EMITTED_STRINGS_DIRS" ]; then
      echo "📁 Found emitted strings directories, merging into catalog..."
      # Use Python script to merge strings
      if [ -f "./Scripts/merge_emitted_strings.py" ]; then
        python3 ./Scripts/merge_emitted_strings.py "$XCSTRINGS_FILE" $EMITTED_STRINGS_DIRS || echo "⚠️  Failed to merge strings"
      else
        echo "⚠️  merge_emitted_strings.py not found, skipping merge"
        echo "💡 Strings may not be in catalog if build failed"
      fi
    else
      echo "⚠️  Could not find emitted strings directories in DerivedData"
      echo "💡 This is normal if no files compiled successfully"
    fi
  else
    echo "⚠️  Could not determine DerivedData path"
  fi
fi

# Clean up log file
rm -f "$BUILD_LOG"

