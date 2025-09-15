import Foundation

// MARK: - Internal Supporting Extensions

// Extension to convert between degrees and radians
extension Double {
    var degreesToRadians: Double {
        return self * .pi / 180
    }

    var radiansToDegrees: Double {
        return self * 180 / .pi
    }
}
