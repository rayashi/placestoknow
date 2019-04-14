

import Foundation
import MapKit

class Place: Codable {
    
    var name: String
    var latitude: CLLocationDegrees
    var logitude: CLLocationDegrees
    var address: String
    
    var coordite: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: logitude)
    }
    
    init(placemark: CLPlacemark) {
        latitude = (placemark.location?.coordinate.latitude)!
        logitude = (placemark.location?.coordinate.longitude)!
        name = placemark.name ?? placemark.country ?? "Desconhecido"
        address = Place.getAddress(from: placemark)
    }
    
    static func getAddress(from placemark: CLPlacemark) -> String {
        var address = ""
        if let street = placemark.thoroughfare {
            address += street
        }
        if let number = placemark.subThoroughfare {
            address += " \(number)"
        }
        if let neighborhood = placemark.subLocality {
            address += ", \(neighborhood)"
        }
        if let city = placemark.locality {
            address += "\n \(city)"
        }
        if let state = placemark.administrativeArea {
            address += " - \(state)"
        }
        
        return address
    }
}

extension Place: Equatable {
    static func == (lhs: Place, rhs: Place) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.logitude == rhs.logitude
    }
}
