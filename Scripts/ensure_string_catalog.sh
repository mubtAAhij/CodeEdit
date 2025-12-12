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
    echo "$XCSTRINGS_FILES" | while read -r file; do
        echo "  - $file"
    done
    exit 0
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

# Create minimal valid String Catalog using plutil to ensure exact format Xcode expects
# Xcode's builtin-copyStrings is very strict - it expects property list JSON format
if [ ! -f "$XCSTRINGS_PATH" ]; then
    # Create a temporary plist file first, then convert to JSON
    TEMP_PLIST=$(mktemp)
    python3 -c "
import plistlib
import sys

catalog = {
    'sourceLanguage': 'en',
    'version': '1.0',
    'strings': {}
}

# Write as binary plist first
with open(sys.argv[1], 'wb') as f:
    plistlib.dump(catalog, f, fmt=plistlib.FMT_BINARY)
" "$TEMP_PLIST"
    
    # Use plutil to convert binary plist to JSON (this ensures exact format Xcode expects)
    if command -v plutil &> /dev/null; then
        if plutil -convert json -o "$XCSTRINGS_PATH" "$TEMP_PLIST" 2>/dev/null; then
            # Ensure trailing newline
            if [ "$(tail -c 1 "$XCSTRINGS_PATH" | od -An -tx1 | tr -d ' \n')" != "0a" ]; then
                echo "" >> "$XCSTRINGS_PATH"
            fi
            # Validate the final file
            if plutil -lint "$XCSTRINGS_PATH" &> /dev/null; then
                echo "✅ Created and validated $XCSTRINGS_PATH using plutil"
            else
                echo "⚠️  Created file but plutil validation failed"
            fi
        else
            echo "⚠️  plutil conversion failed, trying alternative method..."
            # Fallback: create JSON directly and validate
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
            echo "✅ Created $XCSTRINGS_PATH (fallback method)"
        fi
        rm -f "$TEMP_PLIST"
    else
        # No plutil available, create JSON directly
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
        echo "✅ Created $XCSTRINGS_PATH (plutil not available)"
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

