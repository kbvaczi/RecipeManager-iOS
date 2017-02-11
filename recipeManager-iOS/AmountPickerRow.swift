//
//  AmountPickerRow.swift
//  recipeManager-iOS
//
//  Created by KENNETH VACZI on 2/11/17.
//  Copyright © 2017 KENNETH VACZI. All rights reserved.
//

import Foundation
import Eureka

class AmountPickerCell: PickerCell<Decimal> {

    let wholeNumberOptions = Array(0...20)
    let fractionOptions = Ingredient.quantityFractionOptions(withBlank: true)

    var amountPickerRow : AmountPickerRow? { return row as? AmountPickerRow }

    open override func update(){
        super.update()
        if  let selectedWhole = amountPickerRow?.wholeAmount,
            let wholeIndex = wholeNumberOptions.index(of: selectedWhole) {
            picker.selectRow(wholeIndex, inComponent: 0, animated: true)
        }
        if  let selectedFraction = amountPickerRow?.fractionAmount {
            let rationalString = Rational(selectedFraction).stringValue
            if let fractionIndex = fractionOptions.index(of: rationalString) {
                picker.selectRow(fractionIndex, inComponent: 1, animated: true)
            }
        }
    }

    override func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return wholeNumberOptions.count
        default: return fractionOptions.count
        }
    }

    override func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            if row > 0 {
                return String(wholeNumberOptions[row])
            } else {
                return ""
            }
        default: return fractionOptions[row]
        }

    }

    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0: amountPickerRow?.wholeAmount = wholeNumberOptions[row]
        default: amountPickerRow?.fractionAmount = Rational(fractionOptions[row]).decimalValue
        }
    }

}

final class AmountPickerRow: Row<AmountPickerCell>, RowType {

    var fractionAmount: Decimal {
        get {
            if  let value = self.value {
                let numer = Rational(value).mixedNumNumer
                let denom = Rational(value).denominator
                return Decimal(numer) / Decimal(denom)
            }
            return 0
        }
        set {
            self.value = Decimal(self.wholeAmount) + newValue
        }
    }

    var wholeAmount: Int {
        get {
            if let value = self.value {
                let wholeNumber = Rational(value).mixedNumWhole
                return wholeNumber
            }
            return 0
        }
        set {
            self.value = Decimal(newValue) + self.fractionAmount
        }
    }

}

class AmountPickerInlineCell: PickerInlineCell<Decimal> {

    override func update() {
        super.update()
        guard   let detailTextLabel = detailTextLabel,
                let rowValue = self.row?.value else { return }
        detailTextLabel.text = rowValue > 0 ? Rational(rowValue).stringValue : "0"
    }

}

class _AmountPickerInlineRow: Row<AmountPickerInlineCell>, NoValueDisplayTextConformance {

    public typealias InlineRow = AmountPickerRow

    open var noValueDisplayText: String?

    required public init(tag: String?) {
        super.init(tag: tag)
    }

}

final class AmountPickerInlineRow: _AmountPickerInlineRow, RowType, InlineRowType {

    required public init(tag: String?) {
        super.init(tag: tag)
        onExpandInlineRow { cell, row, _ in
            let color = cell.detailTextLabel?.textColor
            row.onCollapseInlineRow { cell, _, _ in
                cell.detailTextLabel?.textColor = color
            }
            cell.detailTextLabel?.textColor = cell.tintColor
        }
    }

    public override func customDidSelect() {
        super.customDidSelect()
        if !isDisabled {
            toggleInlineRow()
        }
    }

    public func setupInlineRow(_ inlineRow: InlineRow) {
        inlineRow.displayValueFor = self.displayValueFor
    }
    
}

