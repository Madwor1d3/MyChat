//
//  ViewController.swift
//  MyChat
//
//  Created by Madwor1d3 on 14/02/2019.
//  Copyright © 2019 Madwor1d3. All rights reserved.
//

import UIKit
import Firebase


class WelcomeVC: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil {
            
            performSegue(withIdentifier: "goToChatScreen", sender: self)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

