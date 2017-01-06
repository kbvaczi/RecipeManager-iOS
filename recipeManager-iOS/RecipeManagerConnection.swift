//
//  RecipeManagerConnection.swift
//  recipeManager-iOS
//
//  Created by KENNETH VACZI on 1/5/17.
//  Copyright © 2017 KENNETH VACZI. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RecipeManagerConnection {
    
    static let loginFlagKey = "RecipeManagerLoginFlag"
    static let emailKey = "RecipeManagerUserEmail"
    static let passwordKey = "RecipeManagerUserPassword"
    static let clientKey = "RecipeManagerClientToken"
    static let accessTokenKey = "RecipeManagerAccessToken"
    
    static let serverDateFormat = "YYYY-MM-dd"
    
    let rootURLString: String
    
    init(_ rootURL: String? = nil) {
        rootURLString = (rootURL == nil ? "http://localhost:3000" : rootURL!)
    }
    
    /////////////////////////////////////
    // GENERAL COMMUNICATION           //
    /////////////////////////////////////
    
    func request(_ urlString: String, method: HTTPMethod = .get, parameters: [String: Any] = [:], callback: @escaping (_ processedResponseJSON: JSON?, _ isSuccessful: Bool, _ statusCode: Int?) -> Void) {
        
        let requestHeaders: [String: String]? = isUserLoggedIn ? userAuthHeaders : nil
        
        print("executing request, URL: \(urlString), Method: \(method.rawValue), Special Headers: \(requestHeaders), Parameters: \(parameters)")
        
        Alamofire.request(urlString, method: method, parameters: parameters, encoding: URLEncoding.default, headers: requestHeaders)
            .validate()
            .responseJSON { response in
                guard   let statusCode = response.response?.statusCode,
                        let responseHeaders = response.response?.allHeaderFields as? [String: String],
                        let rawResponseJSON = response.result.value as? NSDictionary else {
                    print("Request error from \(urlString)")
                    callback(nil, false, nil)
                    return
                }
                let processedResponseJSON = JSON(rawResponseJSON)
                let isSuccessful = response.result.isSuccess
                
                self.updateUserAuthHeaders(responseHeaders: responseHeaders)
                
                // TODO: Login user if information is saved and response says authentication required
                
                print("Request Response, Status Code: \(statusCode), Headers: \(responseHeaders) JSON Retrieved: \(processedResponseJSON)")
                callback(processedResponseJSON, isSuccessful, statusCode)
        }
        
    }
    
    func formatDateStringForServer(_ dateToFormat: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = RecipeManagerConnection.serverDateFormat
        return dateFormatter.string(from: dateToFormat)
    }
    
    func dateFromJSONString(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = RecipeManagerConnection.serverDateFormat
        return dateFormatter.date(from: dateString)
    }
    
    /////////////////////////////////////
    // ACCOUNT FUNCTIONALITY           //
    /////////////////////////////////////
    
    func emailRegistrationRequest(email: String, password: String, passwordConfirmation: String, callback: @escaping (_ loginSuccess: Bool) -> Void) {
        
        let emailRegistrationURLString = rootURLString + "/auth"
        let registrationParameters: [String: Any] = [
            "email": email,
            "password": password,
            "password_confirmation": passwordConfirmation
        ]
        
        request(emailRegistrationURLString, method: .post, parameters: registrationParameters){ (processedResponseJSON: JSON?, isSuccessful: Bool, statusCode: Int?) -> Void in
            guard isSuccessful else {
                print("registration unsuccessful")
                callback(false)
                return
            }
            print("registration successful")
            callback(true)
        }
        
    }
    
    func loginRequest(email: String, password: String, callback: @escaping (_ loginSuccess: Bool) -> Void) {
        
        let loginURLString = rootURLString + "/auth/sign_in"
        let loginParameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        request(loginURLString, method: .post, parameters: loginParameters){ (processedResponseJSON: JSON?, isSuccessful: Bool, statusCode: Int?) -> Void in
            guard isSuccessful else {
                print("logging in unsuccessful")
                callback(false)
                return
            }
            self.setLoginFlag(email: email, password: password)
            callback(true)
        }
    }
    
    func logoutRequest(callback: @escaping (_ logoutSuccess: Bool) -> Void) {
        
        let logoutURLString = rootURLString + "/auth/sign_out"
        
        request(logoutURLString, method: .delete){ (processedResponseJSON: JSON?, isSuccessful: Bool, statusCode: Int?) -> Void in
            guard isSuccessful else {
                print("logging out unsuccessful")
                callback(false)
                return
            }
            print("logging out successful")
            self.clearLoginFlag()
            callback(true)
        }
    }
    
    // TODO: Store email and password in keychain
    
    var userEmail: String? {
        get {
            guard let email = UserDefaults.standard.value(forKey: RecipeManagerConnection.emailKey) as? String else {
                return nil
            }
            return email
        }
        set {
            UserDefaults.standard.set(newValue, forKey: RecipeManagerConnection.emailKey)
        }
    }
    
    var userPassword: String? {
        get {
            guard let email = UserDefaults.standard.value(forKey: RecipeManagerConnection.passwordKey) as? String else {
                return nil
            }
            return email
        }
        set {
            UserDefaults.standard.set(newValue, forKey: RecipeManagerConnection.passwordKey)
        }
    }
    
    var userClientToken: String? {
        get {
            guard let token = UserDefaults.standard.value(forKey: RecipeManagerConnection.clientKey) as? String else {
                return nil
            }
            return token
        }
        set {
            UserDefaults.standard.set(newValue, forKey: RecipeManagerConnection.clientKey)
        }
    }
    
    var userAccessToken: String? {
        get {
            guard let token = UserDefaults.standard.value(forKey: RecipeManagerConnection.accessTokenKey) as? String else {
                return nil
            }
            return token
        }
        set {
            UserDefaults.standard.set(newValue, forKey: RecipeManagerConnection.accessTokenKey)
        }
    }
    
    var userAuthHeaders: [String: String] {
        get {
            return ["uid": userEmail ?? "", "client": userClientToken ?? "", "access-token": userAccessToken ?? ""]
        }
    }
    
    func updateUserAuthHeaders(responseHeaders: [String: String]) {
        if (responseHeaders["client"] != nil) { userClientToken = responseHeaders["client"] }
        if (responseHeaders["access-token"] != nil) { userAccessToken = responseHeaders["access-token"] }
    }
    
    func setLoginFlag(email: String, password: String) {
        UserDefaults.standard.set(true, forKey: RecipeManagerConnection.loginFlagKey)
        userEmail = email
        userPassword = password
    }
    
    func clearLoginFlag() {
        UserDefaults.standard.set(false, forKey: RecipeManagerConnection.loginFlagKey)
        userEmail = nil
        userPassword = nil
    }
    
    var isUserLoggedIn: Bool {
        get {
            guard let loginFlag = UserDefaults.standard.value(forKey: RecipeManagerConnection.loginFlagKey) as? Bool else {
                return false
            }
            return loginFlag
        }
    }
    
}
