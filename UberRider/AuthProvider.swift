//
//  AuthProvider.swift.swift
//  UberRider
//
//  Created by Lilia Dassine BELAID on 2017-03-06.
//  Copyright © 2017 Lilia Dassine BELAID. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias LoginHandler = (_ message: LoginErrorCode?) -> Void

enum LoginErrorCode: String {
    case INVALID_EMAIL = "Invalid Email, please provide a read email address"
    case WRONG_PASSWORD = "Wrong password, please enter a correct password"
    case PROBLEM_CONNECT = "Problem connecting to database"
    case USER_NOT_FOUND = "User not found, please register"
    case EMAIL_ALREADY_IN_USE = "Email already in use, please enter another email"
    case WEAK_PASSWORD = "PAssword should be at least 6 characters long"
    
}

class AuthProvider {
    
    private static let _instance = AuthProvider()
    
    
    static var instance: AuthProvider {
        
        return _instance
    }
    
    func login(withEmail: String, password: String, loginHandler: LoginHandler?) {
        
        FIRAuth.auth()?.signIn(withEmail: withEmail, password: password, completion: {(user, error) in
            
            if error != nil {
                self.handleErrors(err: error as! NSError, loginHandler: loginHandler)
                
            } else {
                loginHandler?(nil)
            }
        })
        
    } // login func
    
    func signUp(withEmail: String, password: String, loginHandler: LoginHandler?) {
        FIRAuth.auth()?.createUser(withEmail: withEmail, password: password, completion: {(user, error) in
            
            if error != nil {
                self.handleErrors(err: error as! NSError, loginHandler: loginHandler)
                
            } else {
                if user?.uid != nil {
                    
                    // Store the user in the database
                    if user?.uid != nil {
                        
                        // Store the user in the database
                        DBProvider.instance.saveUser(withID: (user?.uid)!, email: withEmail, password: password)
                        
                        // Sign in
                        self.login(withEmail: withEmail, password: password, loginHandler: loginHandler)
                        
                    }
                    
                    // Sign in
                    self.login(withEmail: withEmail, password: password, loginHandler: loginHandler)
                    
                }
            }
        })
        
    } // signup func
    
    func logout() -> Bool {
        
        if FIRAuth.auth()?.currentUser != nil {
            
            do {
                
                try FIRAuth.auth()?.signOut()
                return true
            } catch {
                return false
            }
        }
        
        return true
    } // logout func
    
    private func handleErrors(err: NSError, loginHandler: LoginHandler?) {
        if let errorCode = FIRAuthErrorCode(rawValue: err.code) {
            
            switch errorCode {
            case .errorCodeWrongPassword:
                loginHandler?(.WRONG_PASSWORD)
                break
            case .errorCodeInvalidEmail:
                loginHandler?(.INVALID_EMAIL)
                break
            case .errorCodeUserNotFound:
                loginHandler?(.USER_NOT_FOUND)
                break
            case .errorCodeEmailAlreadyInUse:
                loginHandler?(.EMAIL_ALREADY_IN_USE)
                break
            case .errorCodeWeakPassword:
                loginHandler?(.WEAK_PASSWORD)
                break
                
            default:
                loginHandler?(.PROBLEM_CONNECT)
                break
            }
        }
    }
}
