# Contributing to SkyColor

Thank you for your interest in contributing to SkyColor! We welcome contributions from the community.

## Getting Started

1. Fork the repository
2. Clone your fork locally
3. Create a new branch for your feature or bug fix
4. Make your changes
5. Run tests to ensure everything works
6. Submit a pull request

## Development Setup

### Requirements
- Xcode 15.0 or later
- Swift 5.9 or later
- iOS 15.0+ / macOS 12.0+ deployment target

### Building the Package

```bash
# Clone the repository
git clone https://github.com/[YourUsername]/SkyColor.git
cd SkyColor

# Open in Xcode
open Package.swift

# Or build from command line
swift build
```

### Running Tests

```bash
# Run all tests
swift test

# Run tests in Xcode
# Open Package.swift in Xcode and use Cmd+U
```

## Code Style

- Follow Swift's standard naming conventions
- Use meaningful variable and function names
- Add documentation comments for public APIs
- Keep functions focused and concise
- Use SwiftUI best practices for view composition

## Project Structure

```
Sources/SkyColor/
├── SkyColorGradient.swift      ← Public API
├── LocationDelegate.swift      ← Internal location handling
├── Solar.swift                 ← Internal astronomical calculations
├── DoubleExtensions.swift      ← Internal utilities
└── Previews/                   ← Debug-only preview content
    ├── SkyColorDemoView.swift
    ├── SkyColor_Previews.swift
    └── IntegrationExamples.swift
```

## Guidelines

### Public API
- Only `SkyColorGradient` should be public
- All other components should remain internal
- Maintain backward compatibility in public interfaces
- Document all public APIs with clear examples

### Internal Components
- Keep supporting classes internal to the package
- Use descriptive names for internal functions
- Maintain clean separation of concerns

### Testing
- Add tests for new functionality
- Ensure existing tests continue to pass
- Test both happy path and error conditions
- Use meaningful test names that describe the behavior being tested

### Documentation
- Update README.md for new features
- Add code examples for new public APIs
- Update CHANGELOG.md following semantic versioning
- Include docstrings for complex algorithms

## Submitting Changes

1. **Create an Issue**: For significant changes, please create an issue first to discuss your proposed changes
2. **Create a Branch**: Use a descriptive branch name (e.g., `feature/add-custom-colors` or `fix/timezone-bug`)
3. **Make Changes**: Implement your feature or fix
4. **Write Tests**: Add or update tests as needed
5. **Update Documentation**: Update README, docstrings, or other documentation
6. **Run Tests**: Ensure all tests pass
7. **Submit PR**: Create a pull request with a clear description of your changes

### Pull Request Guidelines

- Use a clear, descriptive title
- Explain what the PR does and why
- Reference any related issues
- Include screenshots for UI changes
- Ensure all tests pass
- Keep PRs focused and atomic

## Questions?

If you have questions about contributing, please:
- Check existing issues and discussions
- Create a new issue for bugs or feature requests
- Start a discussion for questions about architecture or design

Thank you for contributing to SkyColor! 🌅
