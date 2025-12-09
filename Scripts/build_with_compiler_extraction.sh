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
# This flag is available in Xcode 15.0+ and allows us to build without running plugins
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
  echo "⚠️  Continuing to generate skip list (may be empty if build didn't compile Swift files)"
  echo "💡 Tip: Check the build log above to see why the build failed"
fi

# Clean up log file
rm -f "$BUILD_LOG"

