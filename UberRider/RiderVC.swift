//
//  RiderVC.swift
//  UberRider
//
//  Created by Lilia Dassine BELAID on 2017-03-11.
//  Copyright © 2017 Lilia Dassine BELAID. All rights reserved.
//

import UIKit
import MapKit

class RiderVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate  {

    
    @IBOutlet weak var MyMap: MKMapView!
    
    private var locationManager = CLLocationManager()
    private var userLocation: CLLocationCoordinate2D!
    private var riderLoaction: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    private func initializeLocationManager () {
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // if we have the coordinate from the manager
        if let location = locationManager.location?.coordinate {
            
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            let region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            MyMap.setRegion(region, animated: true)
            
            MyMap.removeAnnotations(MyMap.annotations)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = userLocation
            annotation.title = "Rider Location"
            
            MyMap.addAnnotation(annotation)
        }
        //
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logout(_ sender: Any) {
        if AuthProvider.instance.logout() {
            
            dismiss(animated: true, completion: nil)
        } else {
            
            alertUser(title: "Could Not Logout", message: "Could not logout, please try later")
            
        }
    }
    
    @IBAction func callUber(_ sender: Any) {
    }
    
    private func  alertUser(title: String, message: String)  {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}
