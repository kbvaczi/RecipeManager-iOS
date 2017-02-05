//
//  ViewDataTransfer.swift
//  recipeManager-iOS
//
//  Created by KENNETH VACZI on 1/21/17.
//  Copyright © 2017 KENNETH VACZI. All rights reserved.
//

import UIKit

protocol ViewDataTransfer {
    var data: Any? { get set }
}

extension ViewDataTransfer {

    func sendDataToView(destinationVC: UIViewController, sender: Any? = nil) {
        guard   var dataReciever = destinationVC as? ViewDataTransfer,
                let sender = sender as? ViewDataTransfer else { return }
        let dataToSend = sender.data
        dataReciever.data = dataToSend
    }

    func sendDataToView(destinationVC: UIViewController, data: Any? = nil) {
        guard   var dataReciever = destinationVC as? ViewDataTransfer else { return }
        let dataToSend = data
        dataReciever.data = dataToSend
    }
}
