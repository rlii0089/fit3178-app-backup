//
//  GeneratedDrinkViewController.swift
//  shake-and-serve
//
//  Created by Raymond Ruimin Li on 16/5/2024.
//

import UIKit

class GeneratedDrinkViewController: UIViewController {
    
    var selectedDrink: Drink?

    override func viewDidLoad() {
        super.viewDidLoad()
        displaySelectedDrink()
    }
    
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var drinkServingsLabel: UILabel!
    @IBOutlet weak var drinkAlcoholic: UILabel!
    @IBOutlet weak var drinkIngredientsLabel: UILabel!
    
    func displaySelectedDrink() {
        guard let drink = selectedDrink else { return }
        
        drinkNameLabel.text = drink.name
        drinkAlcoholic.text = drink.alcoholic
        
        // Iterate through ingredients array and create a string separated by commas
        var ingredientsString = ""
        for ingredient in drink.ingredients {
            if !ingredient.isEmpty {
                if !ingredientsString.isEmpty {
                    ingredientsString += ", "
                }
                ingredientsString += ingredient
            }
        }
        drinkIngredientsLabel.text = ingredientsString
        
        // Load image asynchronously
        if let imageUrlString = drink.imageUrl,
           let imageUrl = URL(string: imageUrlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageUrl) {
                    DispatchQueue.main.async {
                        self.drinkImageView.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
