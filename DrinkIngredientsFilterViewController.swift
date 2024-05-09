//
//  DrinkIngredientsFilterViewController.swift
//  shake-and-serve
//
//  Created by Raymond Ruimin Li on 25/4/2024.
//

import UIKit

class DrinkIngredientsFilterViewController: UIViewController, DrinkFilterDelegate {
    
    var selectedCategoryFilters: [String] = []
    var selectedGlassFilters: [String] = []
    var selectedIngredientFilters: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        CategoryButton.setTitle("Category (\(selectedCategoryFilters.count))", for: .normal)
        GlassButton.setTitle("Glass (\(selectedCategoryFilters.count))", for: .normal)
        IngredientButton.setTitle("Ingredients (\(selectedCategoryFilters.count))", for: .normal)

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var CategoryButton: UIButton!
    @IBOutlet weak var GlassButton: UIButton!
    @IBOutlet weak var IngredientButton: UIButton!
    
    @IBAction func CategoryButtonTapped(_ sender: Any) {
        showFilterOptions(for: "Category")
    }
    
    @IBAction func GlassButtonTapped(_ sender: Any) {
        showFilterOptions(for: "Glass")
    }
    
    @IBAction func IngredientButtonTapped(_ sender: Any) {
        showFilterOptions(for: "Ingredient")
    }
    
    func showFilterOptions(for filterType: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let filterVC = storyboard.instantiateViewController(withIdentifier: "DrinkFilterTableViewController") as? DrinkFilterTableViewController else {
            return
        }
        
        filterVC.delegate = self
        
        filterVC.filterType = filterType
                
        navigationController?.pushViewController(filterVC, animated: true)
    }
    
    func didSelectFilters(filters: [String], filterType: String) {
        switch filterType {
        case "Category":
            selectedCategoryFilters = filters
            CategoryButton.setTitle("Category (\(filters.count))", for: .normal)
        case "Glass":
            selectedGlassFilters = filters
            GlassButton.setTitle("Glass (\(filters.count))", for: .normal)
        case "Ingredient":
            selectedIngredientFilters = filters
            IngredientButton.setTitle("Ingredient (\(filters.count))", for: .normal)
        default:
            break
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
