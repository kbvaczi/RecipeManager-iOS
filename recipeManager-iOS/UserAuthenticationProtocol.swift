//
//  UserAuthenticationProtocol.swift
//  recipeManager-iOS
//
//  Created by KENNETH VACZI on 1/7/17.
//  Copyright © 2017 KENNETH VACZI. All rights reserved.
//

import UIKit

protocol UserAuthenticationRequired {

    func presentLoginView()
}

extension UserAuthenticationRequired where Self: UIViewController {

    func presentLoginView() {

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginView") as! LoginViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    func viewDidLoad() {

        if !Connections.RMConnection.isUserLoggedIn {
            presentLoginView()
        }
    }
}
