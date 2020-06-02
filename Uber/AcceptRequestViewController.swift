//
//  AcceptRequestViewController.swift
//  Uber
//
//  Created by partha on 6/1/20.
//  Copyright © 2020 partha. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase

class AcceptRequestViewController: UIViewController {

    @IBOutlet var map: MKMapView!
    var requestLocation = CLLocationCoordinate2D()
    var requestEmail = ""
    var ref: DatabaseReference!
    var driverLocation = CLLocationCoordinate2D()
    
    @IBAction func acceptTapped(_ sender: Any) {
        //Update the rider request
        ref.queryOrdered(byChild: "email").queryEqual(toValue: requestEmail).observe(.childAdded) { (snapshot) in
            snapshot.ref.updateChildValues(["driverLat": self.driverLocation.latitude, "driverLon":self.driverLocation.longitude])
            self.ref.removeAllObservers()
        }
        
        let requestCLLocation = CLLocation(latitude: requestLocation.latitude, longitude: requestLocation.longitude)
        CLGeocoder().reverseGeocodeLocation(requestCLLocation) { (placemarks, error) in
            if let placemarks = placemarks {
                if placemarks.count > 0 {
                    let mkPlacemark = MKPlacemark(placemark: placemarks[0])
                    let mapItem = MKMapItem(placemark: mkPlacemark)
                    
                    mapItem.name = self.requestEmail
                    let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                    mapItem.openInMaps(launchOptions: options)
                    
                }
            }
            
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference().child("RideRequests")
        
        let region = MKCoordinateRegion(center: requestLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        map.setRegion(region, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = requestLocation
        annotation.title = requestEmail
        
        map.addAnnotation(annotation)

    }
}
