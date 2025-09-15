import SwiftUI
import CoreLocation

#if canImport(UIKit)
import UIKit
typealias PlatformColor = UIColor
#elseif canImport(AppKit)
import AppKit
typealias PlatformColor = NSColor
#endif

/// A public SwiftUI view that provides a dynamic sky color gradient background
/// that changes throughout the day based on astronomical calculations.
@available(iOS 15.0, *)
public struct SkyColorGradient: View {
    @State private var currentTime = Date()
    @State private var sunriseTime: Date?
    @State private var sunsetTime: Date?
    @State private var location: CLLocation?
    @StateObject private var locationDelegate = LocationDelegate()
    
    private let demoTime: Date?
    private let customLocation: CLLocation?
    
    /// Initialize with real-time updates
    public init() {
        self.demoTime = nil
        self.customLocation = nil
    }
    
    /// Initialize with a specific time for demonstration purposes
    public init(demoTime: Date) {
        self.demoTime = demoTime
        self.customLocation = nil
    }
    
    /// Initialize with a custom location and optional demo time
    public init(location: CLLocation, demoTime: Date? = nil) {
        self.customLocation = location
        self.demoTime = demoTime
    }
    
    // Key hours of the day (dawn, sunrise, sunset, dusk)
    private var hourOfSunrise: Double {
        guard let sunrise = sunriseTime else { return 6.0 }
        let hour = Double(Calendar.current.component(.hour, from: sunrise))
        let minute = Double(Calendar.current.component(.minute, from: sunrise))
        return hour + (minute / 60.0)
    }

    private var hourOfSunset: Double {
        guard let sunset = sunsetTime else { return 20.0 }
        let hour = Double(Calendar.current.component(.hour, from: sunset))
        let minute = Double(Calendar.current.component(.minute, from: sunset))
        return hour + (minute / 60.0)
    }

    // Dawn is approximately 30 minutes before sunrise
    private var hourOfDawn: Double {
        return max(0, hourOfSunrise - 0.5)
    }

    // Dusk is approximately 30 minutes after sunset
    private var hourOfDusk: Double {
        return min(24, hourOfSunset + 0.5)
    }

    // Get hour with minutes for smoother transitions
    private var hourWithMinutes: Double {
        let timeToUse = demoTime ?? currentTime
        let hour = Double(Calendar.current.component(.hour, from: timeToUse))
        let minute = Double(Calendar.current.component(.minute, from: timeToUse))
        return hour + (minute / 60.0)
    }

    // Create color gradient with smooth transitions
    private var backgroundGradient: LinearGradient {
        // Key points of the day based on astronomical calculations
        let midnightTime: Double = 0.0         // Midnight
        let deepNightTime: Double = 2.0        // Deep night
        let preDawnTime: Double = hourOfDawn - 1.0  // Before dawn
        let dawnTime: Double = hourOfDawn      // Dawn
        let sunriseTime: Double = hourOfSunrise // Sunrise
        let morningTime: Double = hourOfSunrise + 2.0  // Morning
        let middayTime: Double = 12.0          // Noon
        let afternoonTime: Double = 15.0       // Afternoon
        let preSunsetTime: Double = hourOfSunset - 1.0 // Approaching sunset
        let sunsetTime: Double = hourOfSunset  // Sunset
        let duskTime: Double = hourOfDusk      // Dusk
        let eveningTime: Double = hourOfDusk + 1.0  // Evening
        let nightTime: Double = 22.0           // Night

        // Define colors for each moment
        let midnightColors = [Color.black, Color.indigo.opacity(0.3)]
        let deepNightColors = [Color.black, Color.indigo.opacity(0.2)]
        let preDawnColors = [Color.indigo.opacity(0.5), Color.purple.opacity(0.3)]
        let dawnColors = [Color.purple.opacity(0.6), Color.pink.opacity(0.5), Color.blue.opacity(0.3)]
        let sunriseColors = [Color.orange.opacity(0.7), Color.yellow.opacity(0.5), Color.blue.opacity(0.3)]
        let morningColors = [Color.blue.opacity(0.3), Color.blue.opacity(0.1)]
        let middayColors = [Color.blue.opacity(0.2), Color.cyan.opacity(0.1)]
        let afternoonColors = [Color.blue.opacity(0.3), Color.blue.opacity(0.2)]
        let preSunsetColors = [Color.blue.opacity(0.3), Color.yellow.opacity(0.3)]
        let sunsetColors = [Color.orange.opacity(0.7), Color.pink.opacity(0.5), Color.purple.opacity(0.4)]
        let duskColors = [Color.purple.opacity(0.6), Color.indigo.opacity(0.5), Color.blue.opacity(0.2)]
        let eveningColors = [Color.indigo.opacity(0.6), Color.indigo.opacity(0.4)]
        let nightColors = [Color.indigo.opacity(0.4), Color.black]

        // Calculate transition between two moments of the day
        func interpolateColors(time: Double, startTime: Double, endTime: Double, startColors: [Color], endColors: [Color]) -> [Color] {
            let factor = (time - startTime) / (endTime - startTime)
            return zip(startColors, endColors).map { startColor, endColor in
                interpolateColor(start: startColor, end: endColor, factor: factor)
            }
        }

        // Interpolate between two colors
        func interpolateColor(start: Color, end: Color, factor: Double) -> Color {
            // Convert colors for interpolation
            let factor = min(max(factor, 0.0), 1.0)

            // Create interpolated color using platform-specific color intermediary
            let startPlatformColor = PlatformColor(start)
            let endPlatformColor = PlatformColor(end)

            var red1: CGFloat = 0
            var green1: CGFloat = 0
            var blue1: CGFloat = 0
            var alpha1: CGFloat = 0
            startPlatformColor.getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1)

            var red2: CGFloat = 0
            var green2: CGFloat = 0
            var blue2: CGFloat = 0
            var alpha2: CGFloat = 0
            endPlatformColor.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)

