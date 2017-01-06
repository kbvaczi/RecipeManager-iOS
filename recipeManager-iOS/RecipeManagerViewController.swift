//
//  RecipeManagerViewController.swift
//  recipeManager-iOS
//
//  Created by KENNETH VACZI on 1/6/17.
//  Copyright © 2017 KENNETH VACZI. All rights reserved.
//

import UIKit

class RecipeManagerViewController: UIViewController {

    let connection = RecipeManagerConnection()
    
    var thisViewRequiresAuthentication: Bool {
        return true
    }
    
    override func viewDidLoad() {
        if thisViewRequiresAuthentication && !connection.isUserLoggedIn {
            presentLoginView()
        }
    }
    
    func presentLoginView() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginView") as! LoginViewController
        self.present(vc, animated: true, completion: nil)
    }

}
