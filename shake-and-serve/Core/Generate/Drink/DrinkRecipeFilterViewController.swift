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
    
    
    var selectedCategory: String?
    var selectedGlass: String?
    var selectedIngredient: String?
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
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFilterOptions",
           let filterType = sender as? String,
           let destinationVC = segue.destination as? RecipeFilterTableViewController {
            destinationVC.filterType = filterType
        }
    }

}
