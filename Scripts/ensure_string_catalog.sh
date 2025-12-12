#!/usr/bin/env bash

set -euo pipefail

# Usage:
#   ./Scripts/ensure_string_catalog.sh [project_path] [target_name]

PROJECT_PATH="${1:-}"
TARGET_NAME="${2:-}"

# Find first .xcodeproj if not provided
if [ -z "$PROJECT_PATH" ]; then
    PROJECT_PATH=$(find . -name "*.xcodeproj" -type d | head -n 1)
    if [ -z "$PROJECT_PATH" ]; then
        echo "❌ No .xcodeproj found"
        exit 1
    fi
fi

# Check if ANY .xcstrings already exist in the repo
XCSTRINGS_FILES=$(find . -name "*.xcstrings" -type f 2>/dev/null || true)

if [ -n "$XCSTRINGS_FILES" ]; then
    echo "✅ Found existing String Catalog(s):"
    VALID_FOUND=0
    while IFS= read -r file; do
        [ -z "$file" ] && continue
        echo "  - $file"
        # Validate each file
        if [ -f "$file" ]; then
            FILE_SIZE=$(wc -c < "$file" | xargs)
            INVALID=0
            
            # Check file size
            if [ "$FILE_SIZE" -lt 50 ]; then
                echo "    ⚠️  File is too small ($FILE_SIZE bytes), will be recreated"
                INVALID=1
            # Validate format - check if plutil can parse it (builtin-copyStrings uses same parser)
            elif command -v plutil &> /dev/null; then
                if ! plutil -convert xml1 -o /dev/null "$file" 2>/dev/null; then
                    echo "    ⚠️  File is not parseable by plutil, will be recreated"
                    INVALID=1
                fi
            fi
            
            if [ "$INVALID" -eq 1 ]; then
                rm -f "$file" && echo "    🗑️  Removed invalid file: $file"
            else
                VALID_FOUND=1
            fi
        fi
    done <<< "$XCSTRINGS_FILES"
    
    # If we found at least one valid file, exit
    if [ "$VALID_FOUND" -eq 1 ]; then
        echo "✅ Valid String Catalog(s) found, using existing file(s)"
        exit 0
    else
        echo "ℹ️  Existing files were invalid and removed, will create new one..."
    fi
fi

echo "ℹ️ No .xcstrings found. Creating a new Localizable.xcstrings..."

# Decide where to put the file - try common locations
LOCATIONS=(
    "Resources/Localizable.xcstrings"
    "Localizable.xcstrings"
    "$(dirname "$PROJECT_PATH")/Resources/Localizable.xcstrings"
)

XCSTRINGS_PATH=""
for location in "${LOCATIONS[@]}"; do
    if [ -d "$(dirname "$location")" ] || [ "$(dirname "$location")" = "." ]; then
        XCSTRINGS_PATH="$location"
        break
    fi
done

# Default to Resources/ if directory exists, otherwise root
if [ -z "$XCSTRINGS_PATH" ]; then
    if [ -d "Resources" ]; then
        XCSTRINGS_PATH="Resources/Localizable.xcstrings"
    else
        XCSTRINGS_PATH="Localizable.xcstrings"
    fi
fi

# Ensure directory exists
mkdir -p "$(dirname "$XCSTRINGS_PATH")"

# Create minimal valid String Catalog using plutil to ensure builtin-copyStrings compatibility
# Use plutil to create JSON format that plutil itself can parse (builtin-copyStrings uses same parser)
if [ ! -f "$XCSTRINGS_PATH" ]; then
    # Create using plutil - this ensures the exact format that builtin-copyStrings expects
    if command -v plutil &> /dev/null; then
        # Create a temporary XML plist first
        TEMP_PLIST=$(mktemp)
        python3 -c "
import plistlib
import sys

catalog = {
    'sourceLanguage': 'en',
    'version': '1.0',
    'strings': {}
}

with open(sys.argv[1], 'wb') as f:
    plistlib.dump(catalog, f, fmt=plistlib.FMT_XML)
" "$TEMP_PLIST"
        
        # Use plutil to convert to JSON - this creates JSON that plutil (and builtin-copyStrings) can parse
        if plutil -lint "$TEMP_PLIST" &>/dev/null; then
            # Convert to JSON using plutil - this ensures compatibility
            if plutil -convert json -o "$XCSTRINGS_PATH" "$TEMP_PLIST" 2>/dev/null; then
                # Verify plutil can read it back (ensures builtin-copyStrings compatibility)
                if plutil -convert xml1 -o /dev/null "$XCSTRINGS_PATH" 2>/dev/null; then
                    # Ensure trailing newline
                    if [ "$(tail -c 1 "$XCSTRINGS_PATH" | od -An -tx1 | tr -d ' \n')" != "0a" ]; then
                        echo "" >> "$XCSTRINGS_PATH"
                    fi
                    echo "✅ Created $XCSTRINGS_PATH using plutil (builtin-copyStrings compatible JSON)"
                else
                    echo "⚠️  plutil cannot read JSON back, trying XML format..."
                    cp "$TEMP_PLIST" "$XCSTRINGS_PATH"
                    if [ "$(tail -c 1 "$XCSTRINGS_PATH" | od -An -tx1 | tr -d ' \n')" != "0a" ]; then
                        echo "" >> "$XCSTRINGS_PATH"
                    fi
                    echo "✅ Created $XCSTRINGS_PATH as XML plist"
                fi
            else
                echo "⚠️  plutil JSON conversion failed, using XML format..."
                cp "$TEMP_PLIST" "$XCSTRINGS_PATH"
                if [ "$(tail -c 1 "$XCSTRINGS_PATH" | od -An -tx1 | tr -d ' \n')" != "0a" ]; then
                    echo "" >> "$XCSTRINGS_PATH"
                fi
                echo "✅ Created $XCSTRINGS_PATH as XML plist"
            fi
        else
            echo "⚠️  XML plist validation failed"
            rm -f "$TEMP_PLIST"
            exit 1
        fi
        rm -f "$TEMP_PLIST"
    else
        # Fallback: create JSON directly (may not work with builtin-copyStrings)
        python3 -c "