            let r = red1 + CGFloat(factor) * (red2 - red1)
            let g = green1 + CGFloat(factor) * (green2 - green1)
            let b = blue1 + CGFloat(factor) * (blue2 - blue1)
            let a = alpha1 + CGFloat(factor) * (alpha2 - alpha1)

            return Color(red: Double(r), green: Double(g), blue: Double(b), opacity: Double(a))
        }

        // 24-hour cycle - get current colors based on time
        var colors: [Color]
        let time = hourWithMinutes.truncatingRemainder(dividingBy: 24.0)

        switch time {
        case midnightTime..<deepNightTime:  // Midnight to deep night
            colors = interpolateColors(time: time, startTime: midnightTime, endTime: deepNightTime, startColors: midnightColors, endColors: deepNightColors)
        case deepNightTime..<preDawnTime:   // Deep night to pre-dawn
            colors = interpolateColors(time: time, startTime: deepNightTime, endTime: preDawnTime, startColors: deepNightColors, endColors: preDawnColors)
        case preDawnTime..<dawnTime:        // Pre-dawn to dawn
            colors = interpolateColors(time: time, startTime: preDawnTime, endTime: dawnTime, startColors: preDawnColors, endColors: dawnColors)
        case dawnTime..<sunriseTime:        // Dawn to sunrise
            colors = interpolateColors(time: time, startTime: dawnTime, endTime: sunriseTime, startColors: dawnColors, endColors: sunriseColors)
        case sunriseTime..<morningTime:     // Sunrise to morning
            colors = interpolateColors(time: time, startTime: sunriseTime, endTime: morningTime, startColors: sunriseColors, endColors: morningColors)
        case morningTime..<middayTime:      // Morning to noon
            colors = interpolateColors(time: time, startTime: morningTime, endTime: middayTime, startColors: morningColors, endColors: middayColors)
        case middayTime..<afternoonTime:    // Noon to afternoon
            colors = interpolateColors(time: time, startTime: middayTime, endTime: afternoonTime, startColors: middayColors, endColors: afternoonColors)
        case afternoonTime..<preSunsetTime: // Afternoon to pre-sunset
            colors = interpolateColors(time: time, startTime: afternoonTime, endTime: preSunsetTime, startColors: afternoonColors, endColors: preSunsetColors)
        case preSunsetTime..<sunsetTime:    // Pre-sunset to sunset
            colors = interpolateColors(time: time, startTime: preSunsetTime, endTime: sunsetTime, startColors: preSunsetColors, endColors: sunsetColors)
        case sunsetTime..<duskTime:         // Sunset to dusk
            colors = interpolateColors(time: time, startTime: sunsetTime, endTime: duskTime, startColors: sunsetColors, endColors: duskColors)
        case duskTime..<eveningTime:        // Dusk to evening
            colors = interpolateColors(time: time, startTime: duskTime, endTime: eveningTime, startColors: duskColors, endColors: eveningColors)
        case eveningTime..<nightTime:       // Evening to night
            colors = interpolateColors(time: time, startTime: eveningTime, endTime: nightTime, startColors: eveningColors, endColors: nightColors)
        default:                            // Night to midnight
            colors = interpolateColors(time: time, startTime: nightTime, endTime: 24.0, startColors: nightColors, endColors: midnightColors)
        }

        return LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: .bottom,
            endPoint: .top
        )
    }
    
    public var body: some View {
        backgroundGradient
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 1.0), value: hourWithMinutes)
            .onAppear {
                if customLocation == nil {
                    requestLocation()
                } else {
                    location = customLocation
                }
                calculateSunriseSunset()
                
                // Start timer for real-time updates (only if not in demo mode)
                if demoTime == nil {
                    startTimer()
                }
            }
    }
    
    private func startTimer() {
        // Simple timer that updates every minute
        Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { _ in
            DispatchQueue.main.async {
                self.currentTime = Date()
                
                // Recalculate sunrise/sunset at midnight
                let calendar = Calendar.current
                if calendar.component(.hour, from: self.currentTime) == 0 &&
                   calendar.component(.minute, from: self.currentTime) == 0 {
                    self.calculateSunriseSunset()
                }
            }
        }
    }
    
    private func requestLocation() {
        locationDelegate.requestLocation()
    }

    private func calculateSunriseSunset() {
        let locationToUse = customLocation ?? locationDelegate.location
        
        guard let location = locationToUse else {
            // Use default times if no location is available
            let calendar = Calendar.current

            // Default sunrise at 6:00 AM
            self.sunriseTime = calendar.date(bySettingHour: 6, minute: 0, second: 0, of: Date())

            // Default sunset at 8:00 PM
            self.sunsetTime = calendar.date(bySettingHour: 20, minute: 0, second: 0, of: Date())
            return
        }

        // Use astronomical calculations to determine sunrise and sunset times
        let timeToUse = demoTime ?? currentTime
        let solar = Solar(coordinate: location.coordinate, date: timeToUse)
        self.sunriseTime = solar?.sunrise
        self.sunsetTime = solar?.sunset
    }
}

