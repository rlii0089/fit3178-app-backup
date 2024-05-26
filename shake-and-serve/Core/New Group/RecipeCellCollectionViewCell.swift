//
//  RecipeCellCollectionViewCell.swift
//  shake-and-serve
//
//  Created by Raymond Ruimin Li.
//

import UIKit

class RecipeCellCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    
    func configure(with recipe: Recipe) {
        recipeNameLabel.text = recipe.name
        if let url = URL(string: recipe.imageURL) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.recipeImageView.image = UIImage(data: data)
                    }
                }
            }
        }
    }

}
