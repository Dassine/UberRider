//
//  RiderVC.swift
//  UberRider
//
//  Created by Lilia Dassine BELAID on 2017-03-11.
//  Copyright © 2017 Lilia Dassine BELAID. All rights reserved.
//

import UIKit
import MapKit

class RiderVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UberController  {

    @IBOutlet weak var callUberBtn: UIButton!
    
    @IBOutlet weak var MyMap: MKMapView!
    
    private var locationManager = CLLocationManager()
    private var userLocation: CLLocationCoordinate2D!
    private var riderLoaction: CLLocationCoordinate2D!
    
    private var canCallUber = true
    private var riderCancelledRequest = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeLocationManager()
        
        UberHandler.instance.observeMessagesForRider()
    
        UberHandler.instance.delegate = self;
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
    
    func canCallUber(delegateCalled: Bool) {
    
        if delegateCalled {
            callUberBtn .setTitle("Cancel Uber", for: UIControlState.normal)
            canCallUber = false
        } else {
            callUberBtn .setTitle("Call Uber", for: UIControlState.normal)
            canCallUber = true 
        
        }
    }
    
    func driverAcceptedRequest(requestAccepted: Bool, driverName: String) {
    
        if !riderCancelledRequest {
            if requestAccepted {
                
                alertUser(title: "Uber Accepted", message: "\(driverName) accepted your uber request")
            }
        } else {
        
            UberHandler.instance.cancelUber()
            alertUser(title: "Uber Cancelled", message: "\(driverName) cancelled your uber request")
        }
    }
    
    @IBAction func callUber(_ sender: Any) {
        
        if userLocation != nil {
            if canCallUber {
                
                UberHandler.instance.requestUber(latitude: Double(userLocation!.latitude), longitude: Double(userLocation!.longitude))
            } else {
            
                riderCancelledRequest = true
                UberHandler.instance.cancelUber()
            }
        
        }
        
    }
    
    private func  alertUser(title: String, message: String)  {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}
