//
//  ChatVC.swift
//  MyChat
//
//  Created by Madwor1d3 on 14/02/2019.
//  Copyright © 2019 Madwor1d3. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    
    var messageArray = [Message]()
    
    
    
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messageTableView.delegate     =   self
        messageTableView.dataSource   =   self
        messageTextField.delegate     =   self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        
        // This method registers a MessageCell.xib
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil) , forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
        retrieveMessages()
        messageTableView.separatorStyle = .none
    }
    
    
    
    //MARK: - Send & Receive from Firebase
    
    
    @IBAction func sendButtonPressed(_ sender: Any) {

        messageTextField.endEditing(true)
        
        //Send messages to Firebase and save it on our database
        
        messageTextField.isEnabled   =   false
        sendButton.isEnabled         =   false
        
        let messagesDB          =   Database.database().reference().child("Messages")
        let messageDictionary   =   ["Sender": Auth.auth().currentUser?.email, "MessageBody": messageTextField.text!]
        
        messagesDB.childByAutoId().setValue(messageDictionary) {
            (error, reference) in
            
            if error != nil {
                print(error!)
            }
            else {
                print("Message saved successfully!")
            }
            
            self.messageTextField.isEnabled   =   true
            self.sendButton.isEnabled         =   true
            self.messageTextField.text        =   ""
            }
        }
    
    
    
    func retrieveMessages() {
        
        let messageDB = Database.database().reference().child("Messages")
        
        messageDB.observe(.childAdded) {
            
            (snapshot) in
            
            let snapshotValue      =    snapshot.value as! Dictionary<String,String>
    
            let text               =    snapshotValue["MessageBody"]!
            
            let sender             =    snapshotValue["Sender"]!
            
            let message            =    Message()
            
            message.messageBody    =    text
            
            message.sender         =    sender
            
            self.messageArray.append(message)
            self.configureTableView()
            self.messageTableView.reloadData()
        }
    }
    
    
    
    //MARK: - Log Out Method
    
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        
        do {
            
            try Auth.auth().signOut()
            
            navigationController?.popToRootViewController(animated: true)
        }
            
        catch {
            
            print("error: there was a problem logging out")
        }
    }
    
    
    
    //MARK: Text Field Delegate Methods
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }

    
    
    // MARK: - Table View DataSource Methods
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        cell.messageBody.text        =   messageArray[indexPath.row].messageBody
        
        cell.senderUsername.text     =   messageArray[indexPath.row].sender
        
        cell.avatarImageView.image   =   UIImage(named: "egg")
        
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email! {
            
            //Set background to blue if message is from logged in user.
            cell.avatarImageView.backgroundColor    =   UIColor.flatMint()
            cell.messageBackground.backgroundColor  =   UIColor.flatSkyBlue()
            
        } else {
            
            //Set background to grey if message is from another user.
            cell.avatarImageView.backgroundColor    =   UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor  =   UIColor.flatGray()
        }
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messageArray.count
    }
    
    
    
    @objc func tableViewTapped() {
        
        messageTextField.endEditing(true)
    }
    
    

    func configureTableView() {
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
}
