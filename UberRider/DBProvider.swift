//
//  DBProvider.swift
//  UberRider
//
//  Created by Lilia Dassine BELAID on 2017-03-12.
//  Copyright © 2017 Lilia Dassine BELAID. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DBProvider {
    
    private static let _instance = DBProvider()
    
    
    static var instance: DBProvider {
        
        return _instance
    }
    
    var dbRef: FIRDatabaseReference {
        
        return FIRDatabase.database().reference()
    }
    
    var ridersRef: FIRDatabaseReference {
        
        return dbRef.child(Constants.RIDERS)
    }
    
    //Request Ref
    var requestRef: FIRDatabaseReference {
        
        return dbRef.child(Constants.UBER_REQUEST)
    }
    
    
    //Accepter Ref
    
    var requestAcceptedRef: FIRDatabaseReference {
        
        return dbRef.child(Constants.UBER_ACCEPTED)
    }
    
    
    func saveUser(withID: String, email: String, password: String) {
        let data: Dictionary<String, Any> = [Constants.EMAIL: email, Constants.PASSWORD: password, Constants.IS_RIDER: true]
        
        ridersRef.child(withID).child(Constants.DATA).setValue(data)
        
    }
}
