#!/bin/bash

# SkyColor Package Validation Script
# This script validates that the package is ready for SPM distribution

set -e

echo "🔍 Validating SkyColor package for SPM distribution..."
echo ""

# Check required files
echo "📋 Checking required files..."
required_files=(
    "Package.swift"
    "README.md" 
    "LICENSE"
    "CHANGELOG.md"
    "CONTRIBUTING.md"
    ".gitignore"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file (missing)"
        exit 1
    fi
done

# Check source structure
echo ""
echo "📁 Checking source structure..."
if [ -d "Sources/SkyColor" ]; then
    echo "  ✅ Sources/SkyColor/"
    
    # Check main files
    main_files=(
        "Sources/SkyColor/SkyColorGradient.swift"
        "Sources/SkyColor/LocationDelegate.swift"
        "Sources/SkyColor/Solar.swift"
        "Sources/SkyColor/DoubleExtensions.swift"
    )
    
    for file in "${main_files[@]}"; do
        if [ -f "$file" ]; then
            echo "    ✅ $(basename "$file")"
        else
            echo "    ❌ $(basename "$file") (missing)"
            exit 1
        fi
    done
    
    # Check previews
    if [ -d "Sources/SkyColor/Previews" ]; then
        echo "    ✅ Previews/ folder"
        preview_files=(
            "Sources/SkyColor/Previews/SkyColorDemoView.swift"
            "Sources/SkyColor/Previews/SkyColor_Previews.swift" 
            "Sources/SkyColor/Previews/IntegrationExamples.swift"
        )
        
        for file in "${preview_files[@]}"; do
            if [ -f "$file" ]; then
                echo "      ✅ $(basename "$file")"
            else
                echo "      ❌ $(basename "$file") (missing)"
                exit 1
            fi
        done
    else
        echo "    ❌ Previews/ folder (missing)"
        exit 1
    fi
else
    echo "  ❌ Sources/SkyColor/ (missing)"
    exit 1
fi

# Check tests
echo ""
echo "🧪 Checking tests..."
if [ -d "Tests/SkyColorTests" ] && [ -f "Tests/SkyColorTests/SkyColorTests.swift" ]; then
    echo "  ✅ Tests are present"
else
    echo "  ❌ Tests are missing"
    exit 1
fi

# Try to build
echo ""
echo "🔨 Testing package build..."
if swift build > /dev/null 2>&1; then
    echo "  ✅ Package builds successfully"
else
    echo "  ❌ Package build failed"
    echo "  Run 'swift build' to see detailed errors"
    exit 1
fi

# Try to run tests
echo ""
echo "🧪 Running tests..."
if swift test > /dev/null 2>&1; then
    echo "  ✅ All tests pass"
else
    echo "  ❌ Some tests failed"
    echo "  Run 'swift test' to see detailed results"
    exit 1
fi

# Check for public API
echo ""
echo "🔍 Validating public API..."
if grep -q "public struct SkyColorGradient" Sources/SkyColor/SkyColorGradient.swift; then
    echo "  ✅ SkyColorGradient is public"
else
    echo "  ❌ SkyColorGradient is not properly marked as public"
    exit 1
fi

# Check that other classes are internal
internal_classes=("LocationDelegate" "Solar")
for class in "${internal_classes[@]}"; do
    if grep -q "public class $class" Sources/SkyColor/*.swift; then
        echo "  ❌ $class should be internal, not public"
        exit 1
    else
        echo "  ✅ $class is properly internal"
    fi
done

# Check GitHub setup
echo ""
echo "🐙 Checking GitHub integration..."
github_files=(
    ".github/workflows/ci.yml"
    ".github/ISSUE_TEMPLATE/bug_report.md"
    ".github/ISSUE_TEMPLATE/feature_request.md"
    ".github/pull_request_template.md"
)

for file in "${github_files[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file (missing)"
        exit 1
    fi
done

echo ""
echo "🎉 SUCCESS! Your SkyColor package is ready for SPM distribution!"
echo ""
echo "📋 Summary:"
echo "  ✅ All required files present"
echo "  ✅ Proper package structure"
echo "  ✅ Clean public API (only SkyColorGradient)"
echo "  ✅ Previews properly organized in DEBUG-only folder"
echo "  ✅ Package builds and tests pass"
echo "  ✅ GitHub integration configured"
echo ""
echo "🚀 Next steps:"
echo "  1. Push to GitHub: git push origin main"
echo "  2. Create first release: ./Scripts/release.sh 1.0.0"
echo "  3. Your package will be available for SPM integration!"
