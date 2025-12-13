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
BUILD_LOG_RAW="build_output_raw.log"

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
  build 2>&1 | tee "$BUILD_LOG_RAW" | tee "$BUILD_LOG" | $XCPRETTY_CMD

BUILD_EXIT_CODE=${PIPESTATUS[0]}

# Diagnostic: Check if compiler was actually asked to emit strings
echo ""
echo "🔍 Checking if Swift compiler was invoked with emit-localized-strings flags..."
if grep -n "emit-local" "$BUILD_LOG_RAW" 2>/dev/null | head -10; then
  echo "✅ Found 'emit-local' flags in build log - compiler was asked to emit strings"
else
  echo "⚠️  WARNING: No 'emit-local' flags found in build log!"
  echo "   This suggests SWIFT_EMIT_LOC_STRINGS=YES may not be taking effect"
  echo "   Checking for other localized string related flags..."
  grep -n "localized" "$BUILD_LOG_RAW" 2>/dev/null | head -20 || echo "   (no localized flags found)"
fi
echo ""

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

# Check if strings were already merged into the catalog by Xcode
echo "🔍 Checking string catalog for merged strings..."

# Find the xcstrings file (look in common locations)
XCSTRINGS_FILE=$(find . -name "*.xcstrings" -type f | head -1)

if [ -z "$XCSTRINGS_FILE" ]; then
  echo "⚠️  No .xcstrings file found"
