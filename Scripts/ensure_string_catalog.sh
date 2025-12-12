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
            # JSON validation (plutil validation skipped - .xcstrings are JSON, not plist)
            elif command -v jq &> /dev/null; then
                if ! jq empty "$file" &> /dev/null; then
                    echo "    ⚠️  File contains invalid JSON, will be recreated"
                    INVALID=1
                fi
            elif command -v python3 &> /dev/null; then
                if ! python3 -c "import json; json.load(open('$file', 'r', encoding='utf-8'))" &> /dev/null; then
                    echo "    ⚠️  File contains invalid JSON, will be recreated"
                    INVALID=1
                fi
            fi
            
            # Note: plutil validation is intentionally skipped for .xcstrings files
            # .xcstrings files are JSON format, not plist format
            # plutil -lint will fail on valid JSON .xcstrings files
            
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

# Create minimal valid String Catalog in JSON format
# builtin-copyStrings requires the file to be parseable as a property list
# We create as XML plist first, then convert to JSON using plutil to ensure
# the exact format that builtin-copyStrings expects
if [ ! -f "$XCSTRINGS_PATH" ]; then
    # Create as XML plist first, then convert to JSON via plutil
    # This ensures the JSON is in the exact format that plutil produces
    TEMP_PLIST=$(mktemp)
    python3 -c "
import plistlib
import sys

catalog = {
    'sourceLanguage': 'en',
    'version': '1.0',
    'strings': {}
}

# Write as XML plist first
with open(sys.argv[1], 'wb') as f:
    plistlib.dump(catalog, f, fmt=plistlib.FMT_XML)
" "$TEMP_PLIST"
    
    # Convert to JSON using plutil (this creates the exact format builtin-copyStrings expects)
    if command -v plutil &> /dev/null; then
        # First validate XML plist
        if plutil -lint "$TEMP_PLIST" &>/dev/null; then
            # Convert to JSON - plutil's JSON output is what builtin-copyStrings can parse
            if plutil -convert json -o "$XCSTRINGS_PATH" "$TEMP_PLIST" 2>/dev/null; then
                # Verify plutil can read it back as a plist (ensures compatibility)
                if plutil -convert xml1 -o /dev/null "$XCSTRINGS_PATH" 2>/dev/null; then
                    # Ensure trailing newline
                    if [ "$(tail -c 1 "$XCSTRINGS_PATH" | od -An -tx1 | tr -d ' \n')" != "0a" ]; then
                        echo "" >> "$XCSTRINGS_PATH"
                    fi
                    echo "✅ Created $XCSTRINGS_PATH using plutil (Xcode-compatible JSON format)"
                else
                    echo "⚠️  plutil cannot read back JSON as plist, trying XML format..."
                    # Try XML plist format instead
                    cp "$TEMP_PLIST" "$XCSTRINGS_PATH"
                    if [ "$(tail -c 1 "$XCSTRINGS_PATH" | od -An -tx1 | tr -d ' \n')" != "0a" ]; then
                        echo "" >> "$XCSTRINGS_PATH"
                    fi
                    echo "✅ Created $XCSTRINGS_PATH as XML plist (builtin-copyStrings may require this)"
                fi
            else
                echo "⚠️  plutil JSON conversion failed, trying XML format..."
                cp "$TEMP_PLIST" "$XCSTRINGS_PATH"
                if [ "$(tail -c 1 "$XCSTRINGS_PATH" | od -An -tx1 | tr -d ' \n')" != "0a" ]; then
                    echo "" >> "$XCSTRINGS_PATH"
                fi
                echo "✅ Created $XCSTRINGS_PATH as XML plist"
            fi
        else
            echo "⚠️  XML plist validation failed, using direct JSON creation..."
            python3 -c "
import json
import sys

catalog = {
    'sourceLanguage': 'en',
    'version': '1.0',
    'strings': {}
}

json_str = json.dumps(catalog, ensure_ascii=False, sort_keys=True)
with open(sys.argv[1], 'w', encoding='utf-8') as f:
    f.write(json_str)
    f.write('\n')
" "$XCSTRINGS_PATH"
            echo "✅ Created $XCSTRINGS_PATH (direct JSON)"
        fi
        rm -f "$TEMP_PLIST"
    else
        # No plutil available, create JSON directly with sorted keys
        python3 -c "
import json
import sys

catalog = {
    'sourceLanguage': 'en',
    'version': '1.0',
    'strings': {}
}

# Use sort_keys=True to match plutil's output order
json_str = json.dumps(catalog, ensure_ascii=False, sort_keys=True)
with open(sys.argv[1], 'w', encoding='utf-8') as f:
    f.write(json_str)
    f.write('\n')
