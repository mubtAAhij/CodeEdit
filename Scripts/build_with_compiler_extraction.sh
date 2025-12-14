#!/usr/bin/env bash

set -uo pipefail  # Remove -e to allow graceful error handling

PROJECT_PATH="${1:-YourApp.xcodeproj}"
SCHEME="${2:-YourApp}"
CONFIGURATION="${3:-Debug}"

# Detect if we have a workspace or project
# Check for workspace first (preferred), then project
PROJECT_TYPE="project"
if echo "$PROJECT_PATH" | grep -q "\.xcworkspace$"; then
  PROJECT_TYPE="workspace"
  echo "✅ Using workspace: $PROJECT_PATH"
elif [ -d "$PROJECT_PATH/project.xcworkspace" ]; then
  # Common pattern: workspace inside .xcodeproj
  WORKSPACE_PATH="$PROJECT_PATH/project.xcworkspace"
  PROJECT_TYPE="workspace"
  echo "✅ Found workspace inside project: $WORKSPACE_PATH"
  PROJECT_PATH="$WORKSPACE_PATH"
elif [ -d "$PROJECT_PATH" ] && [ -f "$PROJECT_PATH/project.pbxproj" ]; then
  PROJECT_TYPE="project"
  echo "✅ Using project: $PROJECT_PATH"
else
  echo "⚠️  Could not determine project type, assuming project"
  PROJECT_TYPE="project"
fi

# Helper function to build xcodebuild command with correct project/workspace flag
xcodebuild_cmd() {
  if [ "$PROJECT_TYPE" = "workspace" ]; then
    xcodebuild -workspace "$PROJECT_PATH" -scheme "$SCHEME" "$@"
  else
    xcodebuild -project "$PROJECT_PATH" -scheme "$SCHEME" "$@"
  fi
}

# Detect available destinations and choose appropriate one
echo "🔍 Detecting available build destinations..."
AVAILABLE_DESTINATIONS=$(xcodebuild_cmd -showdestinations 2>/dev/null || echo "")

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
VERIFY_SETTINGS=$(xcodebuild_cmd -showBuildSettings 2>/dev/null | grep -E "(SWIFT_EMIT_LOC_STRINGS|LOCALIZED_STRING)" || echo "")
if [ -n "$VERIFY_SETTINGS" ]; then
  echo "📋 Current build settings:"
  echo "$VERIFY_SETTINGS" | sed 's/^/   /'
else
  echo "⚠️  Could not verify build settings (will set via xcodebuild args)"
fi

# Save build output to file for debugging
BUILD_LOG_RAW="build_output_raw.log"

# Disable SwiftLint and other plugins - we only need string extraction, not linting
export SWIFTLINT_DISABLE=YES
export SWIFTLINT_SKIP_BUILD_PHASE=YES
export DISABLE_SWIFTLINT=YES

# Run xcodebuild and capture raw log (NO xcpretty - we need to see actual swiftc invocations)
echo "🔨 Starting build (plugins disabled for string extraction only)..."
echo "💡 Using raw xcodebuild output (no xcpretty) to ensure we capture all emit-local flags"
# Use -skipPackagePluginValidation to skip SwiftLint and other plugin validation
# Force a REAL build of the app target (not preview/link noise)
# Note: xcodebuild compiles files in parallel, so many files may compile successfully
# before hitting an error. Strings from successfully compiled files will be extracted.
xcodebuild_cmd \
  -configuration "$CONFIGURATION" \
  -destination "$DESTINATION" \
  CODE_SIGNING_ALLOWED=NO \
  SWIFT_EMIT_LOC_STRINGS=YES \
  LOCALIZED_STRING_SWIFTUI_SUPPORT=YES \
  -skipPackagePluginValidation \
  build 2>&1 | tee "$BUILD_LOG_RAW"

BUILD_EXIT_CODE=${PIPESTATUS[0]}

# Diagnostic: Check if compiler was actually asked to emit strings
echo ""
echo "🔍 Checking if Swift compiler was invoked with emit-localized-strings flags..."
EMIT_FLAGS_FOUND=$(grep -c "emit-local" "$BUILD_LOG_RAW" 2>/dev/null || echo "0")
if [ "$EMIT_FLAGS_FOUND" -gt 0 ]; then
  echo "✅ Found $EMIT_FLAGS_FOUND 'emit-local' flags in build log - compiler was asked to emit strings"
  echo "📝 Sample emit-local flags found:"
  grep -n "emit-local" "$BUILD_LOG_RAW" 2>/dev/null | head -5 | sed 's/^/   /'
