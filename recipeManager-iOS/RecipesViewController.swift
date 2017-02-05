	//
//  RecipesViewController.swift
//  recipeManager-iOS
//
//  Created by KENNETH VACZI on 1/7/17.
//  Copyright © 2017 KENNETH VACZI. All rights reserved.
//

import UIKit
import SwiftyJSON

class RecipesViewController: UITableViewController, UserAuthenticationRequired, ViewDataTransfer {

    var recipes: [Recipe]?

    var data: Any? {
        get {
            return self.recipes
        }
        set {
            guard let newValue = newValue as? [Recipe] else { return }
            self.recipes = newValue
        }
    }

    override func viewDidLoad() {

        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)
      	refreshRecipes()
    }

    override func didReceiveMemoryWarning() {

        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return recipes?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
                            as? RecipeTableViewCell else { return UITableViewCell() }
        cell.recipe = recipes?[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: "ShowRecipeSegue", sender: self.tableView.cellForRow(at: indexPath))
    }

    func refreshRecipes() {

        Connections.RMConnection.requestGetRecipes() { (isSuccessful, refreshedRecipes) in
            guard isSuccessful == true else { return }
            self.recipes = refreshedRecipes
            self.tableView.reloadData()
        }
    }

    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowRecipeSegue" {
            sendDataToView(destinationVC: segue.destination, sender: sender)
        }
    }

}
