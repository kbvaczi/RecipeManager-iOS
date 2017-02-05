//
//  ListRow.swift
//  recipeManager-iOS
//
//  Created by KENNETH VACZI on 1/16/17.
//  Copyright © 2017 KENNETH VACZI. All rights reserved.
//

import UIKit
import Eureka

final class ExpandableListRow: _ButtonRowOf<String>, RowType {

    var indexForInsert: Int {
        return self.section != nil ? self.section!.count - 1 : 0
    }

    required public init(tag: String?) {
        super.init(tag: tag)
    }

    override func customUpdateCell() {
        super.customUpdateCell()
        cell.textLabel?.text = tag
    }

    func insertRow(_ rowToAdd: BaseRow) {
        guard var section = self.section else {
            print ("no section created yet")
            return
        }
        rowToAdd.tag = nil // forcing tag to nil prevents possible duplicates and crashing
        section.insert(rowToAdd, at: indexForInsert)
    }

    func insertRowAndEdit(_ rowToAdd: BaseRow) {
        insertRow(rowToAdd)
        (rowToAdd as? Row<DirectionCell>)?.didSelect()
    }

}

class ExpandableListRowFormController<RowType: Equatable>: FormViewController, TypedRowControllerType, FormDeletable {

    public var row: RowOf<RowType>!
    public var completionCallback : ((UIViewController) -> ())?
    public var onDismissCallback: ((UIViewController) -> ())?

    public var data: RowType?

    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setBarButtons()
        data = row.value
        updateForm()
        addDeleteButtonToForm()
    }

    func cancel(sender: UIBarButtonItem) {
        dismissForm()
    }

    func ok(sender: UIBarButtonItem) {
        row.value = data
        row.updateCell()
        dismissForm()
    }

    func deleteObject() {
        guard   var section = row.section,
            let rowPosition = row.indexPath?.row else { return }
        row.value = nil
        section.remove(at: rowPosition)
        dismissForm()
    }

    func setBarButtons() {
        let cancelButton = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancel(sender:))
        )
        let okButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(ok(sender:))
        )
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = okButton
    }

    func updateForm() {
        // To be set in subclass
    }

    func dismissForm() {
        let _ = self.navigationController?.popViewController(animated: true)
    }

}
