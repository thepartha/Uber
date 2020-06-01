//
//  ViewController.swift
//  Uber
//
//  Created by partha on 5/31/20.
//  Copyright © 2020 partha. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    var signUpMode = true
    
    
    @IBOutlet var driverLabel: UILabel!
    @IBOutlet var riderLabel: UILabel!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var riderDriverSwitch: UISwitch!
    
    @IBOutlet var topButton: UIButton!
    @IBOutlet var bottomButton: UIButton!
    
    @IBAction func topButtonTapped(_ sender: Any) {
        if emailTextField.text == "" || passwordTextField.text == "" {
            displayAlert(title: "Missing Information", message: "You must provide both the username and password")
        } else {
            if let email = emailTextField.text, let password = passwordTextField.text {
                if signUpMode {
                    //SIGN UP
                    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                        if error != nil {
                            self.displayAlert(title: "Error", message: error!.localizedDescription)
                        } else {
                            
                            if self.riderDriverSwitch.isOn {
                                //DRIVER
                                let req = Auth.auth().currentUser?.createProfileChangeRequest()
                                req?.displayName = "Driver"
                                req?.commitChanges(completion: { (error) in
                                    print(error as Any)
                                })
                                 self.performSegue(withIdentifier: "driverSegue", sender: nil)
                            }else {
                                //RIDER
                                let req = Auth.auth().currentUser?.createProfileChangeRequest()
                                req?.displayName = "Rider"
                                req?.commitChanges(completion: { (error) in
                                    print(error as Any)
                                })
                                self.performSegue(withIdentifier: "riderSegue", sender: nil)
                            }
                            
                        }
                    }
                }else {
                    //LOG IN
                    Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                        if error != nil {
                            self.displayAlert(title: "Error", message: error!.localizedDescription)
                        } else {
                            if user?.user.displayName == "Driver" {
                                self.performSegue(withIdentifier: "driverSegue", sender: nil)
                            } else {
                                self.performSegue(withIdentifier: "riderSegue", sender: nil)
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func bottomButtonTapped(_ sender: Any) {
        if signUpMode {
            topButton.setTitle("Log In", for: .normal)
            bottomButton.setTitle("Switch to Sign up", for: .normal)
            riderLabel.isHidden = true
            driverLabel.isHidden = true
            riderDriverSwitch.isHidden = true
            signUpMode = false
        } else {
            topButton.setTitle("Sign Up", for: .normal)
            bottomButton.setTitle("Switch to Login", for: .normal)
            riderLabel.isHidden = false
            driverLabel.isHidden = false
            riderDriverSwitch.isHidden = false
            signUpMode = true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}