else
  echo "⚠️  WARNING: No 'emit-local' flags found in build log!"
  echo "   This suggests SWIFT_EMIT_LOC_STRINGS=YES may not be taking effect"
  echo "   Checking for other localized string related flags..."
  grep -n "localized\|stringsdata" "$BUILD_LOG_RAW" 2>/dev/null | head -20 || echo "   (no localized flags found)"
fi
echo ""

# Check for stringsdata files (compiler's extracted-strings intermediate output)
echo "🔍 Checking for compiler-emitted .stringsdata files (intermediate output)..."
STRINGSDATA_COUNT=$(grep -c "stringsdata" "$BUILD_LOG_RAW" 2>/dev/null || echo "0")
if [ "$STRINGSDATA_COUNT" -gt 0 ]; then
  echo "✅ Found $STRINGSDATA_COUNT references to .stringsdata files - compiler is producing extracted localization data"
  echo "📝 Sample .stringsdata references:"
  grep -n "stringsdata" "$BUILD_LOG_RAW" 2>/dev/null | head -5 | sed 's/^/   /'
else
  echo "⚠️  No .stringsdata references found in build log"
fi
echo ""

if [ $BUILD_EXIT_CODE -eq 0 ]; then
  echo "✅ Build completed successfully. String Catalogs should be updated."
else
  echo "⚠️  Build completed with exit code $BUILD_EXIT_CODE"
  echo "📋 Showing last 50 lines of build output for debugging:"
  tail -50 "$BUILD_LOG_RAW" || true
  echo ""
  echo "⚠️  Build had errors, but attempting to merge emitted strings anyway..."
  echo "💡 Note: xcodebuild compiles files in parallel, so many Swift files may have compiled successfully"
  echo "💡 Even if the build failed, we'll try to merge strings from successfully compiled files"
fi

# CRITICAL CHECK: Look for the "bridge artifact" Localizable.strings that Xcode should produce
# This is the compiled localization output that Xcode uses to update the catalog
echo ""
echo "🔍 Checking for bridge artifact: Localizable.strings (compiled localization output)..."
BUILD_DIR=$(xcodebuild -project "$PROJECT_PATH" -scheme "$SCHEME" -showBuildSettings 2>/dev/null | grep -m 1 "BUILD_DIR" | sed 's/.*= *//' | xargs || echo "")
if [ -n "$BUILD_DIR" ]; then
  DERIVED_DATA_DIR=$(echo "$BUILD_DIR" | sed 's|/Build/Products.*||')
  INTERMEDIATES_DIR=$(echo "$BUILD_DIR" | sed 's|/Build/Products|/Build/Intermediates.noindex|')
  
  # Search for Localizable.strings in the expected location (*.lproj/Localizable.strings)
  BRIDGE_STRINGS=$(find "$DERIVED_DATA_DIR" -path '*/*.lproj/Localizable.strings' -type f 2>/dev/null | grep -v "/SourcePackages/" | grep -v "/Products/" | head -10 || echo "")
  
  if [ -n "$BRIDGE_STRINGS" ]; then
    BRIDGE_COUNT=$(echo "$BRIDGE_STRINGS" | wc -l | xargs)
    echo "✅ Found $BRIDGE_COUNT Localizable.strings bridge artifact(s):"
    echo "$BRIDGE_STRINGS" | sed 's/^/   /'
    echo "💡 These are the compiled localization outputs that Xcode should use to update .xcstrings"
  else
    echo "⚠️  WARNING: No Localizable.strings bridge artifacts found!"
    echo "   This means Xcode did NOT produce the compiled localization output"
    echo "   The pipeline stopped at *.stringsdata and never created the bridge artifacts"
    echo "   Will fall back to manual import from *.stringsdata files"
    echo ""
    echo "   Searched in:"
    echo "   - DerivedData: $DERIVED_DATA_DIR"
    echo "   - Intermediates: $INTERMEDIATES_DIR"
  fi
else
  echo "⚠️  Could not determine DerivedData path for bridge artifact check"
