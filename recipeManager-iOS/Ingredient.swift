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

    enum formatOption {
        case long
        case short
    }

    // what fractions can we use in views for selecting amount?
    static func quantityFractionOptions(withBlank: Bool = false) -> [String] {
        var fractionOptions = [String]()
        if withBlank == true {
            fractionOptions.append("")
        }
        fractionOptions.append(contentsOf:
            ["1/16", "1/8", "1/6", "1/4", "1/3", "1/2", "2/3", "3/4"]
        )
        return fractionOptions
    }
}

extension Ingredient {

    /* Returns an MKUnits.Quanity object for combining ingredients with different units */
    func quantity() -> MKUnits.Quantity {
        return MKUnits.Quantity(amount: amount as NSNumber, unit: amountUnit)
    }

    func displayQuantity(format: formatOption = .short) -> String {
        let pluralPostfix = amount > 1 ? "s" : ""
        let amountString = Rational(amount).stringValue
        return "\(amountString) \(format == .short ? amountUnit.symbol : amountUnit.name)\(pluralPostfix)"
    }



    /* Ingredient must conform to Equatable protocol to be used as a type for Eureka forms */
    static func ==(lhs: Ingredient, rhs: Ingredient) -> Bool {
        return (lhs.description == rhs.description && lhs.amount == rhs.amount && lhs.amountUnit == rhs.amountUnit)
    }

}
