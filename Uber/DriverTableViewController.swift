//
//  DriverTableViewController.swift
//  
//
//  Created by partha on 6/1/20.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import MapKit

class DriverTableViewController: UITableViewController,CLLocationManagerDelegate {
    
    var ref:DatabaseReference!
    var rideRequests: [DataSnapshot] = []
    var locationManager = CLLocationManager()
    var driverLocation = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        ref = Database.database().reference().child("RideRequests")
        ref.observe(.childAdded) { (snapshot) in
            self.rideRequests.append(snapshot)
            self.tableView.reloadData()
        }
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (timer) in
            self.tableView.reloadData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = manager.location?.coordinate {
            driverLocation = coord
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rideRequests.count
    }

    @IBAction func logoutTapped(_ sender: Any) {
        try? Auth.auth().signOut()
        navigationController?.dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rideRequestCell", for: indexPath)
        
        let snapshot = rideRequests[indexPath.row]
        if let rideReuqestDictionary = snapshot.value as? [String: Any] {
            if let email = rideReuqestDictionary["email"] as? String {
                if let lat = rideReuqestDictionary["lat"] as? Double {
                    if let lon = rideReuqestDictionary["lon"] as? Double {
                        let driverCLLocation = CLLocation(latitude: driverLocation.latitude, longitude: driverLocation.longitude)
                        let riderCLLocation = CLLocation(latitude: lat, longitude: lon)
                        
                        let distance = driverCLLocation.distance(from: riderCLLocation) / 1000
                        let roundedDistance = round(distance * 100) / 100
                        
                            cell.textLabel?.text = "\(email) - \(roundedDistance)Km away"
                    }
                }
                    
            }
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snapshot = rideRequests[indexPath.row]
        self.performSegue(withIdentifier: "acceptSegue", sender: snapshot)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let acceptVC = segue.destination as? AcceptRequestViewController {
            if let snapshot = sender as? DataSnapshot {
                if let rideReuqestDictionary = snapshot.value as? [String: Any] {
                       if let email = rideReuqestDictionary["email"] as? String {
                           if let lat = rideReuqestDictionary["lat"] as? Double {
                               if let lon = rideReuqestDictionary["lon"] as? Double {
                                acceptVC.requestEmail = email
                                
                                let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                                acceptVC.requestLocation = location
                                
                               }
                           }
                               
                       }
                   }
            }
           
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
