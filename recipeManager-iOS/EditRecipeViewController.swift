//
//  EditRecipeViewController.swift
//  recipeManager-iOS
//
//  Created by KENNETH VACZI on 1/8/17.
//  Copyright © 2017 KENNETH VACZI. All rights reserved.
//

import UIKit
import Eureka

class EditRecipeViewController: RecipeFormViewController, FormDeletable {

    @IBAction func save(_ sender: AnyObject) {
        guard let recipeToUpdate = recipe,
              formIsValid() else { return }
        Connections.RMConnection.requestUpdateRecipe(recipe: recipeToUpdate) {
            (isSuccessful, updatedRecipe) in
            if isSuccessful {
                guard let previousController =
                    self.navigationController?.previousViewController() else { return }
                self.sendDataToView(destinationVC: previousController, data: updatedRecipe)
                self.returnToPreviousView()
            } else {
                let alert = UIAlertController(
                    title: "Oops!",
                    message: "We were unable to save your recipe",
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

    func deleteObject() {
        guard let recipeToDelete = recipe else { return }
        Connections.RMConnection.requestDestroyRecipe(recipe: recipeToDelete) { isSuccessful in
            if isSuccessful {
                //TODO: find some way to tell previous controller that recipe has been deleted
                let _ = self.navigationController?.popToRootViewController(animated: true)
            } else {
                let alert = UIAlertController(
                    title: "Oops!",
                    message: "We were unable to delete your recipe",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerHeight: CGFloat
        headerHeight = 21
        return headerHeight
    }

    override func customConfigureForm() {
        addDeleteButtonToForm()
    }

}

