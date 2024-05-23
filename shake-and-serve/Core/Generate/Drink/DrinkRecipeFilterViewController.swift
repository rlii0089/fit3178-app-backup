//
//  DrinkRecipeFilterViewController.swift
//  shake-and-serve
//
//  Created by Raymond Ruimin Li on 16/5/2024.
//

import UIKit

class DrinkRecipeFilterViewController: UIViewController {
    
    var selectedCategory: String?
    var selectedGlass: String?
    var selectedIngredients: [String] = []
    var selectedAlcoholic: String?
    
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var glassButton: UIButton!
    @IBOutlet weak var ingredientButton: UIButton!
    @IBOutlet weak var alcoholicButton: UIButton!
    @IBOutlet weak var generateDrinkButton: UIButton!
    
    @IBAction func generateDrinkButtonPressed(_ sender: Any) {
        // Combine filters and fetch drink recipe
        fetchFilteredDrinks()
    }
    
    func fetchFilteredDrinks() {
        var filters: [(String, String)] = []
        
        if let category = selectedCategory {
            filters.append(("c", category))
        }
        if let glass = selectedGlass {
            filters.append(("g", glass))
        }
        if !selectedIngredients.isEmpty {
            for ingredient in selectedIngredients {
                filters.append(("i", ingredient))
            }
        }
        if let alcoholic = selectedAlcoholic {
            filters.append(("a", alcoholic))
        }

        if filters.isEmpty {
            fetchRandomDrink()
        } else {
            fetchDrinksRecursively(filters: filters, index: 0, results: []) { [weak self] drinks in
                guard let drinks = drinks, !drinks.isEmpty else {
                    // Handle no results
                    print("No drinks found with filters")
                    return
                }
                let randomDrink = drinks.randomElement()
                self?.displayGeneratedDrink(drink: randomDrink)
            }
        }
    }

    func fetchRandomDrink() {
        let urlStr = "https://www.thecocktaildb.com/api/json/v1/1/random.php"
        guard let url = URL(string: urlStr) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let drinks = json["drinks"] as? [[String: Any]] {
                    let randomDrink = drinks.randomElement()
                    self.displayGeneratedDrink(drink: randomDrink)
                }
            } catch {
                print("Error fetching random drink")
            }
        }.resume()
    }
    
    func fetchDrinksRecursively(filters: [(String, String)], index: Int, results: [[String: Any]], completion: @escaping ([[String: Any]]?) -> Void) {
        if index >= filters.count {
            completion(results)
            return
        }
        
        let filter = filters[index]
        let urlStr = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?\(filter.0)=\(filter.1)"
        guard let url = URL(string: urlStr) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let drinks = json["drinks"] as? [[String: Any]] {
                    var combinedResults = results
                    if !results.isEmpty {
                        combinedResults = results.filter { drink in
                            drinks.contains { $0["idDrink"] as? String == drink["idDrink"] as? String }
                        }
                    } else {
                        combinedResults = drinks
                    }
                    self.fetchDrinksRecursively(filters: filters, index: index + 1, results: combinedResults, completion: completion)
                } else {
                    completion(nil)
                }
            } catch {
                completion(nil)
            }
        }.resume()
    }
    
    func displayGeneratedDrink(drink: [String: Any]?) {
        guard let drink = drink else { return }
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let generatedDrinkVC = storyboard.instantiateViewController(withIdentifier: "GeneratedDrinkViewController") as? GeneratedDrinkViewController {
                generatedDrinkVC.drink = drink
                self.navigationController?.pushViewController(generatedDrinkVC, animated: true)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? RecipeFilterTableViewController {
            if segue.identifier == "CategorySegue" {
                destinationVC.filterType = .category
                destinationVC.isMultiSelect = false
            } else if segue.identifier == "GlassSegue" {
                destinationVC.filterType = .glass
                destinationVC.isMultiSelect = false
            } else if segue.identifier == "IngredientSegue" {
                destinationVC.filterType = .ingredient
                destinationVC.isMultiSelect = true
            } else if segue.identifier == "AlcoholicSegue" {
                destinationVC.filterType = .alcoholic
                destinationVC.isMultiSelect = false
            }
        }
    }
    
    
    func updateButtonTitle(button: UIButton, title: String, selectedItems: [String]) {
        if selectedItems.isEmpty {
            button.setTitle(title, for: .normal)
        } else {
            button.setTitle(selectedItems.joined(separator: ", "), for: .normal)
        }
    }
    
    @IBAction func unwindToDrinkRecipeFilter(segue: UIStoryboardSegue) {
        if let sourceVC = segue.source as? RecipeFilterTableViewController {
            switch sourceVC.filterType {
            case .category:
                selectedCategory = sourceVC.selectedFilters.first
                updateButtonTitle(button: categoryButton, title: "Category", selectedItems: [selectedCategory].compactMap { $0 })
            case .glass:
                selectedGlass = sourceVC.selectedFilters.first
                updateButtonTitle(button: glassButton, title: "Glass", selectedItems: [selectedGlass].compactMap { $0 })
            case .ingredient:
                selectedIngredients = sourceVC.selectedFilters
                updateButtonTitle(button: ingredientButton, title: "Ingredients", selectedItems: selectedIngredients)
            case .alcoholic:
                selectedAlcoholic = sourceVC.selectedFilters.first
                updateButtonTitle(button: alcoholicButton, title: "Alcohol", selectedItems: [selectedAlcoholic].compactMap { $0 })
            default:
                break
            }
        }
    }
    
}
