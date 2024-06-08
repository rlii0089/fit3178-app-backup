//
//  GeneratedMealViewController.swift
//  shake-and-serve
//
//  Created by Raymond Ruimin Li.
//

import UIKit

class GeneratedMealViewController: UIViewController {

    var selectedMealID: String?
    var meal: [String: Any]?
    
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var mealCategoryLabel: UILabel!
    @IBOutlet weak var mealAreaLabel: UILabel!
    @IBOutlet weak var mealIngredientsTextView: UITextView!
    
    @IBOutlet weak var mealSaveRecipeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedMealID = selectedMealID {
            fetchFullMeal(mealID: selectedMealID)
        }
    }
    @IBAction func mealAddToShhoppingListButtonPressed(_ sender: Any) {
        var ingredients: [(String?, String?)] = []
        for i in 1...20 {
            let ingredientKey = "strIngredient\(i)"
            let measurementKey = "strMeasure\(i)"
            if let ingredient = meal?[ingredientKey] as? String,
               let measurement = meal?[measurementKey] as? String {
                print("Ingredient: \(ingredient), Measurement: \(measurement)")
                ingredients.append((ingredient, measurement))
            }
        }

        addIngredientsToShoppingList(ingredients: ingredients)
    }
    
    func fetchFullMeal(mealID: String) {
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(mealID)")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                if let meals = json["meals"] as? [[String: Any]] {
                    if let meal = meals.first {
                        DispatchQueue.main.async {
                            self.meal = meal
                            self.updateUI(with: meal)
                        }
                    }
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }.resume()
    }

    func updateUI(with meal: [String: Any]) {
        if let mealName = meal["strMeal"] as? String {
            mealNameLabel.text = mealName
        }
        
        if let mealCategory = meal["strCategory"] as? String {
            mealCategoryLabel.text = mealCategory
        }
        
        if let mealArea = meal["strArea"] as? String {
            mealAreaLabel.text = mealArea
        }
        
        if let mealImageURL = meal["strMealThumb"] as? String, let url = URL(string: mealImageURL) {
            // Load image asynchronously
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    self.mealImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
    
    func addIngredientsToShoppingList(ingredients: [(String?, String?)]) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        for (ingredient, measurement) in ingredients {
            guard let ingredient = ingredient, let measurement = measurement else { continue }

            let newItem = ShoppingItem(context: context)
            newItem.name = ingredient
            newItem.measurement = measurement
        }

        do {
            try context.save()
            print("Ingredients saved successfully.")
        } catch {
            print("Failed to save items: \(error)")
        }
    }

    
    @IBAction func saveRecipeButtonPressed(_ sender: Any) {
        guard let meal = meal else { return }
        let id = meal["idMeal"] as? String ?? ""
        let name = meal["strMeal"] as? String ?? ""
        let imageURL = meal["strMealThumb"] as? String ?? ""
        let instructions = meal["strInstructions"] as? String ?? ""

        let recipe = Recipe(id: id, name: name, imageURL: imageURL, instructions: instructions)
        RecipeStorage.shared.saveRecipe(recipe)
        
        let alert = UIAlertController(title: "Saved", message: "The meal recipe has been saved.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
