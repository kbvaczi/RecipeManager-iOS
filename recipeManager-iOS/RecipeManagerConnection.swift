//
//  RecipeManagerConnection.swift
//  recipeManager-iOS
//
//  Created by KENNETH VACZI on 1/5/17.
//  Copyright © 2017 KENNETH VACZI. All rights reserved.
//
//  RecipeManagerConnection interfaces between local Recipe Manager models and the Recipe Manager API on the server.

import Foundation
import Alamofire
import SwiftyJSON
import MKUnits

class RecipeManagerConnection {
    
    static let loginFlagKey = "RecipeManagerLoginFlag"
    static let emailKey = "RecipeManagerUserEmail"
    static let passwordKey = "RecipeManagerUserPassword"
    static let clientKey = "RecipeManagerClientToken"
    static let accessTokenKey = "RecipeManagerAccessToken"
    
    let rootURLString: String
    
    init(_ rootURL: String? = nil) {

        rootURLString = (rootURL == nil ? "http://localhost:3000" : rootURL!)
    }

}

/////////////////////////////////////
// GENERAL COMMUNICATION           //
/////////////////////////////////////

extension RecipeManagerConnection {

    func request(_ urlString: String, method: HTTPMethod = .get, parameters: [String: Any] = [:], callback: @escaping (_ processedResponseJSON: JSON?, _ isSuccessful: Bool, _ statusCode: Int?) -> Void) {
        
        let requestHeaders: [String: String]? = isUserLoggedIn ? userAuthHeaders : nil
        
        print("executing request, URL: \(urlString), Method: \(method.rawValue), Special Headers: \(requestHeaders), Parameters: \(parameters)")
        
        Alamofire.request(urlString, method: method, parameters: parameters, encoding: URLEncoding.default, headers: requestHeaders)
            .validate()
            .responseJSON { response in
                print("statusCode: \(response.response?.statusCode)")
                print("headers: \(response.response?.allHeaderFields)")
                print("JSON: \(response.result.value)")
                let statusCode = response.response?.statusCode
                let responseHeaders = response.response?.allHeaderFields as? [String: String]
                switch response.result {
                case .success(let data):
                    self.updateUserAuthHeaders(responseHeaders: responseHeaders)
                    let processedResponseJSON = JSON(data)
                    callback(processedResponseJSON, true, statusCode)
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    // TODO: Login user if information is saved and response says authentication required
                }
        }
    }

}

/////////////////////////////////////
// ACCOUNT FUNCTIONALITY           //
/////////////////////////////////////

extension RecipeManagerConnection {

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
    
