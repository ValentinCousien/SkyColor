// MARK: - Integration Examples (Debug Only)

#if DEBUG
import SwiftUI
import CoreLocation

/// Example 1: Basic Usage - Simple background
@available(iOS 15.0, *)
struct BasicExampleView: View {
    var body: some View {
        ZStack {
            SkyColorGradient()
            
            Text("Hello, World!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
}

/// Example 2: Adaptive Text - Text that adapts to sky color
@available(iOS 15.0, *)
struct AdaptiveTextExampleView: View {
    let gradient = SkyColorGradient()
    
    var body: some View {
        ZStack {
            gradient
            
            VStack(spacing: 20) {
                Text("Sky-Adaptive Interface")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(gradient.adaptiveTextColor)
                
                Text(gradient.timeOfDayDescription)
                    .font(.title2)
                    .foregroundColor(gradient.adaptiveTextColor)
                
                if let sunrise = gradient.sunrise, let sunset = gradient.sunset {
                    VStack {
                        Text("Today's Solar Times")
                            .font(.headline)
                            .foregroundColor(gradient.adaptiveTextColor)
                        
                        HStack {
                            Label {
                                Text(sunrise, style: .time)
                            } icon: {
                                Image(systemName: "sunrise")
                            }
                            
                            Spacer()
                            
                            Label {
                                Text(sunset, style: .time)
                            } icon: {
                                Image(systemName: "sunset")
                            }
                        }
                        .foregroundColor(gradient.adaptiveTextColor)
                    }
                    .padding()
                    .background(Color.black.opacity(0.2))
                    .cornerRadius(12)
                }
            }
            .padding()
        }
    }
}

/// Example 3: Demo Mode - Testing different times
@available(iOS 15.0, *)
struct DemoModeExampleView: View {
    var body: some View {
        TabView {
            ZStack {
                SkyColorGradient(demoTime: Calendar.current.date(bySettingHour: 6, minute: 30, second: 0, of: Date()) ?? Date())
                Text("Sunrise")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .tabItem {
                Image(systemName: "sunrise")
                Text("Sunrise")
            }
            
            ZStack {
                SkyColorGradient(demoTime: Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date()) ?? Date())
                Text("Noon")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            .tabItem {
                Image(systemName: "sun.max")
                Text("Noon")
            }
            
            ZStack {
                SkyColorGradient(demoTime: Calendar.current.date(bySettingHour: 19, minute: 30, second: 0, of: Date()) ?? Date())
                Text("Sunset")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .tabItem {
                Image(systemName: "sunset")
                Text("Sunset")
            }
            
            ZStack {
                SkyColorGradient(demoTime: Calendar.current.date(bySettingHour: 23, minute: 0, second: 0, of: Date()) ?? Date())
                Text("Night")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .tabItem {
                Image(systemName: "moon")
                Text("Night")
            }
        }
    }
}

/// Example 4: Weather App Style
@available(iOS 15.0, *)
struct WeatherAppExampleView: View {
    let gradient = SkyColorGradient()
    
    var body: some View {
        ZStack {
            gradient
            
            VStack {
                HStack {
                    Text("Paris")
                        .font(.largeTitle)
                        .fontWeight(.light)
                    
                    Spacer()
                    
                    Text("22°C")
                        .font(.largeTitle)
                        .fontWeight(.thin)
                }
                
                Spacer()
                
                Text("Partly Cloudy")
                    .font(.title2)
                    .fontWeight(.medium)
                
                Text(gradient.timeOfDayDescription)
                    .font(.subheadline)
                    .opacity(0.8)
                
                Spacer()
                
                // Weather details card
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Feels like")
                                .font(.caption)
                                .opacity(0.7)
                            Text("25°C")
                                .font(.title3)
                                .fontWeight(.medium)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Humidity")
                                .font(.caption)
                                .opacity(0.7)
                            Text("68%")
                                .font(.title3)
                                .fontWeight(.medium)
                        }
                    }
                    
                    Divider()
                        .background(gradient.adaptiveTextColor.opacity(0.3))
                    
                    if let sunrise = gradient.sunrise, let sunset = gradient.sunset {
                        HStack {
                            HStack {
                                Image(systemName: "sunrise")
                                    .font(.caption)
                                VStack(alignment: .leading) {
                                    Text("Sunrise")
                                        .font(.caption)
                                        .opacity(0.7)
                                    Text(sunrise, style: .time)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                }
                            }
                            
                            Spacer()
                            
                            HStack {
                                Image(systemName: "sunset")
                                    .font(.caption)
                                VStack(alignment: .trailing) {
                                    Text("Sunset")
                                        .font(.caption)
                                        .opacity(0.7)
                                    Text(sunset, style: .time)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(gradient.adaptiveTextColor.opacity(0.1))
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(gradient.adaptiveTextColor.opacity(0.2), lineWidth: 1)
                        )
                )
            }
            .foregroundColor(gradient.adaptiveTextColor)
            .padding()
        }
    }
}

// MARK: - Integration Examples Preview

@available(iOS 15.0, *)
struct IntegrationExamples_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BasicExampleView()
                .previewDisplayName("Basic Usage")
            
            AdaptiveTextExampleView()
                .previewDisplayName("Adaptive Text")
            
            DemoModeExampleView()
                .previewDisplayName("Demo Mode")
            
            WeatherAppExampleView()
                .previewDisplayName("Weather App Style")
        }
    }
}

#endif
