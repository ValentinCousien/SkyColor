import SwiftUI
import CoreLocation

// Class to manage location
@available(iOS 15.0, *)
class LocationDelegate: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var location: CLLocation?
    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        self.locationManager.requestWhenInUseAuthorization()
    }

    func requestLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        } else {
            // Provide default position if location services are disabled
            self.location = CLLocation(latitude: 48.8566, longitude: 2.3522) // Paris
        }
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.location = location
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
        // Provide default position in case of error
        self.location = CLLocation(latitude: 48.8566, longitude: 2.3522) // Paris
    }
}
