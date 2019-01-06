//
//  ViewController.swift
//  Flash Chat
//
//  Created by Juan Diego Ocampo on 04/01/2019.
//  Copyright © 2019 Juan Diego Ocampo. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
// Variables

    var messageArray : [Message] = [Message]() // Empty Array
    
// Pre-linked IB-Outlets
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
// This method specifies what happens after the View loads succesfully.
    
    override func viewDidLoad() {
        super.viewDidLoad()
    // Setting yourself as the Delegate and DataSource
        messageTableView.delegate = self
        messageTableView.dataSource = self
    // Setting yourself as the Delegate of the TextField
        messageTextfield.delegate = self
    // Setting the tapGesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
    // Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        configureTableView()
        retrieveMessages()
    }

// TableView DataSource Methods
    
    // cellForRowAtIndexPath Method:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String! {
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
        } else {
            cell.avatarImageView.backgroundColor = UIColor.flatWhite()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }
        return cell
    }
    // numberOfRowsInSection Method:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    // tableViewTapped Method:
    @objc func tableViewTapped() {
        messageTextfield.endEditing(true)
    }
    // configureTableView Method:
    func configureTableView() {
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120
    }

// TextField Delegate Methods
    
    // textFieldDidBeginEditing Method:
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5, animations: {
            self.heightConstraint.constant = 350
            self.view.layoutIfNeeded()})
    }
    // textFieldDidEndEditing Method:
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5, animations: {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()})
    }
    
// Mehods for Sending & Receiving Data from FireBase

    //Mehods for Sending & Receiving Data from FireBase
    
// This method specifies what happens after the Send Button is pressed.
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        messageTextfield.endEditing(true)
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        let messagesDB = Database.database().reference().child("Messages")
        let messageDictionary = ["Sender" : Auth.auth().currentUser?.email, "MessageBody" : messageTextfield.text!]
        messagesDB.childByAutoId().setValue(messageDictionary) {
            (error, reference) in
            if error != nil {
                print(error!)
            } else {
                print("Message Saved")
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextfield.text = ""
            }
        }
    }

// RetrieveMessages Method
    
    func retrieveMessages() {
        let messageDB = Database.database().reference().child("Messages")
        messageDB.observe(.childAdded, with: {(snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            let message = Message()
            message.messageBody = text
            message.sender = sender
            self.messageArray.append(message)
            self.configureTableView()
            self.messageTableView.reloadData()
        })
    }
    
// This method specifies what happens after the LogOut Button is pressed.
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        do {
            try Auth.auth().signOut()
    // This line is what takes the user back to the welcome screen.
            navigationController?.popViewController(animated: true)
        } catch  {
            print("There was a problem signing out.")
    // Create the alert.
            let alert = UIAlertController(title: "Error", message: "There was a problem signing out", preferredStyle: UIAlertController.Style.alert)
    // Add an action (Button).
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
    // Show the alert.
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
