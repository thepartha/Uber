//
//  RiderViewController.swift
//  Uber
//
//  Created by partha on 5/31/20.
//  Copyright © 2020 partha. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth
class RiderViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var ref:DatabaseReference!
    var userLocation = CLLocationCoordinate2D()
    var uberHasBeenCalled = false
    
    @IBAction func logoutTapped(_ sender: Any) {
        try? Auth.auth().signOut()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var callUberButton: UIButton!
    @IBOutlet var map: MKMapView!
    
    @IBAction func callUberTapped(_ sender: Any) {
        if let email = Auth.auth().currentUser?.email {
            if uberHasBeenCalled {
                uberHasBeenCalled = false
                callUberButton.setTitle("Call an Uber", for: .normal)
                ref.queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded) { (snapshot) in
                    snapshot.ref.removeValue()
                    self.ref.removeAllObservers()
                }
            } else {
                let rideRequestDictionary: [String: Any] = ["email" : email,"lat":userLocation.latitude,"lon": userLocation.longitude]
                ref.childByAutoId().setValue(rideRequestDictionary)
                uberHasBeenCalled = true
                callUberButton.setTitle("Cancel Uber", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        ref = Database.database().reference().child("RideRequests")
        
          if let email = Auth.auth().currentUser?.email {
            ref.queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded) { (snapshot) in
                self.uberHasBeenCalled = true
                self.callUberButton.setTitle("Cancel Uber", for: .normal)
            self.ref.removeAllObservers()
        }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = manager.location?.coordinate {
            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            userLocation = center
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            map.setRegion(region, animated: true)
            map.removeAnnotations(map.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            annotation.title = "Your Location"
            map.addAnnotation(annotation)
        }
    }
    
}
