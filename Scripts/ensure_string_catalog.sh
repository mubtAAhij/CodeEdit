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
                # Validate each file (JSON check - Xcode format)
                if [ -f "$file" ]; then
                    FILE_SIZE=$(wc -c < "$file" | xargs)
                    INVALID=0
                    
                    # Check file size
                    if [ "$FILE_SIZE" -lt 50 ]; then
                        echo "    ⚠️  File is too small ($FILE_SIZE bytes), will be recreated"
                        INVALID=1
                    # Validate format - check if it's valid JSON (Xcode format)
                    elif ! python3 -c "import json; json.load(open('$file'))" 2>/dev/null; then
                        echo "    ⚠️  File is not valid JSON, will be recreated"
                        INVALID=1
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

# Create minimal valid String Catalog in JSON format (as Xcode expects)
# Xcode creates .xcstrings files as JSON, not XML plist
# This matches the format Xcode uses when creating a new String Catalog
if [ ! -f "$XCSTRINGS_PATH" ]; then
    python3 -c "
import json
import sys

catalog = {
    'sourceLanguage': 'en',
    'strings': {},
    'version': '1.1'
}

# Match Xcode's exact format: JSON with spaces after colons, sorted keys
json_str = json.dumps(catalog, ensure_ascii=False, indent=2, sort_keys=False)
with open(sys.argv[1], 'w', encoding='utf-8') as f:
    f.write(json_str)
    f.write('\n')
" "$XCSTRINGS_PATH"
    echo "✅ Created $XCSTRINGS_PATH in JSON format (Xcode-compatible)"
else
    echo "ℹ️ $XCSTRINGS_PATH already exists"
    # Ensure it's valid JSON (Xcode format)
    if python3 -c "import json; json.load(open('$XCSTRINGS_PATH'))" 2>/dev/null; then
        echo "✅ Existing file is valid JSON (Xcode-compatible)"
    else
        echo "⚠️  Existing file is not valid JSON, recreating..."
        python3 -c "
import json
import sys

catalog = {
    'sourceLanguage': 'en',
    'strings': {},
    'version': '1.1'
}

json_str = json.dumps(catalog, ensure_ascii=False, indent=2, sort_keys=False)
with open(sys.argv[1], 'w', encoding='utf-8') as f:
    f.write(json_str)
    f.write('\n')
" "$XCSTRINGS_PATH"
        echo "✅ Recreated $XCSTRINGS_PATH in JSON format"
    fi
fi

echo "✅ String catalog ready at: $XCSTRINGS_PATH"
echo "ℹ️ Note: You may need to add this file to your Xcode project manually,"
echo "   or Xcode will auto-detect it when you build with SWIFT_EMIT_LOC_STRINGS=YES"