fi
echo ""

# Check if strings were already merged into the catalog by Xcode
echo "🔍 Checking string catalog for merged strings..."

# Find the xcstrings file (look in common locations)
XCSTRINGS_FILE=$(find . -name "*.xcstrings" -type f | head -1)

if [ -z "$XCSTRINGS_FILE" ]; then
  echo "⚠️  No .xcstrings file found"
  exit 1
fi

echo "📋 Found string catalog: $XCSTRINGS_FILE"

# Check initial catalog count (before merging emitted strings)
INITIAL_CATALOG_COUNT=0
if command -v jq &> /dev/null; then
  INITIAL_CATALOG_COUNT=$(jq '.strings | length' "$XCSTRINGS_FILE" 2>/dev/null || echo "0")
fi

if [ "$INITIAL_CATALOG_COUNT" -gt 0 ]; then
  echo "📊 Catalog contains $INITIAL_CATALOG_COUNT strings (from existing sources)"
  echo "💡 Now checking for NEW strings emitted by the build..."
else
  echo "📊 Catalog is empty - will extract strings from build"
fi

# Always check for emitted strings after build (even if catalog already has strings)
# Xcode should automatically merge emitted strings during build, but we verify and merge manually if needed
CATALOG_COUNT=$INITIAL_CATALOG_COUNT

# First, check if Xcode automatically merged strings during the build
if command -v jq &> /dev/null; then
  CURRENT_COUNT=$(jq '.strings | length' "$XCSTRINGS_FILE" 2>/dev/null || echo "0")
  if [ "$CURRENT_COUNT" -gt "$INITIAL_CATALOG_COUNT" ]; then
    NEW_STRINGS=$((CURRENT_COUNT - INITIAL_CATALOG_COUNT))
    echo "✅ Xcode automatically merged $NEW_STRINGS new strings during build!"
    echo "✅ Catalog now contains $CURRENT_COUNT strings total"
    CATALOG_COUNT=$CURRENT_COUNT
  else
    echo "⚠️  No new strings were automatically merged by Xcode"
    echo "💡 Will search DerivedData for emitted strings and merge manually..."
  fi
fi

# Always search for emitted strings and merge them (even if catalog already has some)
# This ensures we capture ALL strings emitted by the build, not just what Xcode auto-merged
echo ""
echo "🔄 Searching for compiler-emitted strings from the build..."

# Get DerivedData path from build settings
BUILD_DIR=$(xcodebuild_cmd -showBuildSettings 2>/dev/null | grep -m 1 "BUILD_DIR" | sed 's/.*= *//' | xargs || echo "")

