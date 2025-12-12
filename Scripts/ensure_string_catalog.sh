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

# Create minimal valid String Catalog JSON using Python to ensure proper formatting
# Xcode's builtin-copyStrings is very strict about the format, so we ensure:
# 1. Valid JSON
# 2. Trailing newline
# 3. UTF-8 encoding
if [ ! -f "$XCSTRINGS_PATH" ]; then
    python3 -c "
import json
import sys

catalog = {
    'sourceLanguage': 'en',
    'version': '1.0',
    'strings': {}
}

# Write with proper JSON formatting and trailing newline
with open(sys.argv[1], 'w', encoding='utf-8', newline='') as f:
    json.dump(catalog, f, indent=2, ensure_ascii=False)
    f.write('\n')  # Ensure trailing newline
    
# Validate the JSON we just wrote
with open(sys.argv[1], 'r', encoding='utf-8') as f:
    json.load(f)  # This will raise an exception if invalid
" "$XCSTRINGS_PATH"
    echo "✅ Created $XCSTRINGS_PATH"
else
    echo "ℹ️ $XCSTRINGS_PATH already exists"
    # Validate existing file and ensure it has trailing newline
    if python3 -c "import json, sys; json.load(open(sys.argv[1], 'r', encoding='utf-8'))" "$XCSTRINGS_PATH" 2>/dev/null; then
        # Ensure trailing newline exists
        if [ "$(tail -c 1 "$XCSTRINGS_PATH" | wc -l)" -eq 0 ]; then
            echo "" >> "$XCSTRINGS_PATH"
        fi
        echo "✅ Existing file is valid JSON"
    else
        echo "⚠️  Existing file is not valid JSON, recreating..."
        python3 -c "
import json
import sys

catalog = {
    'sourceLanguage': 'en',
    'version': '1.0',
    'strings': {}
}

with open(sys.argv[1], 'w', encoding='utf-8', newline='') as f:
    json.dump(catalog, f, indent=2, ensure_ascii=False)
    f.write('\n')  # Ensure trailing newline
" "$XCSTRINGS_PATH"
        echo "✅ Recreated $XCSTRINGS_PATH"
    fi
fi

echo "✅ String catalog ready at: $XCSTRINGS_PATH"
echo "ℹ️ Note: You may need to add this file to your Xcode project manually,"
echo "   or Xcode will auto-detect it when you build with SWIFT_EMIT_LOC_STRINGS=YES"

