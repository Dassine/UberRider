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
        
        }
    }

    @IBAction func signUp(_ sender: Any) {
    }
}