if [ -n "$BUILD_DIR" ]; then
  # Convert BUILD_DIR to Intermediates path
  INTERMEDIATES_DIR=$(echo "$BUILD_DIR" | sed 's|/Build/Products|/Build/Intermediates.noindex|')
  
  # Search for compiler-emitted strings in specific locations
  # Search for both .strings and .stringsdata files
  echo "📊 Searching for emitted .strings files..."
  EMITTED_STRINGS_FILES=$(find "$INTERMEDIATES_DIR" \( -path "*/en.lproj/*.strings" -o -path "*/Objects-normal/*/*.strings" \) -type f 2>/dev/null | grep -v "/SourcePackages/" | grep -v "/Products/" | grep -v ".framework/" | head -50 || echo "")
  
  # Search for .stringsdata files (newer binary format)
  echo "📊 Searching for emitted .stringsdata files..."
  EMITTED_STRINGSDATA_FILES=$(find "$INTERMEDIATES_DIR" -path "*/Objects-normal/*/*.stringsdata" -type f 2>/dev/null | grep -v "/SourcePackages/" | grep -v "/Products/" | grep -v ".framework/" | head -50 || echo "")
  
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
    echo "💡 This is the manual import fallback - converting *.stringsdata/intermediates into .xcstrings"
    
    # Use Python script to merge strings (supports both .strings and .stringsdata)
    if [ -f "./Scripts/merge_emitted_strings.py" ]; then
      # Pass the Intermediates directory to the merge script so it can find both .strings and .stringsdata files
      # This is safer than passing individual file paths which might have spaces
      # The merge script will handle conversion from *.stringsdata binary format to .xcstrings JSON
      python3 ./Scripts/merge_emitted_strings.py "$XCSTRINGS_FILE" "$INTERMEDIATES_DIR" || {
        echo "⚠️  Failed to merge strings via Python script"
        echo "💡 This is the critical fallback - if this fails, strings won't be imported"
      }
      
      # Verify merge succeeded
      if command -v jq &> /dev/null; then
        FINAL_COUNT=$(jq '.strings | length' "$XCSTRINGS_FILE" 2>/dev/null || echo "0")
        if [ "$FINAL_COUNT" -gt "$INITIAL_CATALOG_COUNT" ]; then
          NEW_STRINGS=$((FINAL_COUNT - INITIAL_CATALOG_COUNT))
          echo "✅ Successfully merged $NEW_STRINGS new strings into catalog via manual import"
          echo "✅ Catalog now contains $FINAL_COUNT strings total (was $INITIAL_CATALOG_COUNT)"
          CATALOG_COUNT=$FINAL_COUNT
        else
          echo "⚠️  Merge completed but no new strings were added"
          echo "💡 Catalog still contains $FINAL_COUNT strings (same as before merge)"
          echo "💡 This might mean:"
          echo "   - Strings were already in the catalog"
          echo "   - Merge script couldn't parse the .stringsdata files"
          echo "   - No new strings were actually emitted"
        fi
      fi
    else
      echo "❌ CRITICAL: merge_emitted_strings.py not found!"
      echo "   Cannot perform manual import from *.stringsdata files"
      echo "   This is the fallback mechanism - without it, strings won't be imported"
    fi
  else
    echo "⚠️  No compiler-emitted strings files found in DerivedData"
    echo "💡 This might mean:"
    echo "   1. No strings were emitted (check SWIFT_EMIT_LOC_STRINGS setting)"
    echo "   2. Strings are in a different location"
    echo "   3. Existing .strings files in project may prevent emission"
    echo "   4. Strings were already merged by Xcode during build"
    echo ""
    echo "🔍 Performing broader search for any localization artifacts..."
    DERIVED_DATA_DIR=$(echo "$BUILD_DIR" | sed 's|/Build/Products.*||')
    BROAD_SEARCH=$(find "$DERIVED_DATA_DIR" -type f 2>/dev/null \
      | grep -Ev "/SourcePackages/|/Products/|\\.framework/" \
      | grep -Ei "\\.(strings|stringsdata|xcstrings)$" \
      | head -20 || echo "")
    
    if [ -n "$BROAD_SEARCH" ]; then
      echo "📁 Found localization artifacts in broader search:"
      echo "$BROAD_SEARCH" | sed 's/^/   /'
      echo "💡 These might be in unexpected locations - consider updating search paths"
    fi
    
    # Try using xcodebuild -exportLocalizations as a fallback (to capture any strings Xcode found)
    echo ""
    echo "🔄 Trying xcodebuild -exportLocalizations to extract strings..."
    EXPORT_DIR="./LocalizationsExport"
    mkdir -p "$EXPORT_DIR"
    
    # Get DerivedData path from build settings to reuse existing build
    # BUILD_DIR is typically: /path/to/DerivedData/ProjectName-hash/Build/Products/Configuration
    # We want: /path/to/DerivedData/ProjectName-hash
    BUILD_DIR_SETTING=$(xcodebuild_cmd -showBuildSettings 2>/dev/null | grep -m 1 "^ *BUILD_DIR" | sed 's/.*= *//' | xargs || echo "")
    if [ -n "$BUILD_DIR_SETTING" ]; then
      # Strip /Build and everything after it to get DerivedData root
      DERIVED_DATA_PATH=$(echo "$BUILD_DIR_SETTING" | sed 's|/Build.*||' | xargs)
    else
      DERIVED_DATA_PATH=""
    fi
    
    # Build exportLocalizations command with scheme and derivedDataPath
    if [ "$PROJECT_TYPE" = "workspace" ]; then
      EXPORT_CMD="xcodebuild -exportLocalizations -workspace \"$PROJECT_PATH\""
    else
      EXPORT_CMD="xcodebuild -exportLocalizations -project \"$PROJECT_PATH\""
    fi
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
          # Merge the exported .xcstrings into our catalog (preserving existing entries)
          if [ -f "./Scripts/merge_emitted_strings.py" ]; then
            # Merge the exported .xcstrings into our catalog
            python3 ./Scripts/merge_emitted_strings.py "$XCSTRINGS_FILE" "$XCSTRINGS_IN_XCLOC" || {
              echo "⚠️  Merge failed, trying direct copy..."
              # Fallback: if merge fails, just copy the file (it should have all strings)
              cp "$XCSTRINGS_IN_XCLOC" "$XCSTRINGS_FILE" && echo "✅ Copied exported .xcstrings file"
            }
            
            # Verify merge succeeded
            if command -v jq &> /dev/null; then
              FINAL_COUNT=$(jq '.strings | length' "$XCSTRINGS_FILE" 2>/dev/null || echo "0")
              if [ "$FINAL_COUNT" -gt "$INITIAL_CATALOG_COUNT" ]; then
                NEW_STRINGS=$((FINAL_COUNT - INITIAL_CATALOG_COUNT))
                echo "✅ Successfully merged $NEW_STRINGS new strings via exportLocalizations"
                echo "✅ Catalog now contains $FINAL_COUNT strings total"
                CATALOG_COUNT=$FINAL_COUNT
              fi
            fi
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
                # Note: XLIFF strings are for skip list only, not merged into .xcstrings
                # The .xcstrings file should already have strings from the build
              fi
            fi
          else
            echo "⚠️  No .xcstrings or .xliff files found in .xcloc"
          fi
        fi
      else
        echo "⚠️  No .xcloc file found in export directory"
      fi
    else
      echo "⚠️  exportLocalizations failed"
    fi  # Close the "if eval "$EXPORT_CMD" ..." block
  fi  # Close the "if [ "$FILES_TO_MERGE" -gt 0 ]" else block
