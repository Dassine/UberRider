//
//  ViewController.swift
//  UberRider
//
//  Created by Lilia Dassine BELAID on 2017-03-04.
//  Copyright © 2017 Lilia Dassine BELAID. All rights reserved.
//

import UIKit
import FirebaseAuth

class SigninVC: UIViewController {

    private let RIDER_SEGUE = "RiderVC"
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func login(_ sender: Any) {
        
        if emailTextField.text != "" || passwordTextField.text != "" {
            AuthProvider.instance.login(withEmail: emailTextField.text!, password: passwordTextField.text!, loginHandler: {(message) in
                if message != nil {
                    
                    self.alertUser(title: "Problem whit Auth", message: message!.rawValue)
                    
                } else {
                    
                    self.performSegue(withIdentifier: self.RIDER_SEGUE, sender: nil)
                }
            })
        } else {
            self.alertUser(title: "Email And Password are required", message: "Please enter email and password")
        }
    }

    @IBAction func signUp(_ sender: Any) {
        
        if emailTextField.text != "" || passwordTextField.text != "" {
            AuthProvider.instance.signUp(withEmail: emailTextField.text!, password: passwordTextField.text!, loginHandler: {(message) in
                if message != nil {
                    
                    self.alertUser(title: "Problem With Creating A New User", message: message!.rawValue)
                    
                } else {
                    
                    self.performSegue(withIdentifier: self.RIDER_SEGUE, sender: nil)
                }
            })
        } else {
            self.alertUser(title: "Email And Password are required", message: "Please enter email and password")
        }
    }
    
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
    
    private func  alertUser(title: String, message: String)  {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}

