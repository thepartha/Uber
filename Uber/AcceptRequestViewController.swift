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
    
    @IBAction func acceptTapped(_ sender: Any) {
        //Update the rider request
        ref.queryOrdered(byChild: "email").queryEqual(toValue: requestEmail).observe(.childAdded) { (snapshot) in
            
        }
        //Give directions
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
