//
//  UberHandler.swift
//  UberRider
//
//  Created by Lilia Dassine BELAID on 2017-03-13.
//  Copyright © 2017 Lilia Dassine BELAID. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UberHandler {
    
    private static let _instance = UberHandler()
    
    var rider  = ""
    var driver = ""
    var riderId = ""
    
    static var instance: UberHandler {
        
        return _instance
    }
 
    func requestUber(latitude: Double, longitude: Double) {
        let data : Dictionary<String, Any> = [Constants.NAME: rider, Constants.LATITUDE: latitude, Constants.LONGITUDE: longitude]
        
        DBProvider.instance.requestRef.childByAutoId().setValue(data)
    } // Request UBER
}
