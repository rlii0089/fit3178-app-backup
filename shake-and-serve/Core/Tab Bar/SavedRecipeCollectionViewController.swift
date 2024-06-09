import UIKit
import FirebaseFirestore
import FirebaseAuth

class SavedRecipeCollectionViewController: UICollectionViewController {
        
    var savedMeals: [Meal] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSavedMeals()
    }
    
    func fetchSavedMeals() {
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
        return savedMeals.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedRecipeCell", for: indexPath) as! SavedRecipeCellCollectionViewCell
        let meal = savedMeals[indexPath.row]
        cell.configure(with: meal)
        return cell
    }
    
    // UICollectionViewDelegate Method
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMeal = savedMeals[indexPath.row]
        // Perform segue or present the detailed view controller
        // Pass the selected meal to the detailed view controller
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
