//
//  IngredientTableViewCellController.swift
//  recipeManager-iOS
//
//  Created by KENNETH VACZI on 1/14/17.
//  Copyright © 2017 KENNETH VACZI. All rights reserved.
//

import UIKit
import Eureka

final class IngredientCell: Cell<Ingredient>, CellType {

    @IBOutlet weak var label: UILabel!

    override func update() {
        super.update()
        guard let ingredient = row.value else { return }
        let labelText = "\(ingredient.displayQuantity(format: .long)) \(ingredient.description)"
        label?.text = labelText
    }
}

final class IngredientRow: Row<IngredientCell>, RowType, PresenterRowType {

    /// Defines how the view controller will be presented, pushed, etc.
    open var presentationMode: PresentationMode<IngredientFormViewController>?

    /// Will be called before the presentation occurs.
    open var onPresentCallback : ((FormViewController, IngredientFormViewController)->())?

    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<IngredientCell>(nibName: "IngredientCell")
        presentationMode = .show(controllerProvider: ControllerProvider.callback { _ in
            return IngredientFormViewController()
            }, onDismiss: { vc in
                let _ = vc.navigationController?.popViewController(animated: true)
        })
    }

    /**
     Extends `didSelect` method
     */
    open override func customDidSelect() {
        super.customDidSelect()
        guard let presentationMode = presentationMode, !isDisabled else { return }
        if let controller = presentationMode.makeController(){
            controller.row = self
            controller.title = self.title ?? controller.title
            onPresentCallback?(cell.formViewController()!, controller)
            presentationMode.present(controller, row: self, presentingController: self.cell.formViewController()!)
        } else {
            presentationMode.present(nil, row: self, presentingController: self.cell.formViewController()!)
        }
    }

    /**
     Prepares the pushed row setting its title and completion callback.
     */
    open override func prepare(for segue: UIStoryboardSegue) {
        super.prepare(for: segue)
        guard let rowVC = segue.destination as? IngredientFormViewController else { return }
        rowVC.title = self.title ?? rowVC.title
        rowVC.row = self
    }

}