" "$XCSTRINGS_PATH"
        echo "✅ Created $XCSTRINGS_PATH (plutil not available)"
    fi
    
    # Validate JSON syntax (but skip plutil lint - it will fail on JSON)
    if command -v jq &> /dev/null; then
        if jq empty "$XCSTRINGS_PATH" &> /dev/null; then
            echo "✅ File is valid JSON"
        else
            echo "⚠️  File is not valid JSON"
        fi
    elif command -v python3 &> /dev/null; then
        if python3 -c "import json; json.load(open('$XCSTRINGS_PATH', 'r', encoding='utf-8'))" &> /dev/null; then
            echo "✅ File is valid JSON"
        else
            echo "⚠️  File is not valid JSON"
        fi
    fi
else
    echo "ℹ️ $XCSTRINGS_PATH already exists"
    # Validate existing file and ensure it has trailing newline
    if python3 -c "
import json
import sys
try:
    with open(sys.argv[1], 'r', encoding='utf-8') as f:
        json.load(f)
    sys.exit(0)
except Exception:
    sys.exit(1)
" "$XCSTRINGS_PATH" 2>/dev/null; then
        # Ensure trailing newline exists
        last_char=$(tail -c 1 "$XCSTRINGS_PATH" | od -An -tx1 | tr -d ' \n')
        if [ "$last_char" != "0a" ]; then
            echo "" >> "$XCSTRINGS_PATH"
        fi
        # Note: plutil -lint validation is skipped for .xcstrings files
        # .xcstrings files are JSON format, not plist format
        # plutil -lint will fail on valid JSON .xcstrings files
        echo "✅ Existing file is valid JSON"
    else
        echo "⚠️  Existing file is not valid JSON, recreating..."
        # Recreate using the same method as initial creation
        TEMP_PLIST=$(mktemp)
        python3 -c "
import plistlib
import sys

catalog = {
    'sourceLanguage': 'en',
    'version': '1.0',
    'strings': {}
}

# Write as XML plist first
with open(sys.argv[1], 'wb') as f:
    plistlib.dump(catalog, f, fmt=plistlib.FMT_XML)
" "$TEMP_PLIST"
        
        if command -v plutil &> /dev/null; then
            if plutil -lint "$TEMP_PLIST" &>/dev/null; then
                # Try JSON first (standard format for .xcstrings)
                if plutil -convert json -o "$XCSTRINGS_PATH" "$TEMP_PLIST" 2>/dev/null; then
                    # Verify plutil can read it back
                    if plutil -convert xml1 -o /dev/null "$XCSTRINGS_PATH" 2>/dev/null; then
                        if [ "$(tail -c 1 "$XCSTRINGS_PATH" | od -An -tx1 | tr -d ' \n')" != "0a" ]; then
                            echo "" >> "$XCSTRINGS_PATH"
                        fi
                        echo "✅ Recreated $XCSTRINGS_PATH using plutil (Xcode-compatible JSON)"
                    else
                        # If JSON doesn't work, try XML plist format
                        echo "⚠️  JSON format not readable by plutil, trying XML plist..."
                        cp "$TEMP_PLIST" "$XCSTRINGS_PATH"
                        if [ "$(tail -c 1 "$XCSTRINGS_PATH" | od -An -tx1 | tr -d ' \n')" != "0a" ]; then
                            echo "" >> "$XCSTRINGS_PATH"
                        fi
                        echo "✅ Recreated $XCSTRINGS_PATH as XML plist"
                    fi
                else
                    # Fallback to XML plist
                    cp "$TEMP_PLIST" "$XCSTRINGS_PATH"
                    if [ "$(tail -c 1 "$XCSTRINGS_PATH" | od -An -tx1 | tr -d ' \n')" != "0a" ]; then
                        echo "" >> "$XCSTRINGS_PATH"
                    fi
                    echo "✅ Recreated $XCSTRINGS_PATH as XML plist (fallback)"
                fi
            else
                echo "⚠️  XML plist validation failed, using direct JSON..."
                python3 -c "
import json
import sys

catalog = {
    'sourceLanguage': 'en',
    'version': '1.0',
    'strings': {}
}

json_str = json.dumps(catalog, ensure_ascii=False, sort_keys=True)
with open(sys.argv[1], 'w', encoding='utf-8') as f:
    f.write(json_str)
    f.write('\n')
" "$XCSTRINGS_PATH"
                echo "✅ Recreated $XCSTRINGS_PATH (direct JSON)"
            fi
            rm -f "$TEMP_PLIST"
        else
            python3 -c "
import json
import sys

catalog = {
    'sourceLanguage': 'en',
    'version': '1.0',
    'strings': {}
}

json_str = json.dumps(catalog, ensure_ascii=False, sort_keys=True)
with open(sys.argv[1], 'w', encoding='utf-8') as f:
    f.write(json_str)
    f.write('\n')
" "$XCSTRINGS_PATH"
            echo "✅ Recreated $XCSTRINGS_PATH (plutil not available)"
        fi
    fi
fi

echo "✅ String catalog ready at: $XCSTRINGS_PATH"
echo "ℹ️ Note: You may need to add this file to your Xcode project manually,"
echo "   or Xcode will auto-detect it when you build with SWIFT_EMIT_LOC_STRINGS=YES"

