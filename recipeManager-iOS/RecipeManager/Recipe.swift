//
//  Recipe.swift
//  recipeManager-iOS
//
//  Created by KENNETH VACZI on 1/6/17.
//  Copyright © 2017 KENNETH VACZI. All rights reserved.
//

import Foundation

struct Recipe {
    
    var name: String
    var id: UUID?
    var recipeParseID: UUID?
    var sourceURL: URL?
    var imageURL: URL?
    
    var ingredients: [Ingredient]
    var directions: [String]

    init(_ name: String? = nil, id: UUID? = nil, recipeParseID: UUID? = nil, sourceURLString: String? = nil, imageURLString: String? = nil, ingredients: [Ingredient]? = nil, directions: [String]? = nil) {
        self.name = (name ?? "")
        self.id = id
        self.recipeParseID = recipeParseID
        self.sourceURL = (sourceURLString != nil ? URL(string: sourceURLString!) : nil)
        self.imageURL = (imageURLString != nil ? URL(string: imageURLString!) : nil)
        self.ingredients = ingredients ?? [Ingredient]()
        self.directions = directions ?? [String]()
    }
  
}
