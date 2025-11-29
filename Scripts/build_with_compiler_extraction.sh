#!/usr/bin/env bash

set -uo pipefail  # Remove -e to allow graceful error handling

PROJECT_PATH="${1:-YourApp.xcodeproj}"
SCHEME="${2:-YourApp}"
CONFIGURATION="${3:-Debug}"

# Use a generic iOS Simulator destination to avoid signing.
DESTINATION="generic/platform=iOS Simulator"

echo "🏗  Ensuring String Catalog exists..."
./Scripts/ensure_string_catalog.sh "$PROJECT_PATH" "$SCHEME" || {
  echo "⚠️  Warning: Failed to ensure string catalog, continuing anyway..."
}

echo "🏗  Running unsigned build with compiler-based string extraction..."

# Run xcodebuild and capture exit code
if xcodebuild \
  -project "$PROJECT_PATH" \
  -scheme "$SCHEME" \
  -configuration "$CONFIGURATION" \
  -destination "$DESTINATION" \
  CODE_SIGNING_ALLOWED=NO \
  SWIFT_EMIT_LOC_STRINGS=YES \
  LOCALIZED_STRING_SWIFTUI_SUPPORT=YES \
  build 2>&1 | xcpretty; then
  echo "✅ Build completed successfully. String Catalogs should be updated."
else
  BUILD_EXIT_CODE=${PIPESTATUS[0]}
  echo "⚠️  Build completed with exit code $BUILD_EXIT_CODE (this is okay, continuing to generate skip list)"
  echo "⚠️  Note: If no strings were extracted, the skip list will be empty"
fi

