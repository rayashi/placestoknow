

import UIKit
import MapKit

class FinderViewController: UIViewController {

    @IBOutlet weak var tfSearchTerm: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var aiLoading: UIActivityIndicatorView!
    @IBOutlet weak var vLoading: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad() 

    }
    @IBAction func findPlace(_ sender: Any) {
        tfSearchTerm.resignFirstResponder()
        let term = tfSearchTerm.text!
        load(show: true)
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(term) { (placemarkes, error) in
            
        }
        
    }
    
    func load(show: Bool) {
        vLoading.isHidden = !show
        if show {
            aiLoading.startAnimating()
        } else {
            aiLoading.stopAnimating()
        }
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
