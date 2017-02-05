//
//  RecipeTableViewCell.swift
//  recipeManager-iOS
//
//  Created by KENNETH VACZI on 1/20/17.
//  Copyright © 2017 KENNETH VACZI. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell, ViewDataTransfer {

    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!

    var recipe: Recipe? {
        didSet {
            configureCell()
        }
    }
    var data: Any? {
        get { return recipe }
        set {
            guard let newRecipe = newValue as? Recipe else { return }
            recipe = newRecipe
        }
    }

    func configureCell() {
        recipeNameLabel.text = recipe?.name
        recipeImage.downloadedFrom(url: recipe?.imageURL)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
