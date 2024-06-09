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
    @IBOutlet weak var drinkCategoryLabel: UILabel!
    @IBOutlet weak var drinkGlassLabel: UILabel!
    @IBOutlet weak var drinkAlcoholicLabel: UILabel!
    @IBOutlet weak var drinkIngredientsTextView: UITextView!
    
    @IBOutlet weak var drinkAddToShoppingListButton: UIButton!
    @IBOutlet weak var drinkSaveRecipeButton: UIButton!
    
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
                self.displayMessage(title: "Generate Failed", message: "Generating a drink has failed. Please try again.")
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
        
    }
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
