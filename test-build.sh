#!/bin/bash

# Test the SkyColor package build
echo "🔨 Testing SkyColor package build..."

cd /Users/vcousien/src/repositories/SkyColor

# Check if Package.swift exists and is valid
if [ ! -f "Package.swift" ]; then
    echo "❌ Package.swift not found"
    exit 1
fi

echo "✅ Package.swift found"

# Try to resolve dependencies
echo "📦 Resolving dependencies..."
swift package resolve

# Try to build
echo "🔨 Building package..."
swift build

echo "✅ Package build test completed!"