    func updateUserAuthHeaders(responseHeaders: [String: String]?) {

        guard let responseHeaders = responseHeaders else { return }
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

/////////////////////////////////////
// RECIPES                         //
/////////////////////////////////////

extension Recipe {

    init(fromJSON: JSON?, fromRecipeParse: Bool? = nil) {

        guard let recipeJSON = fromJSON else {
            self.init()
            return
        }

        var id: UUID? = nil
        var recipeParseID: UUID? = nil
        if fromRecipeParse == true {
            recipeParseID = UUID(uuidString: recipeJSON["id"].string ?? "")
        } else {
            id = UUID(uuidString: recipeJSON["id"].stringValue)
        }

        let name = recipeJSON["name"].stringValue
        let sourceURLString = recipeJSON["sourceURL"].string
        let imageURLString = recipeJSON["imageURL"].string

        var ingredients = [Ingredient]()
        let ingredientsJSON = recipeJSON["ingredients"]
        if ingredientsJSON.exists() {
            for (_,ingredientJSON):(String, JSON) in ingredientsJSON {
                let ingredientName: String = ingredientJSON["name"].string ?? ""
                let ingredientDescription: String? = ingredientJSON["description"].string
                let ingredientID: UUID? = UUID(uuidString: ingredientJSON["id"].stringValue)
                let ingredientAmount = Decimal(ingredientJSON["amount"].double ?? 1.0)
                let ingredientUnitName = ingredientJSON["amountUnit"].string ?? "count"
                let ingredient = Ingredient(name: ingredientName,
                                            description: ingredientDescription,
                                            id: ingredientID,
                                            amount: ingredientAmount,
                                            amountUnitName: ingredientUnitName)
                ingredients.append(ingredient)
            }
        }

        var directions = [String]()
        let directionsJSON = recipeJSON ["directions"]
        if directionsJSON.exists() {
            for (_,directionJSON):(String, JSON) in directionsJSON {
                if let directionString = directionJSON.string {
                    directions.append(directionString)
                }
            }
        }
        self.init(name, id: id, recipeParseID: recipeParseID, sourceURLString: sourceURLString, imageURLString: imageURLString, ingredients: ingredients, directions: directions)
    }

    func toParameters() -> [String: Any] {

        var parameters = [String:Any]()
        parameters["name"] = self.name
        if let idString = self.id?.uuidString.lowercased() { //only send parameter if it exists
            parameters["id"] = idString // Rails failed when not lowercased?
        }
        parameters["sourceURL"] = self.sourceURL?.absoluteString
        parameters["imageURL"] = self.imageURL?.absoluteString
        if let recipeParseIDString = self.recipeParseID?.uuidString.lowercased() { //only send parameter if it exists
            parameters["recipeParseID"] = recipeParseIDString // Rails failed when not lowercased?
        }
        var ingredientsParameters = [[String: Any]]()
        for ingredient in self.ingredients {
            ingredientsParameters.append(ingredient.toParameters())
        }
        parameters["ingredients_attributes"] = ingredientsParameters
        parameters["directions"] = self.directions

        print("Recipe To PARAMETERS: \(parameters)")

        return parameters
    }

}

extension Ingredient {

    func toParameters() -> [String: Any] {

        var parameters: [String: Any] = [
            "description": self.description,
            "amount": self.amount,
            "amountUnit": self.amountUnit.name
        ]
        if let uuidString = self.id?.uuidString.lowercased() { //only send id parameter if it exists
            parameters["id"] = uuidString // Rails failed when not lowercased?
        }
        if self._destroy { //only send id parameter if it exists
            // send this parameter to destory model on rails server when sent as nested_attribute
            // accepts_nested_attributes and allow_destroy must be set to true in parent model
            parameters["_destroy"] = true
        }
        return parameters
    }

}

extension RecipeManagerConnection {

    func requestGetRecipes(callback: @escaping (_ isSuccessful: Bool, _ recipes: [Recipe]) -> Void) {

        let requestURLString = rootURLString + "/recipes"
        let requestMethod: HTTPMethod = .get

        request(requestURLString, method: requestMethod) { (processedResponseJSON: JSON?, isSuccessful: Bool, statusCode: Int?) -> Void in
            var recipes = [Recipe]()
            guard isSuccessful else {
                print("error getting recipes")
                callback(false, recipes)
                return
            }
            print("succesfully got recipes")
            guard let recipesJSON = processedResponseJSON else { callback(true, recipes); return }
            for (_, recipeJSON) in recipesJSON {
                recipes.append(Recipe(fromJSON: recipeJSON))
            }
            callback(true, recipes)
        }
    }

    func requestCreateRecipeParse(recipeSourceURL: String, callback: @escaping (_ isSuccessful: Bool, _ processedResponseJSON: JSON?) -> Void) {

        let createRecipeParseURLString = rootURLString + "/recipe_parses"
        let requestParameters: [String: Any] = ["recipe_parse": ["url": recipeSourceURL]]
        
        request(createRecipeParseURLString, method: .post, parameters: requestParameters){ (processedResponseJSON: JSON?, isSuccessful: Bool, statusCode: Int?) -> Void in
            guard isSuccessful else {
                print("error creating recipe parse")
                callback(false, processedResponseJSON)
                return
            }
            print("successfully created recipe parse")
            callback(true, processedResponseJSON)
        }
    }

    func requestCreateRecipe(recipe: Recipe, callback: @escaping (_ isSuccessful: Bool, _ processedResponseJSON: JSON?) -> Void) {

        let requestURLString = rootURLString + "/recipes"
        let requestMethod: HTTPMethod = .post
        let requestParameters: [String: Any] = ["recipe": recipe.toParameters()]

        request(requestURLString, method: requestMethod, parameters: requestParameters){ (processedResponseJSON: JSON?, isSuccessful: Bool, statusCode: Int?) -> Void in
            guard isSuccessful else {
                print("error creating recipe")
                callback(false, processedResponseJSON)
                return
            }
            print("successfully created recipe")
            callback(true, processedResponseJSON)
        }
    }

    func requestUpdateRecipe(recipe: Recipe, callback: @escaping (_ isSuccessful: Bool, _ updatedRecipe: Recipe?) -> Void) {

        guard let recipeIDString = recipe.id?.uuidString else { callback(false, nil) ; return }

        let requestURLString = rootURLString + "/recipes/" + recipeIDString
        let requestMethod: HTTPMethod = .patch
        let requestParameters: [String: Any] = ["recipe": recipe.toParameters()]

        request(requestURLString, method: requestMethod, parameters: requestParameters){ (processedResponseJSON: JSON?, isSuccessful: Bool, statusCode: Int?) -> Void in
            guard isSuccessful else {
                print("error updating recipe")
                callback(false, nil)
                return
            }
            print("successfully updated recipe")
            let updatedRecipe = Recipe(fromJSON: processedResponseJSON)
            callback(true, updatedRecipe)
        }
    }

    func requestDestroyRecipe(recipe: Recipe, callback: @escaping (_ isSuccessful: Bool) -> Void) {

        guard let recipeIDString = recipe.id?.uuidString else { callback(false) ; return }

        let requestURLString = rootURLString + "/recipes/" + recipeIDString
        let requestMethod: HTTPMethod = .delete
        let requestParameters: [String: Any] = ["recipe": ["id": recipeIDString]]

        request(requestURLString, method: requestMethod, parameters: requestParameters){
            (processedResponseJSON: JSON?, isSuccessful: Bool, statusCode: Int?) -> Void in
            guard isSuccessful else {
                print("error deleting recipe")
                callback(false)
                return
            }
            print("successfully deleted recipe")
            callback(true)
        }
    }

}
