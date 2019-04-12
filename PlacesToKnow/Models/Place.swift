

import Foundation
import MapKit

class Place {
    
    var name: String
    var latitude: CLLocationDegrees
    var logitude: CLLocationDegrees
    var address: String
    
    var coordite: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: logitude)
    }
    
    init(placemark: CLPlacemark) {
        <#statements#>
    }
    
    func getAddress(from placemark: CLPlacemark) -> String {
        var address = ""
        
        return address
    }
}
