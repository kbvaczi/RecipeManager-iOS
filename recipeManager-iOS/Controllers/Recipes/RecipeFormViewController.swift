//
//  RecipesFormViewController.swift
//  recipeManager-iOS
//
//  Created by KENNETH VACZI on 1/10/17.
//  Copyright © 2017 KENNETH VACZI. All rights reserved.
//

import UIKit
import Eureka

class RecipeFormViewController: FormViewController, ViewDataTransfer {
    
    var recipe: Recipe?

    var data: Any? {
        get { return self.recipe }
        set {
            guard let newRecipe = newValue as? Recipe else {return}
            self.recipe = newRecipe
            self.configureForm()
            self.tableView?.reloadData()
        }
    }
    
    var activityIndicator = ActivityIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.addToView(self.view)
        configureForm()
        customConfigureForm()
    }
    
    func configureForm() {
        
        let errorColor =  UIColor(red: 255, green: 0, blue: 0, alpha: 0.5)
        
        let nameSection = Section(){
            $0.tag = "name"
        }
        <<< TextRow("Name"){ row in
            row.value = recipe?.name
            row.title = ""
            row.placeholder = "Recipe Name"
            row.add(rule: RuleRequired())
            row.validationOptions = .validatesOnChange
        }
        .onChange { [weak self] row in
                self?.recipe?.name = row.value ?? ""
        }
        .onRowValidationChanged { cell, row in
            let rowIndex = row.indexPath!.row
            while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                row.section?.remove(at: rowIndex + 1)
            }
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    let labelRow = LabelRow() {
                        $0.title = validationMsg
                        $0.cell.height = { 30 }
                        $0.cell.backgroundColor = errorColor
                    }
                    row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                }
            }
        }
        
        let detailsSection = Section("Details")
        detailsSection <<< URLRow("Image URL"){ row in
            row.value = recipe?.imageURL
            row.title = "Image"
            row.placeholder = "Image URL"
        }.onChange() { urlRow in
            self.recipe?.imageURL = urlRow.value
        }
        detailsSection <<< URLRow("Source Website"){ row in
            row.value = recipe?.sourceURL
            row.title = "Website"
            row.placeholder = ""
        }.onChange() { urlRow in
            self.recipe?.sourceURL = urlRow.value
        }

        let ingredientsSection = Section("Ingredients")
        let ingredientsListRow = ExpandableListRow("Add Ingredient")
        ingredientsListRow.onCellSelection() { cell, listRow in
            guard self.recipe != nil else { return }
            let newIngredient = Ingredient(description: "Good Intentions", amount: 1, amountUnitName: "cup")
            self.recipe?.ingredients.append(newIngredient)
            let newRow = self.newIngredientRow(value: newIngredient)
            listRow.insertRowAndEdit(newRow)
            newRow.didSelect()
        }
        ingredientsSection <<< ingredientsListRow
        if let ingredients = recipe?.ingredients {
            for ingredient in ingredients {
                let newRow = newIngredientRow(value: ingredient)
                ingredientsListRow.insertRow(newRow)
            }
        }

        let directionsSection = Section("Directions")
        let directionsListRow = ExpandableListRow("Add Direction")
        directionsListRow.onCellSelection() { cell, listRow in
            guard self.recipe != nil else { return }
            let newDirection = "Add love and stir"
            self.recipe?.directions.append(newDirection)
            let newRow = self.newDirectionRow(value: newDirection)
            listRow.insertRowAndEdit(newRow)
        }
        directionsSection <<< directionsListRow
        if let directions = recipe?.directions {
            for direction in directions {
                let newRow = newDirectionRow(value: direction)
                directionsListRow.insertRow(newRow)
            }
        }


        form = nameSection +++ detailsSection +++ ingredientsSection +++ directionsSection
        
    }

    // Make form customizations from subclass after form is loaded
    func customConfigureForm() { }

    func newDirectionRow(value: String) -> DirectionRow {
        return DirectionRow(){ row in
            row.value = value
        }.onChange() { row in
            guard let rowPosition = row.indexPath?.row else { return }
            guard let newValue = row.value else {
                self.recipe?.directions.remove(at: rowPosition)
                return
            }
            self.recipe?.directions[rowPosition] = newValue
        }
    }

    func newIngredientRow(value: Ingredient) -> IngredientRow {
        return IngredientRow(){ row in
            row.value = value
        }.onChange() { row in
            guard let rowPosition = row.indexPath?.row else { return }
            guard let newValue = row.value else {
                self.recipe?.ingredients[rowPosition]._destroy = true
                return
            }
            self.recipe?.ingredients[rowPosition] = newValue
        }
    }

    func formIsValid() -> Bool {
        var formIsValid = true
        for row in form.allRows {
            guard row.isValid else {
                formIsValid = false
                break
            }
        }
        return formIsValid
    }

    func returnToPreviousView() {
        _ = self.navigationController?.popViewController(animated: true)
    }

}


extension UINavigationController {

    ///Get previous view controller of the navigation stack
    func previousViewController() -> UIViewController?{

        let length = self.viewControllers.count

        let previousViewController: UIViewController? = length >= 2 ? self.viewControllers[length-2] : nil

        return previousViewController
    }
    
}
