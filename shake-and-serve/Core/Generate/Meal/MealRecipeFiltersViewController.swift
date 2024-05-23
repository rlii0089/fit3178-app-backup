//
//  MealRecipeFiltersViewController.swift
//  shake-and-serve
//
//  Created by Raymond Ruimin Li on 16/5/2024.
//

import UIKit
import CoreMotion

class MealRecipeFiltersViewController: UIViewController {
    var selectedCategory: String?
    var selectedArea: String?
    var selectedIngredients: [String] = []
    
    let motionManager = CMMotionManager()
    var shakeThreshold = 2.0

    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var areaButton: UIButton!
    @IBOutlet weak var ingredientButton: UIButton!
    @IBOutlet weak var generateButton: UIButton!
    
    @IBAction func generateMealButtonPressed(_ sender: Any) {
        fetchFilteredMeals()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        motionManager.stopAccelerometerUpdates()
    }

    func setupShakeDetection() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.2
            motionManager.startAccelerometerUpdates(to: .main) { (data, error) in
                guard let data = data else { return }
                let acceleration = data.acceleration
                if (fabs(acceleration.x) > self.shakeThreshold || fabs(acceleration.y) > self.shakeThreshold || fabs(acceleration.z) > self.shakeThreshold) {
                    self.fetchFilteredMeals()
                }
            }
        }
    }
    
    func fetchFilteredMeals() {
        var filters: [(String, String)] = []
        
        if let category = selectedCategory {
            filters.append(("c", category))
        }
        if let area = selectedArea {
            filters.append(("a", area))
        }
        if !selectedIngredients.isEmpty {
            for ingredient in selectedIngredients {
                filters.append(("i", ingredient))
            }
        }
        
        fetchMealsRecursively(filters: filters, index: 0, results: []) { [weak self] meals in
            guard let meals = meals, !meals.isEmpty else {
                // Handle no results
                print("No meals found with filters")
                return
            }
            let randomMeal = meals.randomElement()
            self?.displayGeneratedMeal(meal: randomMeal)
        }
    }
    
    func fetchRandomMeal() {
        let urlStr = "https://www.themealdb.com/api/json/v1/1/random.php"
        guard let url = URL(string: urlStr) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let meals = json["meals"] as? [[String: Any]] {
                    let randomMeal = meals.randomElement()
                    self.displayGeneratedMeal(meal: randomMeal)
                }
            } catch {
                print("Error fetching random drink")
            }
        }.resume()
    }
    
    func fetchMealsRecursively(filters: [(String, String)], index: Int, results: [[String: Any]], completion: @escaping ([[String: Any]]?) -> Void) {
        if index >= filters.count {
            completion(results)
            return
        }
        
        let filter = filters[index]
        let urlStr = "https://www.themealdb.com/api/json/v1/1/filter.php?\(filter.0)=\(filter.1)"
        guard let url = URL(string: urlStr) else {
            completion(nil)
            return
        }
        
        fetchAllMeals(from: url, accumulatedResults: []) { meals in
            var combinedResults = results
            if !results.isEmpty {
                combinedResults = results.filter { meal in
                    meals.contains { $0["idMeal"] as? String == meal["idMeal"] as? String }
                }
            } else {
                combinedResults = meals
            }
            self.fetchMealsRecursively(filters: filters, index: index + 1, results: combinedResults, completion: completion)
        }
    }
    
    func fetchAllMeals(from url: URL, accumulatedResults: [[String: Any]], completion: @escaping ([[String: Any]]) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(accumulatedResults)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let meals = json["meals"] as? [[String: Any]] {
                    let newResults = accumulatedResults + meals
                    completion(newResults)
                } else {
                    completion(accumulatedResults)
                }
            } catch {
                completion(accumulatedResults)
            }
        }.resume()
    }
    
    func displayGeneratedMeal(meal: [String: Any]?) {
        guard let meal = meal else { return }
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let generatedDrinkVC = storyboard.instantiateViewController(withIdentifier: "GeneratedMealViewController") as? GeneratedMealViewController {
                generatedDrinkVC.meal = meal
                self.navigationController?.pushViewController(generatedDrinkVC, animated: true)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? MealFilterListTableViewController {
            if segue.identifier == "MealCategorySegue" {
                destinationVC.filterType = .category
                destinationVC.isMultiSelect = false
            } else if segue.identifier == "MealAreaSegue" {
                destinationVC.filterType = .area
                destinationVC.isMultiSelect = false
            } else if segue.identifier == "MealIngredientSegue" {
                destinationVC.filterType = .ingredient
                destinationVC.isMultiSelect = true
            }
        }
    }
    
    @IBAction func unwindToDrinkRecipeFilter(segue: UIStoryboardSegue) {
        if let sourceVC = segue.source as? MealFilterListTableViewController {
            switch sourceVC.filterType {
            case .category:
                selectedCategory = sourceVC.selectedFilters.first
                updateButtonTitle(button: categoryButton, title: "Category", selectedItems: [selectedCategory].compactMap { $0 })
            case .area:
                selectedArea = sourceVC.selectedFilters.first
                updateButtonTitle(button: areaButton, title: "Area", selectedItems: [selectedArea].compactMap { $0 })
            case .ingredient:
                selectedIngredients = sourceVC.selectedFilters
                updateButtonTitle(button: ingredientButton, title: "Ingredients", selectedItems: selectedIngredients)
            default:
                break
            }
        }
    }

}
