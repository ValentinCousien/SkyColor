import CoreLocation
import Foundation

// Class to calculate sunrise/sunset times
// Based on astronomical calculation algorithm
class Solar {
    private let date: Date
    private let coordinate: CLLocationCoordinate2D

    init?(coordinate: CLLocationCoordinate2D, date: Date) {
        self.coordinate = coordinate
        self.date = date
    }

    // Calculate sunrise
    var sunrise: Date? {
        return calculateSunTime(isRising: true)
    }

    // Calculate sunset
    var sunset: Date? {
        return calculateSunTime(isRising: false)
    }

    private func calculateSunTime(isRising: Bool) -> Date? {
        // Get date components
        let calendar = Calendar.current
        guard let day = calendar.ordinality(of: .day, in: .year, for: date),
              let timeZone = TimeZone.current.secondsFromGMT() as? Double else {
            return nil
        }

        // Angle for sunrise (90°50') or sunset (89°10') including atmospheric refraction
        let angle: Double = isRising ? -0.833 : -0.833

        // Convert longitude to hours
        let longitude = coordinate.longitude
        let timeZoneHours = timeZone / 3600.0

        // Calculate equation of time and solar declination
        let n1 = floor(275 * Double(calendar.component(.month, from: date)) / 9)
        let n2 = floor((Double(calendar.component(.month, from: date)) + 9) / 12)
        let n3 = (1 + floor((Double(calendar.component(.year, from: date)) - 4 * floor(Double(calendar.component(.year, from: date)) / 4) + 2) / 3))
        //let n = n1 - (n2 * n3) + Double(calendar.component(.day, from: date)) - 30

        // Mean longitude of the sun
        let meanLongitude = (4.8771 + 0.0172 * (Double(day) - 80))

        // Calculate right ascension and declination
        let rightAscension = 0.91764 * tan(meanLongitude)
        let declination = asin(0.39782 * sin(meanLongitude))

        // Calculate sunrise/sunset time
        let cosHourAngle = (sin(angle.degreesToRadians) - sin(coordinate.latitude.degreesToRadians) * sin(declination)) / (cos(coordinate.latitude.degreesToRadians) * cos(declination))

        // Check if the sun rises/sets that day
        guard cosHourAngle <= 1.0 && cosHourAngle >= -1.0 else {
            return nil
        }

        // Calculate hour angle
        let hourAngle = isRising ? acos(cosHourAngle) : (2.0 * .pi) - acos(cosHourAngle)

        // Calculate local mean time of sunrise/sunset
        let localMeanTime = (hourAngle.radiansToDegrees / 15.0) + rightAscension - (0.06571 * Double(day) - 6.622) - longitude / 15.0

        // Adjust for time zone and create date
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        let hours = Int(localMeanTime + timeZoneHours)
        let minutes = Int((localMeanTime + timeZoneHours - Double(hours)) * 60)
        components.hour = hours % 24
        components.minute = minutes
        components.second = 0

        return calendar.date(from: components)
    }
}
