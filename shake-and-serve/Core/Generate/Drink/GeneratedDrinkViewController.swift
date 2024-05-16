//
//  GeneratedDrinkViewController.swift
//  shake-and-serve
//
//  Created by Raymond Ruimin Li on 16/5/2024.
//

import UIKit

class GeneratedDrinkViewController: UIViewController {
    
    var selectedFilters: DrinkFilterQuery?
    var drinkQueryManager = DrinkFilterQueryManager()
    var drinks: [Drink] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var drinkServingsLabel: UILabel!
    @IBOutlet weak var drinkContainsAlcoholLabel: UILabel!
    @IBOutlet weak var drinkIngredientsLabel: UILabel!
    
    func fetchDrinks() {
        guard let selectedFilters = selectedFilters else { return }
        drinkQueryManager.fetchDrinks(for: selectedFilters)
    }
    
    func displayRandomDrink() {
        guard let selectedDrink = drinks.randomElement() else {
            // Handle case where no drinks match selected filters
            return
        }
        drinkNameLabel.text = selectedDrink.name
        
        // Iterate through ingredients array and create a string separated by commas
        var ingredientsString = ""
        for ingredient in selectedDrink.ingredients {
            if !ingredientsString.isEmpty {
                ingredientsString += ", "
            }
            ingredientsString += ingredient
        }
        drinkIngredientsLabel.text = ingredientsString
        
        // Load image asynchronously
        if let imageUrlString = selectedDrink.imageUrl,
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

extension GeneratedDrinkViewController: DrinkFilterQueryDelegate {
    func didReceiveDrinks(_ drinks: [Drink]) {
        self.drinks = drinks
        DispatchQueue.main.async {
            self.displayRandomDrink()
        }
    }
    
    func didFailWithError(_ error: Error) {
        // Handle error
    }
}
