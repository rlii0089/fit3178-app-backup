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
    
    
    var selectedCategories: [String] = []
    var selectedGlasses: [String] = []
    var selectedIngredients: [String] = []
    var containsAlcohol: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    }
    
    @IBAction func generateDrinkButtonPressed(_ sender: Any) {
    }
    
    func setSelectedFilterOption(option: String, for filterType: String?) {
        guard let filterType = filterType else { return }
        switch filterType {
        case "Category":
            if let index = selectedCategories.firstIndex(of: option) {
                selectedCategories.remove(at: index)
            } else if selectedCategories.count < 3 {
                selectedCategories.append(option)
            }
        case "Glass":
            if let index = selectedGlasses.firstIndex(of: option) {
                selectedGlasses.remove(at: index)
            } else if selectedGlasses.count < 3 {
                selectedGlasses.append(option)
            }
        case "Ingredient":
            if let index = selectedIngredients.firstIndex(of: option) {
                selectedIngredients.remove(at: index)
            } else if selectedIngredients.count < 5 {
                selectedIngredients.append(option)
            }
        default:
            break
        }
        updateButtonTitles()
    }
    
    func updateFilterCount(for filterType: String?, count: Int) {
        guard let filterType = filterType else { return }
        switch filterType {
        case "Category":
            categoryButton.setTitle("Category (\(count))", for: .normal)
        case "Glass":
            glassButton.setTitle("Glass (\(count))", for: .normal)
        case "Ingredient":
            ingredientButton.setTitle("Ingredient (\(count))", for: .normal)
        default:
            break
        }
    }
    
    func updateButtonTitles() {
        categoryButton.setTitle("Category (\(selectedCategories.count))", for: .normal)
        glassButton.setTitle("Glass (\(selectedGlasses.count))", for: .normal)
        ingredientButton.setTitle("Ingredient (\(selectedIngredients.count))", for: .normal)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? RecipeFilterTableViewController,
           let filterType = sender as? String {
            destinationVC.filterType = filterType
            switch filterType {
            case "Category":
                destinationVC.selectedOptions = selectedCategories
            case "Glass":
                destinationVC.selectedOptions = selectedGlasses
            case "Ingredient":
                destinationVC.selectedOptions = selectedIngredients
            default:
                break
            }
        }
    }

}
