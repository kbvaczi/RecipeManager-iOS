//
//  DirectionFormViewController.swift
//  recipeManager-iOS
//
//  Created by KENNETH VACZI on 2/4/17.
//  Copyright © 2017 KENNETH VACZI. All rights reserved.
//

import UIKit
import Eureka

class DirectionFormViewController: ExpandableListRowFormController<String> {

    override func updateForm() {
        let directionSection = Section("Direction")
            <<< TextAreaRow() {
                $0.value = data
                $0.placeholder = "I need some direction"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 20)
                $0.onChange() {
                    self.data = $0.value ?? ""
                }
        }

        form +++ directionSection
    }
    
}
