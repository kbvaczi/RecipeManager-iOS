	//
//  ShowRecipeViewController.swift
//  recipeManager-iOS
//
//  Created by KENNETH VACZI on 1/8/17.
//  Copyright © 2017 KENNETH VACZI. All rights reserved.
//

import UIKit

class ShowRecipeViewController: UITableViewController, ViewDataTransfer {

    var recipe: Recipe? {
        didSet {
            tableView.reloadData()
        }
    }

    var data: Any? {
        get { return self.recipe }
        set {
            guard let newValue = newValue as? Recipe else {return}
            self.recipe = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return RecipeSections.numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSection = RecipeSections(rawValue: section)!
        return currentSection.numberOfRows(forRecipe: recipe)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let currentSection = RecipeSections(rawValue: section)!
        return currentSection.headerForSection
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerHeight: CGFloat
        switch section {
        case 0:
            headerHeight = CGFloat.leastNonzeroMagnitude // hide the top header
        default:
            headerHeight = 21
        }
        return headerHeight
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSection = RecipeSections(rawValue: indexPath.section)!
        var cell: UITableViewCell
        switch currentSection {
        case .image:
            let imageCell = tableView.dequeueReusableCell(withIdentifier: "RecipeImageTableViewCell", for: indexPath) as! RecipeImageTableViewCell
            imageCell.recipeImageView.downloadedFrom(url: recipe?.imageURL)
            imageCell.recipeImageView.contentMode = .scaleAspectFill
            imageCell.recipeNameLabel.text = recipe?.name
            cell = imageCell
        case .details:
            let detailCell = tableView.dequeueReusableCell(withIdentifier: "RecipeDetailTableViewCell", for: indexPath)
            let dataForDetailCell = RecipeSections.dataForDetailCell(forRecipe: recipe, rowNumber: indexPath.row)
            detailCell.textLabel?.text = dataForDetailCell?.first?.key
            detailCell.detailTextLabel?.text = dataForDetailCell?.first?.value
            cell = detailCell
        case .ingredients:
            let ingredientCell = tableView.dequeueReusableCell(withIdentifier: "RecipeIngredientTableViewCell", for: indexPath)
            let ingredientForCell = recipe?.ingredients[indexPath.row]
            ingredientCell.textLabel?.text = ingredientForCell?.displayQuantity()
            ingredientCell.detailTextLabel?.text = ingredientForCell?.description
            cell = ingredientCell
        case .directions:
            let directionCell = tableView.dequeueReusableCell(withIdentifier: "RecipeDirectionTableViewCell", for: indexPath)
            let directionForCell = recipe?.directions[indexPath.row]
            directionCell.textLabel?.text = directionForCell
            cell = directionCell
        }
        return cell
    }

    enum RecipeSections: Int {
        case image, details, ingredients, directions
        static var numberOfSections = 4
        var headerForSection: String? {
            switch self {
            case RecipeSections.image: return nil
            case RecipeSections.details: return "Details"
            case RecipeSections.ingredients: return "Ingredients"
            case RecipeSections.directions: return "Directions"
            }
        }

        func numberOfRows(forRecipe: Recipe?) -> Int {
            switch self {
            case RecipeSections.image: return 1
            case RecipeSections.details: return 1
            case RecipeSections.ingredients: return (forRecipe?.ingredients.count ?? 0)
            case RecipeSections.directions: return (forRecipe?.directions.count ?? 0)
            }
        }
        static func dataForDetailCell(forRecipe: Recipe?, rowNumber: Int) -> [String:String]? {
            guard let recipe = forRecipe else { return nil }
            switch rowNumber {
            case 0: return ["Source": (recipe.sourceURL?.absoluteString ?? "")]
            default: return nil
            }
        }
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        sendDataToView(destinationVC: segue.destination, data: self.data)
    }


}
