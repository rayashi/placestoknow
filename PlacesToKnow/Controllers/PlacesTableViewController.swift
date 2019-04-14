

import UIKit

class PlacesTableViewController: UITableViewController {
    
    var places: [Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadPlaces()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "segueToFind":
            let finderViewController = segue.destination as! FinderViewController
            finderViewController.delegate = self
        case "segueToMap":
            if let place = sender as! Place? {
                let mapViewController = segue.destination as! MapViewController
                mapViewController.places = [place]
            }
        default:
            return
        }

    }
    
    func loadPlaces() {
        guard let placesData = UserDefaults.standard.data(forKey: "places") else { return }
        do {
            self.places = try JSONDecoder().decode([Place].self, from: placesData)
            self.tableView.reloadData()
        } catch {
            print("Erro ao carregar locais")
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let place = self.places[indexPath.row]
        cell.textLabel?.text = place.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = places[indexPath.row]
        performSegue(withIdentifier: "segueToMap", sender: place)
    }

}

extension PlacesTableViewController: FindPlaceDelegate {
    func savePlace(_ place: Place) {
        guard !self.places.contains(place) else {return}
        self.places.append(place)
        self.tableView.reloadData()
        let json = try? JSONEncoder().encode(self.places)
        UserDefaults.standard.set(json, forKey: "places")
    }
}
