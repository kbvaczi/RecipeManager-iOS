//
//  IngredientFormViewController.swift
//  recipeManager-iOS
//
//  Created by KENNETH VACZI on 1/14/17.
//  Copyright © 2017 KENNETH VACZI. All rights reserved.
//

import UIKit
import Eureka
import MKUnits

class IngredientFormViewController: ExpandableListRowFormController<Ingredient> {

    override func updateForm() {
        let nameSection = Section("Description")
            <<< TextAreaRow("Ingredient Description") {
                $0.value = data?.description
                $0.placeholder = "Describe me"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 25)
                $0.onChange() {
                    self.data?.description = $0.value ?? ""
                }
        }

        let amountSection = Section("Amount")
            <<< AmountPickerInlineRow() {
                $0.title = "Amount"
                $0.value = self.data?.amount
                $0.onChange() {
                    self.data?.amount = $0.value ?? 0
                }
            }
            <<< PickerInlineRow<MKUnits.Unit>() {
                $0.title = "Unit"
                $0.value = data?.amountUnit
                $0.options = MKUnits.Unit.availableUnits()
                $0.onChange() {
                    self.data?.amountUnit = $0.value ?? MKUnits.Unit.defaultUnit
            }
        }

        form = nameSection +++ amountSection
    }
    
}
