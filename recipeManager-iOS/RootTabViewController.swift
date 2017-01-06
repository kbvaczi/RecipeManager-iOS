//
//  RootTabViewController.swift
//  recipeManager-iOS
//
//  Created by KENNETH VACZI on 1/6/17.
//  Copyright © 2017 KENNETH VACZI. All rights reserved.
//

import UIKit
import FontAwesome_swift

class RootTabBarController: UITabBarController {
    
    private enum TabTitles: String, CustomStringConvertible {
        case Recipes
        case Account
        
        var description: String {
            return self.rawValue
        }
    }
    
    private var tabIcons = [
        TabTitles.Recipes: FontAwesome.cutlery,
        TabTitles.Account: FontAwesome.user,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tabBarItems = tabBar.items {
            for item in tabBarItems {
                if let title = item.title,
                    let tab = TabTitles(rawValue: title),
                    let glyph = tabIcons[tab] {
                    item.image = UIImage.fontAwesomeIcon(glyph, textColor: UIColor.blue, size: CGSize(width: 30, height: 30))
                }
            }
        }
    }
    
}
