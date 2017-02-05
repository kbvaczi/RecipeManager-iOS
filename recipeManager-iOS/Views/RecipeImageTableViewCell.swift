//
//  RecipeImageTableViewCell.swift
//  recipeManager-iOS
//
//  Created by KENNETH VACZI on 1/20/17.
//  Copyright © 2017 KENNETH VACZI. All rights reserved.
//

import UIKit

class RecipeImageTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension UIImageView {

    func downloadedFrom(url: URL?, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = url else { return }
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }

    func downloadedFrom(link: String?, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let link = link else { return }
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }

}
