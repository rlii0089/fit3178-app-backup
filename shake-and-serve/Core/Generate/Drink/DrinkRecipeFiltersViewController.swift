//
//  DrinkRecipeFiltersViewController.swift
//  shake-and-serve
//
//  Created by Raymond Ruimin Li on 16/5/2024.
//

import UIKit
import CoreMotion

class DrinkRecipeFiltersViewController: UIViewController {
    
    var selectedCategory: [String] = []
    var selectedGlass: [String] = []
    var selectedIngredients: [String] = []
    var selectedAlcoholic: [String] = []

    var filtersToQuery: [(String, String)] = []
    var listOfDrinkIDs: [String] = []
    
    let motionManager = CMMotionManager()
    var shakeThreshold = 2.0
    
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var glassButton: UIButton!
    @IBOutlet weak var ingredientButton: UIButton!
    @IBOutlet weak var alcoholicButton: UIButton!
    @IBOutlet weak var generateDrinkButton: UIButton!
    
    
    @IBAction func generateDrinkButtonPressed(_ sender: Any) {
        generateDrink()
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
                    self.generateDrink()
                }
            }
        }
    }

    func generateDrink() {
        filtersToQuery.removeAll()
        listOfDrinkIDs.removeAll()

        if !selectedCategory.isEmpty {
            for category in selectedCategory {
                filtersToQuery.append(("c", category))
            }
        }
        if !selectedGlass.isEmpty {
            for glass in selectedGlass {
                filtersToQuery.append(("g", glass))
            }
        }
        if !selectedIngredients.isEmpty {
            for ingredient in selectedIngredients {
                filtersToQuery.append(("i", ingredient))
            }
        }
        if !selectedAlcoholic.isEmpty {
            for alcoholic in selectedAlcoholic {
                filtersToQuery.append(("a", alcoholic))
            }
        }

        let dispatchGroup = DispatchGroup()

        switch filtersToQuery.count {
        case 0:
            dispatchGroup.enter()
            fetchDrinkIDByRandom {
                dispatchGroup.leave()
            }
        case 1:
            dispatchGroup.enter()
            fetchDrinkIDByFilter(filter: filtersToQuery[0]) {
                dispatchGroup.leave()
            }
        default:
            for filter in filtersToQuery {
                dispatchGroup.enter()
                fetchDrinkIDByFilter(filter: filter) {
                    dispatchGroup.leave()
                }

                dispatchGroup.notify(queue: .main) {
                    for drinkID in self.listOfDrinkIDs {
                        if self.listOfDrinkIDs.filter({ $0 == drinkID }).count == 1 {
                            self.listOfDrinkIDs.removeAll { $0 == drinkID }
                        }
                    }
                }
            }
        }

        dispatchGroup.notify(queue: .main) { // Wait until all network requests have completed
            let uniqueListOfDrinkIDs = Set(self.listOfDrinkIDs)
            let randomDrinkID = uniqueListOfDrinkIDs.randomElement()
            self.displayGeneratedDrink(drinkID: randomDrinkID ?? "")
            
        }

    }

    func fetchDrinkIDByRandom(completion: @escaping () -> Void) {
        let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/random.php")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion() // Call completion even if there's an error
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let drinks = json["drinks"] as? [[String: Any]] {
                        for drink in drinks {
                            if let id = drink["drinks"] as? String {
                                self.listOfDrinkIDs.append(id)
                            }
                        }
                    }
                }
            } catch {
                print(error)
            }

            completion() // Call completion when the task completes
        }.resume()
    }


    func fetchDrinkIDByFilter(filter: (String, String), completion: @escaping () -> Void) {
        let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/filter.php?\(filter.0)=\(filter.1)")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion() // Call completion even if there's an error
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let drinks = json["drinks"] as? [[String: Any]] {
                        for drink in drinks {
                            if let id = drink["idDrink"] as? String {
                                self.listOfDrinkIDs.append(id)
                            }
                        }
                    }
                }
            } catch {
                print(error)
            }

            completion() // Call completion when the task completes
        }.resume()
    }

    func updateButtonTitle(button: UIButton, title: String, selectedItems: [String]) {
        if selectedItems.isEmpty {
            button.setTitle(title, for: .normal)
        } else {
            button.setTitle(selectedItems.joined(separator: ", "), for: .normal)
        }
    }
    
    func displayGeneratedDrink(drinkID: String) {
        guard !drinkID.isEmpty else {
            print("No drink ID found")
            return
        }
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let generatedDrinkVC = storyboard.instantiateViewController(withIdentifier: "GeneratedDrinkViewController") as? GeneratedDrinkViewController {
                generatedDrinkVC.selectedDrinkID = drinkID
                self.navigationController?.pushViewController(generatedDrinkVC, animated: true)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? DrinkFilterListTableViewController {
            switch segue.identifier {
            case "CategorySegue":
                destinationVC.filterType = .category
                destinationVC.isMultiSelect = false
            case "GlassSegue":
                destinationVC.filterType = .glass
                destinationVC.isMultiSelect = false
            case "IngredientSegue":
                destinationVC.filterType = .ingredient
                destinationVC.isMultiSelect = true
            case "AlcoholicSegue":
                destinationVC.filterType = .alcoholic
                destinationVC.isMultiSelect = false
            default:
                break
            }
        }
    }
    
    @IBAction func unwindToDrinkRecipeFilter(segue: UIStoryboardSegue) {
        if let sourceVC = segue.source as? DrinkFilterListTableViewController {
            switch sourceVC.filterType {
            case .category:
                selectedCategory = sourceVC.selectedFilters
                updateButtonTitle(button: categoryButton, title: "Category", selectedItems: selectedCategory)
            case .glass:
                selectedGlass = sourceVC.selectedFilters
                updateButtonTitle(button: glassButton, title: "Glass", selectedItems: selectedGlass)
            case .ingredient:
                selectedIngredients = sourceVC.selectedFilters
                updateButtonTitle(button: ingredientButton, title: "Ingredients", selectedItems: selectedIngredients)
            case .alcoholic:
                selectedAlcoholic = sourceVC.selectedFilters
                updateButtonTitle(button: alcoholicButton, title: "Alcohol", selectedItems: selectedAlcoholic)
            default:
                break
            }
        }
    }
    
}
