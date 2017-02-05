//
//  Ingredient.swift
//  recipeManager-iOS
//
//  Created by KENNETH VACZI on 1/6/17.
//  Copyright © 2017 KENNETH VACZI. All rights reserved.
//

import Foundation
import MKUnits

struct Ingredient: Equatable {
    
    var id: UUID?
    var name: String
    var description: String
    var amount: Decimal
    var amountUnit: MKUnits.Unit
    var _destroy: Bool = false // set to true to delete from rails database as nested_attribute to recipe
    
    init(name: String? = nil, description: String? = nil, id: UUID? = nil, amount: Decimal, amountUnitName: String) {
        self.name = name ?? ""
        self.description = description ?? ""
        self.id = id
        self.amount = amount
        self.amountUnit = MKUnits.Unit.unitByName(amountUnitName)
    }

}

extension Ingredient {
    
    /* Returns an MKUnits.Quanity object for combining ingredients with different units */
    func quantity() -> MKUnits.Quantity {
        return MKUnits.Quantity(amount: amount as NSNumber, unit: amountUnit)
    }

    func displayQuantity() -> String {
        let pluralPostfix = amount > 1 ? "s" : ""
        return "\(amount) \(amountUnit.name)\(pluralPostfix)"
    }

    /* Ingredient must conform to Equatable protocol to be used as a type for Eureka forms */
    static func ==(lhs: Ingredient, rhs: Ingredient) -> Bool {
        return (lhs.description == rhs.description && lhs.amount == rhs.amount && lhs.amountUnit == rhs.amountUnit)
    }

}
