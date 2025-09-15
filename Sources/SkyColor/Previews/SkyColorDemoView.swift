import SwiftUI
import CoreLocation

// MARK: - Internal Demo View with Interactive Controls (Debug Only)
#if DEBUG
@available(iOS 15.0, *)
struct SkyColorDemoView: View {
    @State private var currentTime = Date()
    @State private var demoMode = false
    @State private var demoHour: Double = 12
    @State private var skyGradient = SkyColorGradient()
    
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    // Current time components for demo mode initialization
    private var hour: Int {
        Calendar.current.component(.hour, from: currentTime)
    }

    private var minute: Int {
        Calendar.current.component(.minute, from: currentTime)
    }

    // Create demo time from slider value
    private var demoTime: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: currentTime)
        components.hour = Int(demoHour)
        components.minute = Int((demoHour.truncatingRemainder(dividingBy: 1)) * 60)
        components.second = 0
        return calendar.date(from: components) ?? currentTime
    }

    // Format current time
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        if demoMode {
            return formatter.string(from: demoTime)
        } else {
            return formatter.string(from: currentTime)
        }
    }

    var body: some View {
        ZStack {
            // Use the public SkyColorGradient as background
            if demoMode {
                SkyColorGradient(demoTime: demoTime)
            } else {
                SkyColorGradient()
            }

            VStack {
                if demoMode {
                    Text(String(format: "Demo mode: %.1fh", demoHour))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(getAdaptiveTextColor())
                        .padding()
                        .animation(.easeInOut, value: demoHour)

                    Slider(value: $demoHour, in: 0...24, step: 0.1)
                        .padding(.horizontal, 40)
                        .accentColor(getAdaptiveTextColor().opacity(0.8))
                        .animation(.easeInOut, value: demoHour)

                    Text(getTimeOfDayDescription())
                        .font(.title2)
                        .foregroundColor(getAdaptiveTextColor())

                    if let sunrise = getSunrise(), let sunset = getSunset() {
                        Text("Sunrise: \(formatTime(sunrise)) • Sunset: \(formatTime(sunset))")
                            .font(.subheadline)
                            .foregroundColor(getAdaptiveTextColor())
                            .padding(.bottom)
                    }

                    Button(action: {
                        self.demoMode = false
                        self.currentTime = Date()
                    }) {
                        Text("Return to real time")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                } else {
                    Text(timeString)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(getAdaptiveTextColor())
                        .padding()

                    Text(getTimeOfDayDescription())
                        .font(.title2)
                        .foregroundColor(getAdaptiveTextColor())

                    if let sunrise = getSunrise(), let sunset = getSunset() {
                        Text("Sunrise: \(formatTime(sunrise)) • Sunset: \(formatTime(sunset))")
                            .font(.subheadline)
                            .foregroundColor(getAdaptiveTextColor())
                            .padding(.bottom)
                    }

                    Button(action: {
                        self.demoMode = true
                        self.demoHour = Double(hour) + (Double(minute) / 60.0)
                    }) {
                        Text("Demo mode")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
        }
        .onReceive(timer) { _ in
            if !demoMode {
                self.currentTime = Date()
            }
        }
    }
    
    // Helper methods to access SkyColorGradient functionality
    private func getAdaptiveTextColor() -> Color {
        if demoMode {
            return SkyColorGradient(demoTime: demoTime).adaptiveTextColor
        } else {
            return SkyColorGradient().adaptiveTextColor
        }
    }
    
    private func getTimeOfDayDescription() -> String {
        if demoMode {
            return SkyColorGradient(demoTime: demoTime).timeOfDayDescription
        } else {
            return SkyColorGradient().timeOfDayDescription
        }
    }
    
    private func getSunrise() -> Date? {
        if demoMode {
            return SkyColorGradient(demoTime: demoTime).sunrise
        } else {
            return SkyColorGradient().sunrise
        }
    }
    
    private func getSunset() -> Date? {
        if demoMode {
            return SkyColorGradient(demoTime: demoTime).sunset
        } else {
            return SkyColorGradient().sunset
        }
    }

    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: date)
    }
}

// MARK: - Preview (Private)
@available(iOS 15.0, *)
struct SkyColorDemoView_Previews: PreviewProvider {
    static var previews: some View {
        SkyColorDemoView()
    }
}
#endif

