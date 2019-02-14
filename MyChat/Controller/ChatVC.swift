//
//  ChatVC.swift
//  MyChat
//
//  Created by Madwor1d3 on 14/02/2019.
//  Copyright © 2019 Madwor1d3. All rights reserved.
//

import UIKit
import Firebase

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {


    
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messageTableView.delegate = self
        messageTableView.dataSource = self
        // This method registers a MessageCell.xib
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil) , forCellReuseIdentifier: "customMessageCell")
        configureTableView()
    }
    
    
    @IBAction func sendButtonPressed(_ sender: Any) {
    }
    
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        
        do {
            
            try Auth.auth().signOut()
            
            navigationController?.popToRootViewController(animated: true)
        }
            
        catch {
            
            print("error: there was a problem logging out")
        }
    }
    
    

    // MARK: - Table View DataSource Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        let messageArray = ["First message", "Second message", "Third message"]
        
        cell.messageBody.text = messageArray[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    // This method determines the height of the line in the chat.
    func configureTableView() {
        
        messageTableView.rowHeight = UITableView.automaticDimension
        
        messageTableView.estimatedRowHeight = 120.0
    }
    
    
}
