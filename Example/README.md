# SkyColor Example

This directory contains example usage of the SkyColor package.

## Quick Start

To run the examples:

1. Open `Package.swift` in Xcode
2. Navigate to `Sources/SkyColor/Previews/`
3. Open any preview file and use Xcode's preview functionality
4. Or run the demo view to interact with the time slider

## Available Examples

### Basic Integration
- Simple background gradient
- Adaptive text color usage
- Time of day descriptions

### Advanced Usage
- Weather app style interface
- Meditation app style interface
- Custom location examples
- Demo mode for testing different times

### Integration Patterns

All examples follow the same basic pattern:

```swift
import SwiftUI
import SkyColor

struct MyView: View {
    let gradient = SkyColorGradient()
    
    var body: some View {
        ZStack {
            gradient  // Background
            
            MyContent()
                .foregroundColor(gradient.adaptiveTextColor)
        }
    }
}
```

## Testing Different Scenarios

Use the demo mode to test your interface at different times:

```swift
// Test sunrise
SkyColorGradient(demoTime: Calendar.current.date(
    bySettingHour: 6, minute: 30, second: 0, of: Date()
) ?? Date())

// Test sunset
SkyColorGradient(demoTime: Calendar.current.date(
    bySettingHour: 19, minute: 30, second: 0, of: Date()
) ?? Date())
```

## Best Practices

1. **Use adaptive text color**: Always use `gradient.adaptiveTextColor` for optimal readability
2. **Handle optional sunrise/sunset**: These might be nil in extreme latitudes
3. **Consider performance**: Create gradient instances sparingly for better performance
4. **Test different times**: Use demo mode to ensure your UI works at all times of day
