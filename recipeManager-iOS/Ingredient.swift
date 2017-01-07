//
//  Ingredient.swift
//  recipeManager-iOS
//
//  Created by KENNETH VACZI on 1/6/17.
//  Copyright © 2017 KENNETH VACZI. All rights reserved.
//

import Foundation
import MKUnits

struct Ingredient {
    
    var id: UUID?
    var description: String
    var amount: Decimal
    var amountUnit: MKUnits.Unit
    
    init(_ description: String? = nil, id: UUID? = nil, amount: Decimal, amountUnitName: String) {
        self.description = (description ?? "")
        self.id = id
        self.amount = amount
        self.amountUnit = MKUnits.Unit.unitByName(amountUnitName)
    }
    
    /* Returns an MKUnits.Quanity object for combining ingredients with different units */
    func quantity() -> MKUnits.Quantity {
        return MKUnits.Quantity(amount: amount as NSNumber, unit: amountUnit)
    }

}