import json
import sys

catalog = {
    'sourceLanguage': 'en',
    'version': '1.0',
    'strings': {}
}

json_str = json.dumps(catalog, ensure_ascii=False, sort_keys=True, indent=2)
with open(sys.argv[1], 'w', encoding='utf-8') as f:
    f.write(json_str)
    f.write('\n')
" "$XCSTRINGS_PATH"
        echo "⚠️  Created $XCSTRINGS_PATH as JSON (plutil not available - may fail builtin-copyStrings validation)"
    fi
    
    # Validate format - check if plutil can parse it (builtin-copyStrings uses same parser)
    if command -v plutil &> /dev/null; then
        # Test if plutil can read it (works for both JSON and XML plist)
        if plutil -convert xml1 -o /dev/null "$XCSTRINGS_PATH" 2>/dev/null; then
            echo "✅ File is parseable by plutil (builtin-copyStrings compatible)"
        else
            echo "⚠️  File is not parseable by plutil - may fail builtin-copyStrings validation"
        fi
    fi
else
    echo "ℹ️ $XCSTRINGS_PATH already exists"
    # Validate existing file - check if plutil can parse it (builtin-copyStrings uses same parser)
    if command -v plutil &> /dev/null; then
        if plutil -convert xml1 -o /dev/null "$XCSTRINGS_PATH" 2>/dev/null; then
            # Ensure trailing newline exists
            last_char=$(tail -c 1 "$XCSTRINGS_PATH" | od -An -tx1 | tr -d ' \n')
            if [ "$last_char" != "0a" ]; then
                echo "" >> "$XCSTRINGS_PATH"
            fi
            echo "✅ Existing file is parseable by plutil (builtin-copyStrings compatible)"
        else
            echo "⚠️  Existing file is not parseable by plutil, recreating..."
            # Recreate using plutil
            TEMP_PLIST=$(mktemp)
            python3 -c "
import plistlib
import sys

catalog = {
    'sourceLanguage': 'en',
    'version': '1.0',
    'strings': {}
}

with open(sys.argv[1], 'wb') as f:
    plistlib.dump(catalog, f, fmt=plistlib.FMT_XML)
" "$TEMP_PLIST"
            
            if plutil -lint "$TEMP_PLIST" &>/dev/null; then
                # Convert to JSON using plutil
                if plutil -convert json -o "$XCSTRINGS_PATH" "$TEMP_PLIST" 2>/dev/null; then
                    if plutil -convert xml1 -o /dev/null "$XCSTRINGS_PATH" 2>/dev/null; then
                        if [ "$(tail -c 1 "$XCSTRINGS_PATH" | od -An -tx1 | tr -d ' \n')" != "0a" ]; then
                            echo "" >> "$XCSTRINGS_PATH"
                        fi
                        echo "✅ Recreated $XCSTRINGS_PATH using plutil (builtin-copyStrings compatible JSON)"
                    else
                        cp "$TEMP_PLIST" "$XCSTRINGS_PATH"
                        if [ "$(tail -c 1 "$XCSTRINGS_PATH" | od -An -tx1 | tr -d ' \n')" != "0a" ]; then
                            echo "" >> "$XCSTRINGS_PATH"
                        fi
                        echo "✅ Recreated $XCSTRINGS_PATH as XML plist"
                    fi
                else
                    cp "$TEMP_PLIST" "$XCSTRINGS_PATH"
                    if [ "$(tail -c 1 "$XCSTRINGS_PATH" | od -An -tx1 | tr -d ' \n')" != "0a" ]; then
                        echo "" >> "$XCSTRINGS_PATH"
                    fi
                    echo "✅ Recreated $XCSTRINGS_PATH as XML plist"
                fi
            else
                echo "⚠️  XML plist validation failed"
            fi
            rm -f "$TEMP_PLIST"
        fi
    else
        echo "⚠️  plutil not available, cannot validate file"
    fi
fi

echo "✅ String catalog ready at: $XCSTRINGS_PATH"
echo "ℹ️ Note: You may need to add this file to your Xcode project manually,"
echo "   or Xcode will auto-detect it when you build with SWIFT_EMIT_LOC_STRINGS=YES"

