//
//  GeneratedDrinkViewController.swift
//  shake-and-serve
//
//  Created by Raymond Ruimin Li on 16/5/2024.
//

import UIKit

class GeneratedDrinkViewController: UIViewController {
    
    var drink: [String: Any]?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let drink = drink {
            updateUI(with: drink)
        }
    }
    
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var drinkAlcoholicLabel: UILabel!
    @IBOutlet weak var drinkIngredientsLabel: UILabel!
    
    func updateUI(with drink: [String: Any]) {
        if let drinkName = drink["strDrink"] as? String {
            drinkNameLabel.text = drinkName
        }
        
        if let drinkAlcoholic = drink["strAlcoholic"] as? String {
            drinkAlcoholicLabel.text = drinkAlcoholic
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
