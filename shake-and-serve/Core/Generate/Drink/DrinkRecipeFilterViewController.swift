//
//  DrinkRecipeFilterViewController.swift
//  shake-and-serve
//
//  Created by Raymond Ruimin Li on 16/5/2024.
//

import UIKit

class DrinkRecipeFilterViewController: UIViewController {
    
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var glassButton: UIButton!
    @IBOutlet weak var ingredientButton: UIButton!
    @IBOutlet weak var alcoholSwitch: UISwitch!
    @IBOutlet weak var generateDrinkButton: UIButton!
    
    var selectedCategory: String?
    var selectedGlass: String?
    var selectedIngredient: String?
    var containsAlcohol: Bool?
    var selectedAlcoholic: String = "Alcoholic"
    
    var selectedFilters: [String] = []
    var drinks: [Drink] = []
    var selectedDrink: Drink?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func categoryButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowFilterOptions", sender: "Category")
    }
    
    @IBAction func glassButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowFilterOptions", sender: "Glass")
    }
    
    @IBAction func ingredientButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowFilterOptions", sender: "Ingredient")
    }
    
    @IBAction func alcoholSwitchChanged(_ sender: UISwitch) {
        containsAlcohol = sender.isOn
        if containsAlcohol == false {
            selectedAlcoholic = "Non_Alcoholic"
        } else {
            selectedAlcoholic = "Alcoholic"
        }
    }
    
    @IBAction func generateDrinkButtonPressed(_ sender: Any) {
        generateDrink()
        
        guard let generatedDrinkVC = storyboard?.instantiateViewController(withIdentifier: "GeneratedDrinkViewController") as? GeneratedDrinkViewController else { return }
        
        // Select a random drink from the drinks array
        guard let selectedDrink = drinks.randomElement() else {
            // Handle case where no drinks match selected filters
            print("No drinks found for selected filters")
            return
        }
        
        generatedDrinkVC.selectedDrink = selectedDrink
        navigationController?.pushViewController(generatedDrinkVC, animated: true)
        
    }
    
    func generateDrink() {
        drinks.removeAll()
        
        fetchDrinks(filter: selectedCategory ?? "", letter: "c")
        fetchDrinks(filter: selectedGlass ?? "", letter: "g")
        fetchDrinks(filter: selectedIngredient ?? "", letter: "i")
        fetchDrinks(filter: selectedAlcoholic, letter: "a")
    }
    
    func fetchDrinks(filter: String, letter: Character) {
            let urlString = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?\(letter)=\(filter)"
            guard let url = URL(string: urlString) else { return }
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(DrinksResponse.self, from: data)
                    self.drinks.append(contentsOf: result.drinks)
                } catch {
                    print("Error decoding data: \(error.localizedDescription)")
                }
            }.resume()
        }
    
    func setSelectedFilterOption(option: String, for filterType: String?) {
            switch filterType {
            case "Category":
                selectedCategory = option
                categoryButton.setTitle(option, for: .normal)
            case "Glass":
                selectedGlass = option
                glassButton.setTitle(option, for: .normal)
            case "Ingredient":
                selectedIngredient = option
                ingredientButton.setTitle(option, for: .normal)
            default:
                break
            }
        }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFilterOptions", let filterType = sender as? String, let recipeFilterTableViewController = segue.destination as? RecipeFilterTableViewController {
            recipeFilterTableViewController.filterType = filterType
        }
    }

}
