//
//  GeneratedDrinkViewController.swift
//  shake-and-serve
//
//  Created by Raymond Ruimin Li.
//

import UIKit

class GeneratedDrinkViewController: UIViewController {
    
    var selectedDrinkID: String?
    var drink: [String: Any]?
    
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var drinkAlcoholicLabel: UILabel!
    @IBOutlet weak var drinkGlassLabel: UILabel!
    @IBOutlet weak var drinkIngredientsTextView: UITextView!
    
    @IBOutlet weak var drinkAddToShoppingListButton: UIButton!
    @IBOutlet weak var drinkSaveRecipeButton: UIButton!
    @IBOutlet weak var drinkServingsTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedDrinkID = selectedDrinkID {
            fetchFullDrink(drinkID: selectedDrinkID)
        }
    }
    
    func fetchFullDrink(drinkID: String) {
        let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=\(drinkID)")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                if let drinks = json["drinks"] as? [[String: Any]] {
                    if let drink = drinks.first {
                        DispatchQueue.main.async {
                            self.updateUI(with: drink)
                        }
                    }
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }.resume()
    }

    func updateUI(with drink: [String: Any]) {
        if let drinkName = drink["strDrink"] as? String {
            drinkNameLabel.text = drinkName
        }
        
        if let drinkAlcoholic = drink["strAlcoholic"] as? String {
            drinkAlcoholicLabel.text = drinkAlcoholic
        }
        
        if let drinkGlass = drink["strGlass"] as? String {
            drinkGlassLabel.text = drinkGlass
        }
        
        if let drinkImageURL = drink["strDrinkThumb"] as? String, let url = URL(string: drinkImageURL) {
            // Load image asynchronously
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    self.drinkImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
    
    @IBAction func saveRecipeButtonPressed(_ sender: Any) {
        guard let drink = drink else { return }
        let id = drink["idDrink"] as? String ?? ""
        let name = drink["strDrink"] as? String ?? ""
        let imageURL = drink["strDrinkThumb"] as? String ?? ""
        let instructions = drink["strInstructions"] as? String ?? ""

        let recipe = Recipe(id: id, name: name, imageURL: imageURL, instructions: instructions)
        RecipeStorage.shared.saveRecipe(recipe)
        
        let alert = UIAlertController(title: "Saved", message: "The drink recipe has been saved.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
