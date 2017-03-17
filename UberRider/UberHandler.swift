//
//  UberHandler.swift
//  UberRider
//
//  Created by Lilia Dassine BELAID on 2017-03-13.
//  Copyright © 2017 Lilia Dassine BELAID. All rights reserved.
//

import Foundation
import FirebaseDatabase
protocol UberController : class {
    
    func canCallUber(delegateCalled: Bool)
    func driverAcceptedRequest(requestAccepted: Bool, driverName: String)
    func updateDriverLocation(lat: Double, long: Double)
}

class UberHandler {
    
    weak var delegate: UberController?
    
    private static let _instance = UberHandler()
    
    var rider  = ""
    var driver = ""
    var rider_id = ""
    
    static var instance: UberHandler {
        
        return _instance
    }
 
    func observeMessagesForRider() {
        //Rider requested uber
        DBProvider.instance.requestRef.observe(FIRDataEventType.childAdded) { (snapshot: FIRDataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
            
                if let name = data[Constants.NAME] as? String {
                    if name == self.rider {
                    
                        self.rider_id = snapshot.key
                        print("the valeu is \(self.rider_id)")
                        self.delegate?.canCallUber(delegateCalled: true)
                    }
                    
                }
            }
        }
        
        //Rider cancelled uber
        DBProvider.instance.requestRef.observe(FIRDataEventType.childRemoved) { (snapshot: FIRDataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                
                if let name = data[Constants.NAME] as? String {
                    if name == self.rider {
                        self.delegate?.canCallUber(delegateCalled: false)
                    }
                    
                }
            }
        }
        
        
        //Driver accepted Rider request
        DBProvider.instance.requestAcceptedRef.observe(FIRDataEventType.childAdded) { (snapshot: FIRDataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                
                if let name = data[Constants.NAME] as? String {
                    if self.driver == "" {
                        self.driver = name
                        self.delegate?.driverAcceptedRequest(requestAccepted: true, driverName: self.driver)
                        
                    }
                    
                }
            }
        }
        
        //Driver cancelled
        DBProvider.instance.requestAcceptedRef.observe(FIRDataEventType.childRemoved) { (snapshot: FIRDataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                
                if let name = data[Constants.NAME] as? String {
                    if name == self.driver {
                        self.driver = ""
                        self.delegate?.driverAcceptedRequest(requestAccepted: false, driverName: name)
                        
                    }
                    
                }
            }
        }
        
        //Driver updating location
        DBProvider.instance.requestAcceptedRef.observe(FIRDataEventType.childChanged) { (snapshot: FIRDataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.NAME] as? String {
                    if name == self.driver {
                        if let lat = data[Constants.LATITUDE] as? Double {
                            if let long = data[Constants.LONGITUDE] as? Double {
                                self.delegate?.updateDriverLocation(lat: lat, long: long)
                            }
                        }
                    }
                    
                }
            }
        }

        
    }
    
    func requestUber(latitude: Double, longitude: Double) {
        let data : Dictionary<String, Any> = [Constants.NAME: rider, Constants.LATITUDE: latitude, Constants.LONGITUDE: longitude]
        
        DBProvider.instance.requestRef.childByAutoId().setValue(data)
    } // Request UBER
    
    func cancelUber() {
        DBProvider.instance.requestRef.child(rider_id).removeValue()
    }
    
    
    func updateRiderLocation(lat: Double, long: Double){
    
        DBProvider.instance.requestRef.child(rider_id).updateChildValues([Constants.LATITUDE: lat, Constants.LONGITUDE: long])
    }
}