else
  echo "⚠️  Could not determine DerivedData path"
fi  # Close the "if [ -n "$BUILD_DIR" ]" block

# Final summary
echo ""
echo "📊 Final string catalog status:"
if command -v jq &> /dev/null; then
  FINAL_COUNT=$(jq '.strings | length' "$XCSTRINGS_FILE" 2>/dev/null || echo "0")
  if [ "$FINAL_COUNT" -gt "$INITIAL_CATALOG_COUNT" ]; then
    NEW_STRINGS=$((FINAL_COUNT - INITIAL_CATALOG_COUNT))
    echo "✅ Successfully extracted $NEW_STRINGS new strings from build"
    echo "✅ Catalog contains $FINAL_COUNT strings total (was $INITIAL_CATALOG_COUNT)"
  elif [ "$FINAL_COUNT" -gt 0 ]; then
    echo "✅ Catalog contains $FINAL_COUNT strings (no new strings added by build)"
  else
    echo "⚠️  Catalog is empty - no strings were extracted"
  fi
fi

# Diagnostic: Show build log analysis before cleanup
echo ""
echo "🔍 Build log analysis for string emission:"
if [ -f "$BUILD_LOG_RAW" ]; then
  echo "   Build log size: $(wc -l < "$BUILD_LOG_RAW" | xargs) lines"
  echo "   Checking for emit-localized-strings flags..."
  EMIT_COUNT=$(grep -c "emit-local" "$BUILD_LOG_RAW" 2>/dev/null || echo "0")
  STRINGSDATA_COUNT=$(grep -c "stringsdata" "$BUILD_LOG_RAW" 2>/dev/null || echo "0")
  if [ "$EMIT_COUNT" -gt 0 ]; then
    echo "   ✅ Found $EMIT_COUNT references to 'emit-local' flags"
  else
    echo "   ⚠️  No 'emit-local' flags found in build log"
  fi
  if [ "$STRINGSDATA_COUNT" -gt 0 ]; then
    echo "   ✅ Found $STRINGSDATA_COUNT references to '.stringsdata' files"
  fi
fi

# Clean up log files (but keep raw log for diagnostics if build failed)
# Note: We keep BUILD_LOG_RAW for debugging since it contains the actual swiftc invocations
if [ $BUILD_EXIT_CODE -eq 0 ]; then
  # Optionally remove log file to save space (comment out if you want to keep it)
  # rm -f "$BUILD_LOG_RAW"
  echo "   Build log saved to: $BUILD_LOG_RAW"
else
  echo "   Keeping build log for debugging (build failed): $BUILD_LOG_RAW"
fi

