import UIKit
import Firebase
import FirebaseAuth

class GeneratedDrinkViewController: UIViewController {
    
    var selectedDrinkID: String?
    var drink: [String: Any]?
    
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var drinkCategoryLabel: UILabel!
    @IBOutlet weak var drinkGlassLabel: UILabel!
    @IBOutlet weak var drinkAlcoholicLabel: UILabel!
    @IBOutlet weak var drinkIngredientsTextView: UITextView!
    
    @IBOutlet weak var drinkSaveRecipeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedDrinkID = selectedDrinkID {
            fetchFullDrink(drinkID: selectedDrinkID)
        }
    }
    
    @IBAction func drinkAddToShoppingListButtonPressed(_ sender: Any) {
        var ingredients: [(String?, String?)] = []
        for i in 1...15 {
            let ingredientKey = "strIngredient\(i)"
            let measurementKey = "strMeasure\(i)"
            
            if let ingredient = drink?[ingredientKey] as? String,
               let measurement = drink?[measurementKey] as? String {
                ingredients.append((ingredient, measurement))
            }
        }
        
        addIngredientsToShoppingList(ingredients: ingredients)
    }
    
    func fetchFullDrink(drinkID: String) {
        let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=\(drinkID)")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                if let drinks = json["drinks"] as? [[String: Any]] {
                    if let drink = drinks.first {
                        DispatchQueue.main.async {
                            self.drink = drink
                            self.updateUI(with: drink)
                        }
                    }
                }
            } catch {
                self.displayMessage(title: "Generate Failed", message: "Generating a drink has failed. Please try again.")
                print("Error parsing JSON: \(error)")
            }
        }.resume()
    }

    func updateUI(with drink: [String: Any]) {
        if let drinkName = drink["strDrink"] as? String {
            drinkNameLabel.text = drinkName
        }
        
        if let drinkAlcoholic = drink["strAlcoholic"] as? String {
            drinkAlcoholicLabel.text = drinkAlcoholic
        }
        
        if let drinkGlass = drink["strGlass"] as? String {
            drinkGlassLabel.text = drinkGlass
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
        
        // ingredients
        var ingredientsString = "Ingredients:"

        for i in 1...15 {
            let ingredientKey = "strIngredient\(i)"
            if let ingredient = drink[ingredientKey] as? String, !ingredient.isEmpty {
                ingredientsString += "\n- \(ingredient)"
            }
        }
        drinkIngredientsTextView.text = ingredientsString
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
        guard let drink = drink,
              let drinkId = drink["idDrink"] as? String,
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
                    "savedDrinkRecipes": FieldValue.arrayUnion([drinkId])
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
                    "savedDrinkRecipes": [drinkId]
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
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
