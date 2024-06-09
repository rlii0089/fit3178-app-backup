import UIKit
import Firebase
import FirebaseAuth

class GeneratedMealViewController: UIViewController {

    var selectedMealID: String?
    var meal: [String: Any]?
    
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var mealCategoryLabel: UILabel!
    @IBOutlet weak var mealAreaLabel: UILabel!
    @IBOutlet weak var mealIngredientsTextView: UITextView!
    
    @IBOutlet weak var mealSaveRecipeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedMealID = selectedMealID {
            fetchFullMeal(mealID: selectedMealID)
        }
    }
    
    @IBAction func mealAddToShoppingListButtonPressed(_ sender: Any) {
        var ingredients: [(String?, String?)] = []
        for i in 1...20 {
            let ingredientKey = "strIngredient\(i)"
            let measurementKey = "strMeasure\(i)"
            guard let ingredient = meal?[ingredientKey] as? String, !ingredient.isEmpty else {
                continue // Skip empty ingredients
            }
            
            let measurement = meal?[measurementKey] as? String ?? ""
            ingredients.append((ingredient, measurement))
            
            print("Ingredient: \(ingredient), Measurement: \(measurement)")
        }

        addIngredientsToShoppingList(ingredients: ingredients)
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
                            self.meal = meal
                            self.updateUI(with: meal)
                        }
                    }
                }
            } catch {
                self.displayMessage(title: "Generate Failed", message: "Generating a meal has failed. Please try again.")
                print("Error parsing JSON: \(error)")
            }
        }.resume()
    }

    func updateUI(with meal: [String: Any]) {
        if let mealName = meal["strMeal"] as? String {
            mealNameLabel.text = mealName
        }
        
        if let mealCategory = meal["strCategory"] as? String {
            mealCategoryLabel.text = "Category: " + mealCategory
        }
        
        if let mealArea = meal["strArea"] as? String {
            mealAreaLabel.text = "Area: " + mealArea
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
        
        // ingredients
        var ingredientsString = "Ingredients:"

        for i in 1...20 {
            let ingredientKey = "strIngredient\(i)"
            if let ingredient = meal[ingredientKey] as? String, !ingredient.isEmpty {
                ingredientsString += "\n- \(ingredient)"
            }
        }
        mealIngredientsTextView.text = ingredientsString
    }
    
    func addIngredientsToShoppingList(ingredients: [(String?, String?)]) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        for (ingredient, measurement) in ingredients {
            guard let ingredient = ingredient, let measurement = measurement else { continue }

            let newItem = ShoppingItem(context: context)
            newItem.name = ingredient
            newItem.measurement = measurement
        }

        do {
            try context.save()
            self.displayMessage(title: "Added", message: "The ingredients have successfully been added your shopping list.")
        } catch {
            self.displayMessage(title: "Failed", message: "Some ingredients have not been added, please try again.")
            print("Failed to save items: \(error)")
        }
    }

    
    @IBAction func saveRecipeButtonPressed(_ sender: Any) {
        guard let meal = meal,
              let mealId = meal["idMeal"] as? String,
              let currentUser = Auth.auth().currentUser else {
            self.displayMessage(title: "Failed", message: "You must be logged in to save recipes.")
            print("Failed to get meal id or user not authenticated")
            return
        }

        let db = Firestore.firestore()
        let userDocRef = db.collection("users").document(currentUser.uid)
        
        userDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                userDocRef.updateData([
                    "savedMealRecipes": FieldValue.arrayUnion([mealId])
                ]) { err in
                    if let err = err {
                        self.displayMessage(title: "Failed", message: "You must be logged in to save recipes.")
                        print("Error updating document: \(err)")
                    } else {
                        self.displayMessage(title: "Saved", message: "The meal has successfully been saved.")
                        print("Recipe saved.")
                    }
                }
            } else {
                userDocRef.setData([
                    "savedMealRecipes": [mealId]
                ]) { err in
                    if let err = err {
                        self.displayMessage(title: "Failed", message: "You must be logged in to save recipes.")
                        print("Error setting document: \(err)")
                    } else {
                        self.displayMessage(title: "Saved", message: "The meal has successfully been saved.")
                        print("Recipe saved!")
                    }
                }
            }
        }
    }
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
