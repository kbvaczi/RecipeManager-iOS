//
//  NewRecipeViewController.swift
//  recipeManager-iOS
//
//  Created by KENNETH VACZI on 1/8/17.
//  Copyright © 2017 KENNETH VACZI. All rights reserved.
//

import UIKit

class NewRecipeViewController: RecipeFormViewController {

    @IBAction func save(_ sender: AnyObject) {
        guard   let recipe = self.recipe,
                formIsValid() else { return }
        Connections.RMConnection.requestCreateRecipe(recipe: recipe) { (isSuccessful, recipeJSON) in
            if isSuccessful {
                let savedRecipe = Recipe(fromJSON: recipeJSON)
                self.recipe = savedRecipe //update recipe ID now that it's saved
                let previousController = self.navigationController?.previousViewController()
                self.sendDataToView(destinationVC: previousController!, data: self.data)
                self.returnToPreviousView()
            } else {
                let alert = UIAlertController(
                    title: "Oops!",
                    message: "We were unable to update your recipe",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    @IBAction func cancel(_ sender: AnyObject) {
        returnToPreviousView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        recipe = Recipe()
        presentRecipeParseAlertController()
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerHeight: CGFloat
        headerHeight = 21
        return headerHeight
    }

    func presentRecipeParseAlertController() {
        let alert = UIAlertController(
            title: "Import Recipe From Website?",
            message: nil,
            preferredStyle: .alert
        )
        alert.addTextField() { textField in
            textField.placeholder = "Enter recipe link"
        }
        let importRecipeAction = UIAlertAction(
            title: "Import",
            style: .default,
            handler: { (action) in
            guard let recipeURL = alert.textFields?.first?.text else { return }
            self.activityIndicator.startAnimating()
            Connections.RMConnection.requestCreateRecipeParse(recipeSourceURL: recipeURL) {
                (isSuccessful, recipeParseJSON) in
                self.activityIndicator.stopAnimating()
                guard isSuccessful == true else {
                    //TODO : alert failure
                    return
                }
                let importedRecipe = Recipe(fromJSON: recipeParseJSON, fromRecipeParse: true)
                self.sendDataToView(destinationVC: self, data: importedRecipe)
            }
        })
        alert.addAction(importRecipeAction)
        let cancelAction = UIAlertAction(title: "No Thanks", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

}
