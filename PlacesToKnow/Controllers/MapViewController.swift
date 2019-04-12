

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var sbSearch: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func showRotes(_ sender: UIButton) {
        
    }
 
    @IBAction func showSearchBar(_ sender: UIBarButtonItem) {
    }
    
}
