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
    
    var currentMode: ViewMode?
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var passwordConfirmationLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var switchModeButton: UIButton!
    
    @IBAction func switchModes(_ sender: UIButton) {
        if currentMode == ViewMode.login {
            switchToSignUpView()
        } else {
            switchToLoginView()
        }
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        guard   let userUID = emailTextField.text,
                let userPassword = passwordTextField.text,
                let userPasswordConfirmation = passwordConfirmationTextField.text else {
                return
        }
        Connections.RMConnection.registrationRequest(uid: userUID, password: userPassword, passwordConfirmation: userPasswordConfirmation) { (signupSuccess: Bool) -> Void in
            if signupSuccess {
                self.switchToLoginView()
                let alert = UIAlertController(title: "Welcome!", message: "Please confirm your account using instructions emailed to the address provided.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                print("sign up failure")
                let alert = UIAlertController(title: "Oops!", message: "Something went wrong.  Please try again", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
        guard   let userUID = emailTextField.text,
                let userPassword = passwordTextField.text else {
                return
        }
        Connections.RMConnection.loginRequest(uid: userUID, password: userPassword) { (loginSuccess: Bool) -> Void in
            if loginSuccess {
                print("login successful")
                self.dismiss(animated: true, completion: nil)
            } else {
                print("login failure")
                let alert = UIAlertController(title: "Oops!", message: "Something went wrong.  Please try again", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
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
        currentMode = ViewMode.login
        switchModeButton.setTitle("Don't have an account?", for: .normal)
    }
    
    func switchToSignUpView() {
        headerLabel.text = "Please Sign Up"
        passwordConfirmationLabel.isHidden = false
        passwordConfirmationTextField.isHidden = false
        loginButton.isHidden = true
        signUpButton.isHidden = false
        currentMode = ViewMode.signup
        switchModeButton.setTitle("Already have an account?", for: .normal)
    }

    enum ViewMode {
        case signup
        case login
    }

}

