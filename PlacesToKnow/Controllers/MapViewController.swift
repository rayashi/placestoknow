

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var sbSearch: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var viDetails: UIView!
    
    var places: [Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sbSearch.isHidden = true
        viDetails.isHidden = true
        
        for place in places {
            addToMap(place)
        }
        showPlaces()
    }
    
    func showPlaces() {
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    func addToMap(_ place: Place) {
        let annotation = MKPointAnnotation()
        annotation.title = place.name
        annotation.coordinate = place.coordite
        mapView.addAnnotation(annotation)
    }
    
    @IBAction func showRotes(_ sender: UIButton) {
        
    }
 
    @IBAction func showSearchBar(_ sender: UIBarButtonItem) {
        
    }
    
}
