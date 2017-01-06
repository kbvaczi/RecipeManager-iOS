//
//  AccountViewController.swift
//  recipeManager-iOS
//
//  Created by KENNETH VACZI on 1/6/17.
//  Copyright © 2017 KENNETH VACZI. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    
    @IBOutlet weak var accountLabel: UILabel!
    
    @IBAction func logout(_ sender: UIButton) {
        connection.logoutRequest() { (logoutSuccess: Bool) -> Void in
            if logoutSuccess {
                self.accountLabel.text = ""
            }
        }
    }
    
    let connection = RecipeManagerConnection()
    
    override func viewDidAppear(_ animated: Bool) {
        accountLabel.text = connection.userEmail
    }

}
