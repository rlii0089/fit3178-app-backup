import UIKit
import FirebaseFirestore
import FirebaseAuth

class SavedRecipeCollectionViewController: UICollectionViewController {
        
    var savedMeals: [Meal] = []
    var savedDrinks: [Drink] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSavedRecipes()
    }
    
    func fetchSavedRecipes() {
        guard let currentUser = Auth.auth().currentUser else {
            print("User not authenticated")
            return
        }

        let db = Firestore.firestore()
        let userDocRef = db.collection("users").document(currentUser.uid)

        userDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let savedMealIds = document.data()?["savedMealRecipes"] as? [String] {
                    self.fetchMealsFromAPI(mealIds: savedMealIds)
                }
                if let savedDrinkIds = document.data()?["savedDrinkRecipes"] as? [String] {
                    self.fetchDrinksFromAPI(drinkIds: savedDrinkIds)
                }
            } else {
                print("Document does not exist")
            }
        }
    }

    func fetchMealsFromAPI(mealIds: [String]) {
        let group = DispatchGroup()
        
        for mealId in mealIds {
            group.enter()
            let urlString = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(mealId)"
            if let url = URL(string: urlString) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data {
                        do {
                            let mealResponse = try JSONDecoder().decode(MealResponse.self, from: data)
                            if let meal = mealResponse.meals?.first {
                                self.savedMeals.append(meal)
                            }
                        } catch {
                            print("Error decoding meal data: \(error)")
                        }
                    }
                    group.leave()
                }.resume()
            } else {
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.collectionView.reloadData()
        }
    }
    
    func fetchDrinksFromAPI(drinkIds: [String]) {
        let group = DispatchGroup()
        
        for drinkId in drinkIds {
            group.enter()
            let urlString = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=\(drinkId)"
            if let url = URL(string: urlString) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data {
                        do {
                            let drinkResponse = try JSONDecoder().decode(DrinkResponse.self, from: data)
                            if let drink = drinkResponse.drinks?.first {
                                self.savedDrinks.append(drink)
                            }
                        } catch {
                            print("Error decoding drink data: \(error)")
                        }
                    }
                    group.leave()
                }.resume()
            } else {
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.collectionView.reloadData()
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedMeals.count + savedDrinks.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedRecipeCell", for: indexPath) as! SavedRecipeCellCollectionViewCell
        if indexPath.row < savedMeals.count {
            let meal = savedMeals[indexPath.row]
            cell.configure(with: meal)
        } else {
            let drink = savedDrinks[indexPath.row - savedMeals.count]
            cell.configure(with: drink)
        }
        return cell
    }
    
    // UICollectionViewDelegate Method
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < savedMeals.count {
            let selectedMeal = savedMeals[indexPath.row]
            performSegue(withIdentifier: "showSavedRecipeDetails", sender: selectedMeal)
        } else {
            let selectedDrink = savedDrinks[indexPath.row - savedMeals.count]
            performSegue(withIdentifier: "showSavedRecipeDetails", sender: selectedDrink)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSavedRecipeDetails" {
            if let destinationVC = segue.destination as? SavedRecipeDetailsViewController {
                if let selectedMeal = sender as? Meal {
                    destinationVC.meal = selectedMeal
                } else if let selectedDrink = sender as? Drink {
                    destinationVC.drink = selectedDrink
                }
            }
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
