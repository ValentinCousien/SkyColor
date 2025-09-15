#!/bin/bash

# Development setup script for SkyColor
# This script helps set up the development environment

set -e

echo "🛠️  Setting up SkyColor development environment..."

# Check if we're in the right directory
if [ ! -f "Package.swift" ]; then
    echo "❌ Error: Package.swift not found. Make sure you're in the SkyColor root directory."
    exit 1
fi

# Check Swift version
echo "🔍 Checking Swift version..."
swift --version

# Check Xcode version
echo "🔍 Checking Xcode version..."
xcodebuild -version

# Resolve dependencies
echo "📦 Resolving Swift package dependencies..."
swift package resolve

# Build the package
echo "🔨 Building the package..."
swift build

# Run tests
echo "🧪 Running tests..."
swift test

# Generate Xcode project (optional)
read -p "🎯 Generate Xcode project? This will allow you to work with previews and debugging. (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "📱 Generating Xcode project..."
    swift package generate-xcodeproj
    echo "✅ Xcode project generated! Open SkyColor.xcodeproj to start developing."
else
    echo "📝 You can always generate it later with: swift package generate-xcodeproj"
fi

echo ""
echo "✅ Development environment setup complete!"
echo ""
echo "📚 Quick commands:"
echo "  Build:           swift build"
echo "  Test:            swift test"
echo "  Clean:           swift package clean"
echo "  Open in Xcode:   open Package.swift"
echo ""
echo "🎨 The preview files are in Sources/SkyColor/Previews/"
echo "🔧 Happy coding!"
