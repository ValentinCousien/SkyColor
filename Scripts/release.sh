#!/bin/bash

# Release script for SkyColor
# Usage: ./Scripts/release.sh [version]
# Example: ./Scripts/release.sh 1.0.1

set -e

if [ $# -eq 0 ]; then
    echo "Error: Version number required"
    echo "Usage: $0 [version]"
    echo "Example: $0 1.0.1"
    exit 1
fi

VERSION=$1

# Validate version format (semantic versioning)
if [[ ! $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Version must be in semantic versioning format (e.g., 1.0.1)"
    exit 1
fi

echo "🚀 Preparing release $VERSION..."

# Check if we're on main branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "⚠️  Warning: You're not on the main branch (currently on: $CURRENT_BRANCH)"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 1
    fi
fi

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo "❌ Error: There are uncommitted changes. Please commit or stash them first."
    git status --porcelain
    exit 1
fi

echo "🔨 Building package..."
swift build -c release

# Update CHANGELOG.md
echo "📝 Please update CHANGELOG.md with the new version $VERSION"
echo "Press any key to continue after updating CHANGELOG.md..."
read -n 1 -s

# Commit version bump
git add CHANGELOG.md
git commit -m "Bump version to $VERSION"

# Create and push tag
echo "🏷️  Creating tag v$VERSION..."
git tag "v$VERSION"

echo "📤 Pushing to remote..."
git push origin main
git push origin "v$VERSION"

echo "✅ Release $VERSION completed successfully!"
echo ""
echo "Next steps:"
echo "1. Go to GitHub and create a release from tag v$VERSION"
echo "2. Copy the changelog entry for the release notes"
echo "3. Publish the release"