// MARK: - Public Extensions

@available(iOS 15.0, *)
extension SkyColorGradient {
    /// Returns the adaptive text color that works well with the current sky gradient
    public var adaptiveTextColor: Color {
        let time = hourWithMinutes

        // Smooth transition between white and black based on real sunrise/sunset
        if time >= hourOfSunset + 1.0 || time < hourOfDawn {
            // Night - white text
            return .white
        } else if time >= hourOfDawn && time < hourOfSunrise + 1.0 {
            // Progressive transition for sunrise (white to black)
            let totalTransition = hourOfSunrise + 1.0 - hourOfDawn
            let factor = (time - hourOfDawn) / totalTransition
            return interpolateTextColor(factor: factor)
        } else if time >= hourOfSunset - 1.0 && time < hourOfSunset + 1.0 {
            // Progressive transition for sunset (black to white)
            let totalTransition = 2.0
            let factor = (time - (hourOfSunset - 1.0)) / totalTransition
            return interpolateTextColor(factor: 1 - factor)
        } else {
            // Day - black text
            return .black
        }
    }
    
    /// Returns a descriptive string of the current time of day
    public var timeOfDayDescription: String {
        let time = hourWithMinutes

        // Use calculated hours to describe time of day
        if time >= 0 && time < hourOfDawn - 1.0 {
            return "Deep night"
        } else if time >= hourOfDawn - 1.0 && time < hourOfDawn {
            return "Early morning"
        } else if time >= hourOfDawn && time < hourOfSunrise {
            return "Dawn"
        } else if time >= hourOfSunrise && time < hourOfSunrise + 1.0 {
            return "Sunrise"
        } else if time >= hourOfSunrise + 1.0 && time < 10 {
            return "Morning"
        } else if time >= 10 && time < 12 {
            return "Late morning"
        } else if time >= 12 && time < 14 {
            return "Noon"
        } else if time >= 14 && time < hourOfSunset - 2.0 {
            return "Afternoon"
        } else if time >= hourOfSunset - 2.0 && time < hourOfSunset {
            return "Late afternoon"
        } else if time >= hourOfSunset && time < hourOfDusk {
            return "Sunset"
        } else if time >= hourOfDusk && time < hourOfDusk + 1.5 {
            return "Twilight"
        } else if time >= hourOfDusk + 1.5 && time < 22 {
            return "Evening"
        } else {
            return "Night"
        }
    }
    
    /// Returns the current sunrise time if available
    var sunrise: Date? {
        return sunriseTime
    }
    
    /// Returns the current sunset time if available
    var sunset: Date? {
        return sunsetTime
    }
}

// MARK: - Internal Helper Methods

@available(iOS 15.0, *)
extension SkyColorGradient {
    // Function for text color interpolation
    func interpolateTextColor(factor: Double) -> Color {
        let clampedFactor = min(max(factor, 0.0), 1.0)
        return Color(
            red: clampedFactor,
            green: clampedFactor,
            blue: clampedFactor,
            opacity: 1.0
        )
    }
}
