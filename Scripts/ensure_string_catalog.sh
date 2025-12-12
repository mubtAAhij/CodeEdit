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
            # Quick JSON validation
            elif command -v python3 &> /dev/null; then
                if ! python3 -c "import json; json.load(open('$file', 'r', encoding='utf-8'))" &> /dev/null; then
                    echo "    ⚠️  File contains invalid JSON, will be recreated"
                    INVALID=1
                fi
            fi
            
            # plutil validation if available (most strict)
            if [ "$INVALID" -eq 0 ] && command -v plutil &> /dev/null; then
                if ! plutil -lint "$file" &> /dev/null; then
                    echo "    ⚠️  File fails plutil validation, will be recreated"
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

# Create minimal valid String Catalog in JSON format that Xcode expects
# Xcode's builtin-copyStrings expects valid JSON (not plist format)
if [ ! -f "$XCSTRINGS_PATH" ]; then
    # Create JSON directly - this is the format Xcode expects for .xcstrings files
    python3 -c "
import json
import sys

catalog = {
    'sourceLanguage': 'en',
    'version': '1.0',
    'strings': {}
}

# Use indent=2 and ensure_ascii=False for proper formatting
# Don't sort keys to match Xcode's format
json_str = json.dumps(catalog, indent=2, ensure_ascii=False)
with open(sys.argv[1], 'w', encoding='utf-8') as f:
    f.write(json_str)
    f.write('\n')
" "$XCSTRINGS_PATH"
    
    # Validate the file
    if command -v jq &> /dev/null; then
        if jq empty "$XCSTRINGS_PATH" &> /dev/null; then
            echo "✅ Created and validated $XCSTRINGS_PATH (valid JSON)"
        else
            echo "⚠️  Created file but JSON validation failed"
        fi
    elif command -v python3 &> /dev/null; then
        if python3 -c "import json; json.load(open('$XCSTRINGS_PATH', 'r', encoding='utf-8'))" &> /dev/null; then
            echo "✅ Created and validated $XCSTRINGS_PATH (valid JSON)"
        else
            echo "⚠️  Created file but JSON validation failed"
        fi
    else
        echo "✅ Created $XCSTRINGS_PATH"
    fi
    
    # Note: plutil -lint may fail on .xcstrings JSON files even though they're valid
    # This is because plutil expects plist format, but .xcstrings are JSON
    # Xcode's builtin-copyStrings will validate the actual format it needs
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
        # Validate using plutil if available
        if command -v plutil &> /dev/null; then
            if plutil -lint "$XCSTRINGS_PATH" &> /dev/null; then
                echo "✅ Existing file is valid JSON and passes plutil validation"
            else
                echo "⚠️  Existing file is valid JSON but fails plutil validation, recreating..."
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

with open(sys.argv[1], 'wb') as f:
    plistlib.dump(catalog, f, fmt=plistlib.FMT_BINARY)
" "$TEMP_PLIST"
                
                if plutil -convert json -o "$XCSTRINGS_PATH" "$TEMP_PLIST" 2>/dev/null; then
                    if [ "$(tail -c 1 "$XCSTRINGS_PATH" | od -An -tx1 | tr -d ' \n')" != "0a" ]; then
                        echo "" >> "$XCSTRINGS_PATH"
                    fi
                    if plutil -lint "$XCSTRINGS_PATH" &> /dev/null; then
                        echo "✅ Recreated and validated $XCSTRINGS_PATH using plutil"
                    else
                        echo "⚠️  Recreated file still fails plutil validation"
                    fi
                else
                    echo "⚠️  plutil conversion failed, trying fallback..."
                    python3 -c "
import json
import sys

catalog = {
    'sourceLanguage': 'en',
    'version': '1.0',
    'strings': {}
}

json_str = json.dumps(catalog, indent=2, ensure_ascii=False, sort_keys=True)
with open(sys.argv[1], 'w', encoding='utf-8') as f:
    f.write(json_str)
    f.write('\n')
" "$XCSTRINGS_PATH"
                    echo "✅ Recreated $XCSTRINGS_PATH (fallback method)"
                fi
                rm -f "$TEMP_PLIST"
            fi
        else
            echo "✅ Existing file is valid JSON"
        fi
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

with open(sys.argv[1], 'wb') as f:
    plistlib.dump(catalog, f, fmt=plistlib.FMT_BINARY)
" "$TEMP_PLIST"
        
        if command -v plutil &> /dev/null; then
            if plutil -convert json -o "$XCSTRINGS_PATH" "$TEMP_PLIST" 2>/dev/null; then
                if [ "$(tail -c 1 "$XCSTRINGS_PATH" | od -An -tx1 | tr -d ' \n')" != "0a" ]; then
                    echo "" >> "$XCSTRINGS_PATH"
                fi
                if plutil -lint "$XCSTRINGS_PATH" &> /dev/null; then
                    echo "✅ Recreated and validated $XCSTRINGS_PATH using plutil"
                else
                    echo "⚠️  Recreated file fails plutil validation"
                fi
            else
                echo "⚠️  plutil conversion failed, trying fallback..."
                python3 -c "
import json
import sys

catalog = {
    'sourceLanguage': 'en',
    'version': '1.0',
    'strings': {}
}

json_str = json.dumps(catalog, indent=2, ensure_ascii=False, sort_keys=True)
with open(sys.argv[1], 'w', encoding='utf-8') as f:
    f.write(json_str)
    f.write('\n')
" "$XCSTRINGS_PATH"
                echo "✅ Recreated $XCSTRINGS_PATH (fallback method)"
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

json_str = json.dumps(catalog, indent=2, ensure_ascii=False, sort_keys=True)
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

