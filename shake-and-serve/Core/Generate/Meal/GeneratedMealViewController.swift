//
//  GeneratedMealViewController.swift
//  shake-and-serve
//
//  Created by Raymond Ruimin Li.
//

import UIKit

class GeneratedMealViewController: UIViewController {

    var meal: [String: Any]?
    
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var mealCategoryLabel: UILabel!
    @IBOutlet weak var mealAreaLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let meal = meal {
            print(meal)
            fetchFullMeal(mealID: meal["idMeal"] as! String)
        }
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
    
}
