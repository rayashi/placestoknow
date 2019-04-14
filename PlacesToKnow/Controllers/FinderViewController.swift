

import UIKit
import MapKit

enum FindPlaceMessageType {
    case confiemation(String)
    case error(String)
}

class FinderViewController: UIViewController {

    @IBOutlet weak var tfSearchTerm: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var aiLoading: UIActivityIndicatorView!
    @IBOutlet weak var vLoading: UIView!
    
    var place: Place!
    
    override func viewDidLoad() {
        super.viewDidLoad() 

    }
    @IBAction func findPlace(_ sender: Any) {
        tfSearchTerm.resignFirstResponder()
        let term = tfSearchTerm.text!
        load(show: true)
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(term) { (placemarkes, error) in
            self.load(show: false)
            if error != nil {
                self.showMessage(using: .error("Erro ao encontrar local"))
            } else if !self.savePlace(with: placemarkes?.first) {
                self.showMessage(using: .error("Erro ao encontrar local"))
            }
        }
    }
    
    func savePlace(with placemark: CLPlacemark?) -> Bool {
        guard let placemark = placemark, let coordinate = placemark.location?.coordinate else { return false }
        place = Place(placemark: placemark)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 3000, longitudinalMeters: 3000)
        mapView.setRegion(region, animated: true)
        self.showMessage(using: .confiemation(place.name))
        return true
    }
    
    func showMessage(using type: FindPlaceMessageType) {
        var title: String, message: String
        var hasConfirmation: Bool = false
        
        switch type {
        case .confiemation(let name):
            title = "Local encontrado"
            message = "Deseja adicionar \(name)"
            hasConfirmation = true
        case .error(let errorMessage):
            title = "erro desconhecido"
            message = errorMessage
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        alert.addAction(cancelAction)
        if hasConfirmation {
            let confirmationAction = UIAlertAction(title: "Confirmar", style: .default, handler: nil)
            alert.addAction(confirmationAction)
        }
        
        present(alert, animated: true, completion: nil)
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
