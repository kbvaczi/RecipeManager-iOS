//
//  LoginViewController.swift
//  recipeManager-iOS
//
//  Created by KENNETH VACZI on 1/6/17.
//  Copyright © 2017 KENNETH VACZI. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    let connection = RecipeManagerConnection()
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var passwordConfirmationLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func signUp(_ sender: UIButton) {
        guard   let userEmail = emailTextField.text,
                let userPassword = passwordTextField.text,
                let userPasswordConfirmation = passwordConfirmationTextField.text else {
                return
        }
        connection.emailRegistrationRequest(email: userEmail, password: userPassword, passwordConfirmation: userPasswordConfirmation) { (signupSuccess: Bool) -> Void in
            if signupSuccess {
                // TODO: Prompt user to confirm email account prior to logging in
                self.switchToLoginView()
            } else {
                print("sign up failure")
            }
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
        guard   let userEmail = emailTextField.text,
                let userPassword = passwordTextField.text else {
                return
        }
        connection.loginRequest(email: userEmail, password: userPassword) { (loginSuccess: Bool) -> Void in
            if loginSuccess {
                print("login successful")
                self.dismiss(animated: true, completion: nil)
            } else {
                print("login failure")
            }
        }
    }
    
    override func viewDidLoad() {
        switchToSignUpView()
    }
    
    func switchToLoginView() {
        headerLabel.text = "Please Login"
        passwordConfirmationLabel.isHidden = true
        passwordConfirmationTextField.isHidden = true
        loginButton.isHidden = false
        signUpButton.isHidden = true
    }
    
    func switchToSignUpView() {
        headerLabel.text = "Please Sign Up"
        passwordConfirmationLabel.isHidden = false
        passwordConfirmationTextField.isHidden = false
        loginButton.isHidden = true
        signUpButton.isHidden = false
    }

    
}

