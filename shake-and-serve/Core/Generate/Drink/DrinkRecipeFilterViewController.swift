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
    
    var selectedFilters: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func categoryButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func glassButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func ingredientButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func alcoholSwitchChanged(_ sender: UISwitch) {
    }
    
    @IBAction func generateDrinkButtonPressed(_ sender: Any) {
    }
    
}
