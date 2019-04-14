

import UIKit
import MapKit
import CoreLocation

enum FindPlaceMessageType {
    case confiemation(String)
    case error(String)
}

class FinderViewController: UIViewController {

    @IBOutlet weak var tfSearchTerm: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var aiLoading: UIActivityIndicatorView!
    @IBOutlet weak var vLoading: UIView!
    
    var locationManager = CLLocationManager()
    
    var place: Place!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressOnMap(_:)))
        gesture.minimumPressDuration = 2.0
        mapView.addGestureRecognizer(gesture)
    }
    
    @objc func onLongPressOnMap(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        load(show: true)
        let viewLocation = gesture.location(in: mapView)
        let coordinate = mapView.convert(viewLocation, toCoordinateFrom: mapView)
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            self.placemarskHandler(placemarks, error)
        }
    }
    
    @IBAction func findPlace(_ sender: Any) {
        tfSearchTerm.resignFirstResponder()
        let term = tfSearchTerm.text!
        load(show: true)
        CLGeocoder().geocodeAddressString(term) { (placemarks, error) in
            self.placemarskHandler(placemarks, error)
        }
    }
    
    @IBAction func onMyLocationPress(_ sender: UIButton) {
        
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .restricted ||
                CLLocationManager.authorizationStatus() == .denied ||
                CLLocationManager.authorizationStatus() == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        } else {
            showMessage(using: .error("Ligue o GPS por favor"))
        }
    }
    
    
    @objc func placemarskHandler(_ placemarks: [CLPlacemark]?, _ error: Error?) -> Void {
        self.load(show: false)
        if error != nil {
            self.showMessage(using: .error("Erro ao encontrar local"))
        } else if !self.savePlace(with: placemarks?.first) {
            self.showMessage(using: .error("Erro ao encontrar local"))
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

extension FinderViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        let region = MKCoordinateRegion(center: locations[0].coordinate, latitudinalMeters: 3000, longitudinalMeters: 3000)
        self.mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.showMessage(using: .error("Incapaz de encrontar a localização"))
    }
}
