import XCTest
import SwiftUI
import CoreLocation
@testable import SkyColor

final class SkyColorTests: XCTestCase {
    
    func testSkyColorGradientInitialization() throws {
        // Test basic initialization
        let gradient = SkyColorGradient()
        XCTAssertNotNil(gradient, "SkyColorGradient should initialize successfully")
    }
    
    func testSkyColorGradientWithDemoTime() throws {
        // Test initialization with demo time
        let demoTime = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date()) ?? Date()
        let gradient = SkyColorGradient(demoTime: demoTime)
        XCTAssertNotNil(gradient, "SkyColorGradient should initialize with demo time")
    }
    
    func testSkyColorGradientWithLocation() throws {
        // Test initialization with custom location
        let parisLocation = CLLocation(latitude: 48.8566, longitude: 2.3522)
        let gradient = SkyColorGradient(location: parisLocation)
        XCTAssertNotNil(gradient, "SkyColorGradient should initialize with custom location")
    }
    
    func testAdaptiveTextColor() throws {
        // Test adaptive text color property
        let gradient = SkyColorGradient()
        let textColor = gradient.adaptiveTextColor
        XCTAssertNotNil(textColor, "Adaptive text color should be available")
    }
    
    func testTimeOfDayDescription() throws {
        // Test time of day description
        let gradient = SkyColorGradient()
        let description = gradient.timeOfDayDescription
        XCTAssertFalse(description.isEmpty, "Time of day description should not be empty")
    }
    
    func testInternalSolarCalculations() throws {
        // Test internal Solar class calculations
        let parisCoordinate = CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522)
        let solar = Solar(coordinate: parisCoordinate, date: Date())
        
        XCTAssertNotNil(solar, "Solar should initialize with valid coordinates")
        XCTAssertTrue(solar?.sunrise != nil || solar?.sunset != nil, "Solar should provide at least one time calculation")
    }
    
    func testInternalLocationDelegate() throws {
        // Test internal LocationDelegate initialization
        let locationDelegate = LocationDelegate()
        XCTAssertNotNil(locationDelegate, "LocationDelegate should initialize successfully")
    }
    
    func testInternalDoubleExtensions() throws {
        // Test internal degree/radian conversions
        let degrees: Double = 180
        let radians = degrees.degreesToRadians
        let backToDegrees = radians.radiansToDegrees
        
        XCTAssertEqual(radians, Double.pi, accuracy: 0.001, "180 degrees should equal π radians")
        XCTAssertEqual(backToDegrees, 180, accuracy: 0.001, "Conversion should be reversible")
    }
}

