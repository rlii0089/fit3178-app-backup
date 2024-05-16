//
//  GeneratedDrinkViewController.swift
//  shake-and-serve
//
//  Created by Raymond Ruimin Li on 16/5/2024.
//

import UIKit

class GeneratedDrinkViewController: UIViewController {
    
    var drinks: [Drink] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var drinkServingsLabel: UILabel!
    @IBOutlet weak var drinkAlcoholic: UILabel!
    @IBOutlet weak var drinkIngredientsLabel: UILabel!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