else
  echo "📋 Found string catalog: $XCSTRINGS_FILE"
  
  # Check if catalog already contains strings (Xcode may have merged them automatically)
  CATALOG_COUNT=0
  if command -v jq &> /dev/null; then
    CATALOG_COUNT=$(jq '.strings | length' "$XCSTRINGS_FILE" 2>/dev/null || echo "0")
  fi
  
  if [ "$CATALOG_COUNT" -gt 0 ]; then
    echo "✅ Catalog already contains $CATALOG_COUNT strings (Xcode merged them automatically)"
    echo "💡 No need to search DerivedData - strings are already in the catalog"
  else
    # Try using xcodebuild -exportLocalizations first (cleaner approach)
    echo "🔄 Trying xcodebuild -exportLocalizations to extract strings..."
    EXPORT_DIR="./LocalizationsExport"
    mkdir -p "$EXPORT_DIR"
    
    # Get DerivedData path from build settings to reuse existing build
    # BUILD_DIR is typically: /path/to/DerivedData/ProjectName-hash/Build/Products/Configuration
    # We want: /path/to/DerivedData/ProjectName-hash
    BUILD_DIR_SETTING=$(xcodebuild -project "$PROJECT_PATH" -scheme "$SCHEME" -showBuildSettings 2>/dev/null | grep -m 1 "^ *BUILD_DIR" | sed 's/.*= *//' | xargs || echo "")
    if [ -n "$BUILD_DIR_SETTING" ]; then
      # Strip /Build and everything after it to get DerivedData root
      DERIVED_DATA_PATH=$(echo "$BUILD_DIR_SETTING" | sed 's|/Build.*||' | xargs)
    else
      DERIVED_DATA_PATH=""
    fi
    
    # Build exportLocalizations command with scheme and derivedDataPath
    EXPORT_CMD="xcodebuild -exportLocalizations"
    EXPORT_CMD="$EXPORT_CMD -project \"$PROJECT_PATH\""
    EXPORT_CMD="$EXPORT_CMD -scheme \"$SCHEME\""
    EXPORT_CMD="$EXPORT_CMD -localizationPath \"$EXPORT_DIR\""
    EXPORT_CMD="$EXPORT_CMD -exportLanguage en"
    EXPORT_CMD="$EXPORT_CMD -skipPackagePluginValidation"
    if [ -n "$DERIVED_DATA_PATH" ]; then
      EXPORT_CMD="$EXPORT_CMD -derivedDataPath \"$DERIVED_DATA_PATH\""
      echo "📂 Using existing DerivedData: $DERIVED_DATA_PATH"
    fi
    
    echo "🔍 Running exportLocalizations command..."
    if eval "$EXPORT_CMD" 2>&1 | tee -a "$BUILD_LOG_RAW"; then
      echo "✅ exportLocalizations completed successfully"
      
      # Find the exported .xcloc file
      XCLOC_FILE=$(find "$EXPORT_DIR" -name "*.xcloc" -type d | head -1)
      if [ -n "$XCLOC_FILE" ] && [ -d "$XCLOC_FILE" ]; then
        echo "📦 Found exported localization catalog: $XCLOC_FILE"
        
        # The .xcloc contains .xliff files and potentially .xcstrings files
        # Check if there's an .xcstrings file inside (Xcode 15+ with string catalogs)
        XCSTRINGS_IN_XCLOC=$(find "$XCLOC_FILE" -name "*.xcstrings" -type f | head -1)
        
        if [ -n "$XCSTRINGS_IN_XCLOC" ] && [ -f "$XCSTRINGS_IN_XCLOC" ]; then
          echo "📋 Found .xcstrings file in export: $XCSTRINGS_IN_XCLOC"
          # The exported .xcstrings should already contain merged strings from the build
          # Copy it to our catalog location (or merge if we want to preserve existing entries)
          if [ -f "./Scripts/merge_emitted_strings.py" ]; then
            # Merge the exported .xcstrings into our catalog
            python3 ./Scripts/merge_emitted_strings.py "$XCSTRINGS_FILE" "$XCSTRINGS_IN_XCLOC" || {
              echo "⚠️  Merge failed, trying direct copy..."
              # Fallback: if merge fails, just copy the file (it should have all strings)
              cp "$XCSTRINGS_IN_XCLOC" "$XCSTRINGS_FILE" && echo "✅ Copied exported .xcstrings file"
            }
          else
            # No merge script, just copy
            cp "$XCSTRINGS_IN_XCLOC" "$XCSTRINGS_FILE" && echo "✅ Copied exported .xcstrings file"
          fi
        else
          # Check for .xliff files (older format)
          XLIFF_FILE=$(find "$XCLOC_FILE" -name "*.xliff" -type f | head -1)
          if [ -n "$XLIFF_FILE" ] && [ -f "$XLIFF_FILE" ]; then
            echo "📋 Found .xliff file in export: $XLIFF_FILE"
            echo "✅ XLIFF file found - strings will be extracted directly from XLIFF for skip list"
            
            # Count strings in XLIFF file (for skip list generation, we'll parse it directly)
            if command -v python3 &> /dev/null; then
              XLIFF_COUNT=$(python3 -c "
import xml.etree.ElementTree as ET
import sys
try:
    tree = ET.parse('$XLIFF_FILE')
    root = tree.getroot()
    ns = ''
    if root.tag.startswith('{'):
        ns = root.tag.split('}')[0] + '}'
    trans_units = root.findall(f'.//{ns}trans-unit') if ns else root.findall('.//trans-unit')
    count = 0
    for trans_unit in trans_units:
        source_elem = trans_unit.find(f'{ns}source') if ns else trans_unit.find('source')
        if source_elem is not None:
            source_text = ''
            if source_elem.text:
                source_text = source_elem.text.strip()
            elif len(source_elem) > 0:
                source_text = ''.join(source_elem.itertext()).strip()
            if source_text:
                count += 1
    print(count)
except:
    print(0)
" 2>/dev/null || echo "0")
              
              if [ "$XLIFF_COUNT" -gt 0 ]; then
                echo "✅ Found $XLIFF_COUNT strings in XLIFF file"
                echo "💡 Skip list will be built directly from XLIFF file (no conversion needed)"
                # Set a flag that we found strings (even though they're in XLIFF, not .xcstrings)
                # This prevents falling back to manual .stringsdata parsing
                CATALOG_COUNT=$XLIFF_COUNT
              fi
            fi
          else
            echo "⚠️  No .xcstrings or .xliff files found in .xcloc"
            echo "   Falling back to manual .stringsdata parsing..."
          fi
        fi
        
        # Check if we successfully extracted strings (either from .xcstrings or .xliff)
        if [ "$CATALOG_COUNT" -eq 0 ] && command -v jq &> /dev/null; then
          NEW_COUNT=$(jq '.strings | length' "$XCSTRINGS_FILE" 2>/dev/null || echo "0")
          if [ "$NEW_COUNT" -gt 0 ]; then
            echo "✅ Successfully extracted $NEW_COUNT strings via exportLocalizations"
            CATALOG_COUNT=$NEW_COUNT
          fi
        fi
      else
        echo "⚠️  No .xcloc file found in export directory"
      fi
    else
      echo "⚠️  exportLocalizations failed, will try manual parsing of .stringsdata files"
    fi
  fi
  
  # If exportLocalizations didn't work or catalog is still empty, try manual parsing
  if [ "$CATALOG_COUNT" -eq 0 ]; then
    echo "⚠️  Catalog is still empty, trying manual parsing of .stringsdata files..."
    echo "🔄 Searching DerivedData for compiler-emitted strings files..."
    
    # Get DerivedData path from build settings
    BUILD_DIR=$(xcodebuild -project "$PROJECT_PATH" -scheme "$SCHEME" -showBuildSettings 2>/dev/null | grep -m 1 "BUILD_DIR" | sed 's/.*= *//' | xargs || echo "")
    
    if [ -n "$BUILD_DIR" ]; then
      # Convert BUILD_DIR to Intermediates path
      INTERMEDIATES_DIR=$(echo "$BUILD_DIR" | sed 's|/Build/Products|/Build/Intermediates.noindex|')
      
      # Search for compiler-emitted strings in specific locations
      # Search for both .strings and .stringsdata files
      echo "📊 Searching for .strings files..."
      EMITTED_STRINGS_FILES=$(find "$INTERMEDIATES_DIR" \( -path "*/en.lproj/*.strings" -o -path "*/Objects-normal/*/*.strings" \) -type f 2>/dev/null | grep -v "/SourcePackages/" | grep -v "/Products/" | grep -v ".framework/" | head -50 || echo "")
      
      # Search for .stringsdata files (newer binary format)
      echo "📊 Searching for .stringsdata files..."
      EMITTED_STRINGSDATA_FILES=$(find "$INTERMEDIATES_DIR" -path "*/Objects-normal/*/*.stringsdata" -type f 2>/dev/null | grep -v "/SourcePackages/" | grep -v "/Products/" | grep -v ".framework/" | head -50 || echo "")
      
      # Also search for other localization artifacts for diagnostics
      echo "📊 Searching for other localization artifacts..."
      DERIVED_DATA_DIR=$(echo "$BUILD_DIR" | sed 's|/Build/Products.*||')
      OTHER_LOC_ARTIFACTS=$(find "$DERIVED_DATA_DIR" -type f 2>/dev/null \
        | grep -Ev "/SourcePackages/|/Products/|\\.framework/" \
        | grep -Ei "\\.(strings|stringsdata|xcstrings)$|loc(alized)?strings|emit" \
        | head -50 || echo "")
      
      if [ -n "$OTHER_LOC_ARTIFACTS" ]; then
        echo "📁 Found other localization artifacts:"
        echo "$OTHER_LOC_ARTIFACTS" | head -10 | sed 's/^/   /'
        echo ""
      fi
      
      # Combine .strings and .stringsdata files for merging
      ALL_EMITTED_FILES=""
      FILES_TO_MERGE=0
      
      if [ -n "$EMITTED_STRINGS_FILES" ]; then
        STRING_COUNT=$(echo "$EMITTED_STRINGS_FILES" | wc -l | xargs)
        echo "📁 Found $STRING_COUNT emitted .strings files"
        echo "📝 Sample .strings files found:"
        echo "$EMITTED_STRINGS_FILES" | head -5 | sed 's/^/   /'
        ALL_EMITTED_FILES="$EMITTED_STRINGS_FILES"
        FILES_TO_MERGE=$((FILES_TO_MERGE + STRING_COUNT))
      fi
      
      if [ -n "$EMITTED_STRINGSDATA_FILES" ]; then
        STRINGSDATA_COUNT=$(echo "$EMITTED_STRINGSDATA_FILES" | wc -l | xargs)
        echo "📁 Found $STRINGSDATA_COUNT emitted .stringsdata files"
        echo "📝 Sample .stringsdata files found:"
        echo "$EMITTED_STRINGSDATA_FILES" | head -5 | sed 's/^/   /'
        if [ -n "$ALL_EMITTED_FILES" ]; then
          ALL_EMITTED_FILES="$ALL_EMITTED_FILES"$'\n'"$EMITTED_STRINGSDATA_FILES"
        else
          ALL_EMITTED_FILES="$EMITTED_STRINGSDATA_FILES"
        fi
        FILES_TO_MERGE=$((FILES_TO_MERGE + STRINGSDATA_COUNT))
      fi
      
      if [ "$FILES_TO_MERGE" -gt 0 ]; then
        echo ""
        echo "🔄 Merging $FILES_TO_MERGE emitted file(s) into catalog..."
        
        # Use Python script to merge strings (supports both .strings and .stringsdata)
        if [ -f "./Scripts/merge_emitted_strings.py" ]; then
          # Pass the Intermediates directory to the merge script so it can find both .strings and .stringsdata files
          # This is safer than passing individual file paths which might have spaces
          python3 ./Scripts/merge_emitted_strings.py "$XCSTRINGS_FILE" "$INTERMEDIATES_DIR" || echo "⚠️  Failed to merge strings"
          
          # Verify merge succeeded
          if command -v jq &> /dev/null; then
            NEW_COUNT=$(jq '.strings | length' "$XCSTRINGS_FILE" 2>/dev/null || echo "0")
            if [ "$NEW_COUNT" -gt 0 ]; then
              echo "✅ Successfully merged strings into catalog (now contains $NEW_COUNT strings)"
            else
              echo "⚠️  Merge completed but catalog still empty (may need to check .stringsdata conversion)"
            fi
          fi
        else
          echo "⚠️  merge_emitted_strings.py not found, skipping merge"
        fi
      else
        echo "⚠️  No compiler-emitted strings files found in DerivedData"
        echo "💡 This might mean:"
        echo "   1. No strings were emitted (check SWIFT_EMIT_LOC_STRINGS setting)"
        echo "   2. Strings are in a different location"
        echo "   3. Existing .strings files in project may prevent emission"
      fi
    else
      echo "⚠️  Could not determine DerivedData path"
    fi
  fi
fi

# Diagnostic: Show build log analysis before cleanup
echo ""
echo "🔍 Build log analysis for string emission:"
if [ -f "$BUILD_LOG_RAW" ]; then
  echo "   Build log size: $(wc -l < "$BUILD_LOG_RAW" | xargs) lines"
  echo "   Checking for emit-localized-strings flags..."
  EMIT_COUNT=$(grep -c "emit-local" "$BUILD_LOG_RAW" 2>/dev/null || echo "0")
  if [ "$EMIT_COUNT" -gt 0 ]; then
    echo "   ✅ Found $EMIT_COUNT references to 'emit-local' flags"
  else
    echo "   ⚠️  No 'emit-local' flags found in build log"
  fi
fi

# Clean up log files (but keep raw log for diagnostics if build failed)
if [ $BUILD_EXIT_CODE -eq 0 ]; then
  rm -f "$BUILD_LOG" "$BUILD_LOG_RAW"
else
  echo "   Keeping build logs for debugging (build failed)"
fi

