//
//  LogInViewController.swift
//  Flash Chat
//
//  This is the ViewController where users login.
//
//  Created by Juan Diego Ocampo on 04/01/2019.
//  Copyright © 2019 Juan Diego Ocampo. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LogInViewController: UIViewController {

// Text-Fields pre-linked with IB-Outlets.
    
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
// This method specifies what happens after the View loads succesfully.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

// This method specifies what happens after the View receives a memory warning.
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

// This method specifies what happens after the LogIn Button is pressed.
    
    @IBAction func logInPressed(_ sender: AnyObject) {
        SVProgressHUD.show()
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) {(user, error) in
            if error != nil {
            } else {
                self.emailTextfield.text = ""
                self.passwordTextfield.text = ""
                print("Login Succesful")
                SVProgressHUD.dismiss()
    // Takes the uset to the chat screen.
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }
    }
    
}
