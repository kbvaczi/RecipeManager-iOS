//
//  AccountViewController.swift
//  recipeManager-iOS
//
//  Created by KENNETH VACZI on 1/6/17.
//  Copyright © 2017 KENNETH VACZI. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController, UserAuthenticationRequired {
    
    @IBOutlet weak var accountLabel: UILabel!
    
    @IBAction func logout(_ sender: UIButton) {
        Connections.RMConnection.logoutRequest() { (logoutSuccess: Bool) -> Void in
            if logoutSuccess {
                self.accountLabel.text = ""
            }
        }
        presentLoginView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        accountLabel.text = Connections.RMConnection.userUID
    }
    
}
