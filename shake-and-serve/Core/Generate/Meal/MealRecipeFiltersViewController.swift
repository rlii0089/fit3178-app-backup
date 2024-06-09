import UIKit
import CoreMotion

class MealRecipeFiltersViewController: UIViewController {

    var selectedCategory: [String] = []
    var selectedArea: [String] = []
    var selectedIngredients: [String] = []

    var filtersToQuery: [(String, String)] = []
    var listOfMealIDs: [String] = []

    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var areaButton: UIButton!
    @IBOutlet weak var ingredientButton: UIButton!
    @IBOutlet weak var generateButton: UIButton!
    
    @IBAction func generateMealButtonPressed(_ sender: Any) {
        generateMeal()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        generateMeal()
    }
    
    func generateMeal() {
        filtersToQuery.removeAll()
        listOfMealIDs.removeAll()
        
        
        if !selectedCategory.isEmpty {
            for category in selectedCategory {
                filtersToQuery.append(("c", category))
            }
        }
        if !selectedArea.isEmpty {
            for area in selectedArea {
                filtersToQuery.append(("a", area))
            }
        }
        if !selectedIngredients.isEmpty {
            for ingredient in selectedIngredients {
                filtersToQuery.append(("i", ingredient))
            }
        }
        
        let dispatchGroup = DispatchGroup() // Create a dispatch group

        switch filtersToQuery.count {
        case 0:
            dispatchGroup.enter()
            fetchMealIDByRandom {
                dispatchGroup.leave()
            }
        case 1:
            dispatchGroup.enter()
            fetchMealIDByFilter(filter: filtersToQuery[0]) {
                dispatchGroup.leave()
            }
        default:
            for filter in filtersToQuery {
                dispatchGroup.enter()
                fetchMealIDByFilter(filter: filter) {
                    dispatchGroup.leave()
                }

                dispatchGroup.notify(queue: .main) { // Wait until all network requests have completed
                    for mealID in self.listOfMealIDs {
                        // if meal id appears only once, remove it from the list
                        if self.listOfMealIDs.filter({ $0 == mealID }).count == 1 {
                            self.listOfMealIDs.removeAll { $0 == mealID }
                        }
                    }
                }
            }
        }

        dispatchGroup.notify(queue: .main) { // Wait until all network requests have completed
            let uniqueListOfMealIDs = Set(self.listOfMealIDs)
            let randomMealID = uniqueListOfMealIDs.randomElement()
            self.displayGeneratedMeal(mealID: randomMealID ?? "")
        }
    }

    func fetchMealIDByRandom(completion: @escaping () -> Void) {
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/random.php")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion() // Call completion even if there's an error
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let meals = json["meals"] as? [[String: Any]] {
                        for meal in meals {
                            if let id = meal["idMeal"] as? String {
                                self.listOfMealIDs.append(id)
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

    func fetchMealIDByFilter(filter: (String, String), completion: @escaping () -> Void) {
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?\(filter.0)=\(filter.1)")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion() // Call completion even if there's an error
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let meals = json["meals"] as? [[String: Any]] {
                        for meal in meals {
                            if let id = meal["idMeal"] as? String {
                                self.listOfMealIDs.append(id)
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
            button.setTitle(title + ": " + selectedItems.joined(separator: ", "), for: .normal)
        }
    }

    func displayGeneratedMeal(mealID: String) {
        guard !mealID.isEmpty else {
            displayMessage(title: "Error", message: "No meals were found, please try again with different filters.")
            return
        }
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let generatedMealVC = storyboard.instantiateViewController(withIdentifier: "GeneratedMealViewController") as? GeneratedMealViewController {
                generatedMealVC.selectedMealID = mealID
                self.navigationController?.pushViewController(generatedMealVC, animated: true)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? MealFilterListTableViewController {
            switch segue.identifier {
            case "MealCategorySegue":
                destinationVC.filterType = .category
                destinationVC.isMultiSelect = false
            case "MealAreaSegue":
                destinationVC.filterType = .area
                destinationVC.isMultiSelect = false
            case "MealIngredientSegue":
                destinationVC.filterType = .ingredient
                destinationVC.isMultiSelect = true
            default:
                break
            }
        }
    }
    
    @IBAction func unwindToDrinkRecipeFilter(segue: UIStoryboardSegue) {
        if let sourceVC = segue.source as? MealFilterListTableViewController {
            switch sourceVC.filterType {
            case .category:
                selectedCategory = sourceVC.selectedFilters
                updateButtonTitle(button: categoryButton, title: "Category", selectedItems: selectedCategory)
            case .area:
                selectedArea = sourceVC.selectedFilters
                updateButtonTitle(button: areaButton, title: "Area", selectedItems: selectedArea)
            case .ingredient:
                selectedIngredients = sourceVC.selectedFilters
                updateButtonTitle(button: ingredientButton, title: "Ingredients", selectedItems: selectedIngredients)
            default:
                break
            }
        }
    }

    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
