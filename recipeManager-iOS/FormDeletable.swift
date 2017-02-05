//
//  FormDeletable.swift
//  recipeManager-iOS
//
//  Created by KENNETH VACZI on 2/5/17.
//  Copyright © 2017 KENNETH VACZI. All rights reserved.
//

import UIKit
import Eureka

protocol FormDeletable {

    func deleteObject()

}

extension FormDeletable where Self: FormViewController {

    func addDeleteButtonToForm() {
        form
            +++ Section()
            <<< ButtonRow() {
                $0.title = "Delete"
                $0.baseCell.tintColor = UIColor.red
                }.onCellSelection { [weak self] cell, row in
                    self?.promptForDelete()
        }
    }

    func promptForDelete() {
        let alert = UIAlertController(
            title: "Warning!",
            message: "Are you sure you want to permanently delete this?",
            preferredStyle: UIAlertControllerStyle.alert
        )
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: UIAlertActionStyle.cancel,
            handler: nil)
        )
        alert.addAction(UIAlertAction(
            title: "Delete",
            style: UIAlertActionStyle.destructive,
            handler: {(alert: UIAlertAction!) in self.deleteObject()} )
        )
        self.present(alert, animated: true, completion: nil)
    }

}
