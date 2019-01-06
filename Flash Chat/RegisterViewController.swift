//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase.
//
//  Created by Juan Diego Ocampo on 04/01/2019.
//  Copyright © 2019 Juan Diego Ocampo. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController {

// Pre-Linked IB-Outlets

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
    
// This method specifies what happens after the Register button is pressed.
  
    @IBAction func registerPressed(_ sender: AnyObject) {
        SVProgressHUD.show()
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!)
        {(user, error) in
            if error != nil {
               print(error!) // Registration Failed
            } else {
               self.emailTextfield.text = ""
               self.passwordTextfield.text = ""
               print("Registration Succesful") // Registration Succesfull
               SVProgressHUD.dismiss()
    // Takes the uset to the chat screen.
               self.performSegue(withIdentifier: "goToChat", sender: self)
    // Create the alert
               let alert = UIAlertController(title: "You're All Set!", message: "Registration Succesful", preferredStyle: UIAlertController.Style.alert)
    // Add an action (Button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
    // Show the alert
               self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
