# SkyColor

A SwiftUI library that provides dynamic, time-based sky color gradients that change throughout the day based on astronomical calculations.

## Features

- **Realistic Sky Simulation**: Colors change throughout the day based on your location's sunrise and sunset times
- **Location-Aware**: Uses GPS to calculate accurate astronomical times for your location
- **Smooth Transitions**: Gradual color transitions between different times of day
- **Easy Integration**: Simple SwiftUI view that can be used as a background
- **Flexible API**: Support for custom times and locations

## Installation

### Swift Package Manager

Add SkyColor to your project using Swift Package Manager. In Xcode:

1. Go to **File → Add Package Dependencies...**
2. Enter the repository URL: `https://github.com/[YourUsername]/SkyColor.git`
3. Select the version you want to use
4. Add the package to your target

Or add it to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/[YourUsername]/SkyColor.git", from: "1.0.0")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["SkyColor"]
    )
]
```

## Usage

### Basic Usage

Use `SkyColorGradient` as a background in your SwiftUI views:

```swift
import SwiftUI
import SkyColor

struct ContentView: View {
    var body: some View {
        ZStack {
            // Sky color gradient background
            SkyColorGradient()
            
            // Your app content
            VStack {
                Text("Hello, World!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("The background adapts to time of day")
                    .font(.subheadline)
            }
            .foregroundColor(.white) // or use gradient.adaptiveTextColor for automatic adaptation
        }
    }
}
```

### Using Adaptive Text Color

The gradient provides an adaptive text color that automatically adjusts for readability:

```swift
struct ContentView: View {
    let gradient = SkyColorGradient()
    
    var body: some View {
        ZStack {
            gradient
            
            VStack {
                Text("Dynamic Content")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(gradient.adaptiveTextColor)
                
                Text(gradient.timeOfDayDescription)
                    .font(.subheadline)
                    .foregroundColor(gradient.adaptiveTextColor)
            }
        }
    }
}
```

### Demo Mode

For testing or demonstrations, you can specify a custom time:

```swift
struct DemoView: View {
    var body: some View {
        ZStack {
            // Show sunrise colors
            SkyColorGradient(demoTime: Calendar.current.date(
                bySettingHour: 6, 
                minute: 30, 
                second: 0, 
                of: Date()
            ) ?? Date())
            
            Text("Sunrise Demo")
                .font(.largeTitle)
                .foregroundColor(.white)
        }
    }
}
```

### Custom Location

You can specify a custom location for sunrise/sunset calculations:

```swift
import CoreLocation

struct CustomLocationView: View {
    let parisLocation = CLLocation(latitude: 48.8566, longitude: 2.3522)
    
    var body: some View {
        ZStack {
            SkyColorGradient(location: parisLocation)
            
            Text("Paris Sky")
                .font(.largeTitle)
                .foregroundColor(.white)
        }
    }
}
```

## API Reference

### SkyColorGradient

The **only public** SwiftUI view that provides the dynamic sky gradient. All supporting classes and helper methods are internal to the package.

#### Initializers

```swift
// Real-time gradient based on current time and location
public init()

// Demo mode with specific time
public init(demoTime: Date)

// Custom location with optional demo time
public init(location: CLLocation, demoTime: Date? = nil)
```

#### Public Properties

```swift
// Returns adaptive text color for current sky conditions
public var adaptiveTextColor: Color { get }

// Returns description of current time of day
public var timeOfDayDescription: String { get }

// Current sunrise time (if available)
public var sunrise: Date? { get }

// Current sunset time (if available)
public var sunset: Date? { get }
```

## Color Phases

The gradient smoothly transitions through these phases throughout the day:

- **Deep Night** (00:00-02:00): Black to dark indigo
- **Pre-Dawn** (varies): Indigo to purple
- **Dawn** (varies): Purple, pink, and blue tones
- **Sunrise** (varies): Orange, yellow, and blue
- **Morning** (sunrise+2h): Light blue tones
- **Noon** (12:00): Bright blue and cyan
- **Afternoon** (15:00): Blue tones
- **Pre-Sunset** (sunset-1h): Blue to yellow transition
- **Sunset** (varies): Orange, pink, and purple
- **Dusk** (sunset+0.5h): Purple and indigo
- **Evening** (dusk+1h): Deep indigo
- **Night** (22:00+): Indigo to black

## Requirements

- iOS 15.0+ / macOS 12.0+ / watchOS 8.0+ / tvOS 15.0+
- Swift 5.9+
- Xcode 15.0+

**Cross-Platform Support**: SkyColor works seamlessly across all Apple platforms using platform-specific color APIs (UIKit on iOS/tvOS/watchOS, AppKit on macOS).

## Permissions

For the most accurate experience, add location usage description to your `Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app uses your location to calculate accurate sunrise and sunset times for the sky gradient.</string>
```

If location permission is denied, the library falls back to default Paris coordinates.

## License

SkyColor is released under the MIT License. See [LICENSE](LICENSE) for details.

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to contribute to this project.

### Development

The package includes an internal demo view (`SkyColorDemoView`) with interactive controls for testing different times of day. This view is only available in **DEBUG builds** and includes:

- Real-time sky gradient
- Interactive time slider for testing
- Display of sunrise/sunset times
- Time of day descriptions

**Note**: All supporting classes (`LocationDelegate`, `Solar`) and extensions are internal to the package. Only `SkyColorGradient` is exposed as public API.