import Foundation
import XCTest
import AddressBook
import MapKit

class CurrentAddressTestHelpers: XCTestCase {

    static var location: CLLocation {
        let location = CLLocation(latitude: 37.92, longitude: -78.02)
        return location
    }

    static var placemark: MKPlacemark {

        let addressDictionary: [String: Any] = [

            kABPersonAddressStreetKey as String: "Infinite Loop",
            "SubThoroughfare": "1",
            kABPersonAddressCityKey as String: "Cupertino",
            "SubLocality": "San Francisco",
            kABPersonAddressStateKey as String: "CA",
            "SubAdministrativeArea": "Santa Clara",
            kABPersonAddressZIPKey as String: "95014",
            kABPersonAddressCountryKey as String: "United Stated",
            kABPersonAddressCountryCodeKey as String: "US"
        ]

        let placemark = MKPlacemark(coordinate: location.coordinate, addressDictionary: addressDictionary)
        return placemark
    }

}
