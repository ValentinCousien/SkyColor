#!/bin/bash

# Documentation generation script
# Generates DocC documentation for the SkyColor package

set -e

echo "📚 Generating SkyColor documentation..."

# Check if we have docc installed
if ! command -v docc &> /dev/null; then
    echo "⚠️  DocC not found. Installing via Xcode command line tools..."
    xcode-select --install || echo "Command line tools might already be installed"
fi

# Create documentation
echo "🔨 Building documentation..."
swift package generate-documentation \
    --target SkyColor \
    --disable-indexing \
    --transform-for-static-hosting \
    --hosting-base-path SkyColor \
    --output-path ./docs

echo "✅ Documentation generated in ./docs/"
echo "🌐 You can serve it locally with: python3 -m http.server 8000 --directory docs"
echo "📖 Then visit: http://localhost:8000"
