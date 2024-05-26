//
//  RecipeDetailViewController.swift
//  shake-and-serve
//
//  Created by Raymond Ruimin Li.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    
    var recipe: Recipe?

    
    @IBOutlet weak var recipeIngredientsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let recipe = recipe {
            navigationItem.title = recipe.name
            recipeIngredientsTextView.text = recipe.instructions
        }

        // Do any additional setup after loading the view.
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
