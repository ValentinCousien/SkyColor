// MARK: - Public Package Previews (Debug Only)

#if DEBUG
import SwiftUI

@available(iOS 15.0, *)
struct SkyColor_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Demo view with interactive controls (internal view for package demonstration)
            SkyColorDemoView()
                .previewDisplayName("Interactive Demo")
            
            // Public gradient examples for integration reference
            ZStack {
                SkyColorGradient()
                
                VStack {
                    Text("Your App Content")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Gradient adapts throughout the day")
                        .font(.subheadline)
                }
                .foregroundColor(.white)
            }
            .previewDisplayName("Public SkyColorGradient")
            
            // Example with custom time
            ZStack {
                SkyColorGradient(demoTime: Calendar.current.date(bySettingHour: 6, minute: 30, second: 0, of: Date()) ?? Date())
                
                Text("Sunrise Demo")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .previewDisplayName("Sunrise Demo")
            
            // Example with sunset
            ZStack {
                SkyColorGradient(demoTime: Calendar.current.date(bySettingHour: 19, minute: 30, second: 0, of: Date()) ?? Date())
                
                Text("Sunset Demo")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .previewDisplayName("Sunset Demo")
        }
    }
}
#endif
