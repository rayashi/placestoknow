

import UIKit

class PlacesTableViewController: UITableViewController {
    
    var places: [Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadPlaces()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.prepareNoItems()
        self.prepareShowAllBtn()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "segueToFind":
            let finderViewController = segue.destination as! FinderViewController
            finderViewController.delegate = self
        case "segueToMap":
            let mapViewController = segue.destination as! MapViewController
            if let place = sender as! Place? {
                mapViewController.places = [place]
                mapViewController.title = place.name
            } else {
                mapViewController.places = places
                mapViewController.title = "Meus Locais"
            }
        default:
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.places.remove(at: indexPath.row)
            self.savePlaces()
        }
    }
    
    func savePlaces() {
        let json = try? JSONEncoder().encode(self.places)
        UserDefaults.standard.set(json, forKey: "places")
        self.tableView.reloadData()
        self.prepareNoItems()
        self.prepareShowAllBtn()
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
    
    func prepareShowAllBtn() {
        if self.places.count > 0 {
            let btn = UIBarButtonItem(title: "Mostrar todos no mapa", style: .plain, target: self, action: #selector(showAll))
            navigationItem.leftBarButtonItem = btn
        } else {
            navigationItem.leftBarButtonItem = nil
        }
    }
    
    func prepareNoItems() {
        if self.places.count <= 0 {
            let lbNoItems = UILabel()
            lbNoItems.text = "Nenhum local salvo ainda"
            lbNoItems.textAlignment = .center
            tableView.backgroundView = lbNoItems
        } else {
            tableView.backgroundView = nil
        }
    }
    
    @objc func showAll() {
        performSegue(withIdentifier: "segueToMap", sender: nil)
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
        self.savePlaces()
    }
}
