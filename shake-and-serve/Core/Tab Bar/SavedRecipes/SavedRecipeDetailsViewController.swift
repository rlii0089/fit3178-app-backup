import UIKit

class SavedRecipeDetailsViewController: UIViewController {
    
    var meal: Meal?
    var drink: Drink?

    @IBOutlet weak var savedRecipeImageView: UIImageView!
    @IBOutlet weak var savedRecipeNameLabel: UILabel!
    @IBOutlet weak var savedRecipeIngredientsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        if let meal = meal {
            savedRecipeNameLabel.text = meal.strMeal
            
            if let url = URL(string: meal.strMealThumb ?? "") {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data {
                        DispatchQueue.main.async {
                            self.savedRecipeImageView.image = UIImage(data: data)
                        }
                    }
                }.resume()
            }
            savedRecipeIngredientsTextView.text = getIngredientsText(for: meal)
            
        } else if let drink = drink {
            savedRecipeNameLabel.text = drink.strDrink
            
            savedRecipeIngredientsTextView.text = drink.strInstructions
            if let url = URL(string: drink.strDrinkThumb ?? "") {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data {
                        DispatchQueue.main.async {
                            self.savedRecipeImageView.image = UIImage(data: data)
                        }
                    }
                }.resume()
            }
            savedRecipeIngredientsTextView.text = getIngredientsText(for: drink)
        }
    }
    
    
    func getIngredientsText(for meal: Meal) -> String {
        var ingredientsText = ""
        let ingredients = [
            meal.strIngredient1, meal.strIngredient2, meal.strIngredient3,
            meal.strIngredient4, meal.strIngredient5, meal.strIngredient6,
            meal.strIngredient7, meal.strIngredient8, meal.strIngredient9,
            meal.strIngredient10, meal.strIngredient11, meal.strIngredient12,
            meal.strIngredient13, meal.strIngredient14, meal.strIngredient15,
            meal.strIngredient16, meal.strIngredient17, meal.strIngredient18,
            meal.strIngredient19, meal.strIngredient20
        ]
        let measures = [
            meal.strMeasure1, meal.strMeasure2, meal.strMeasure3,
            meal.strMeasure4, meal.strMeasure5, meal.strMeasure6,
            meal.strMeasure7, meal.strMeasure8, meal.strMeasure9,
            meal.strMeasure10, meal.strMeasure11, meal.strMeasure12,
            meal.strMeasure13, meal.strMeasure14, meal.strMeasure15,
            meal.strMeasure16, meal.strMeasure17, meal.strMeasure18,
            meal.strMeasure19, meal.strMeasure20
        ]
        
        for (ingredient, measure) in zip(ingredients, measures) {
            if let ingredient = ingredient, let measure = measure, !ingredient.isEmpty, !measure.isEmpty {
                ingredientsText += "\(ingredient): \(measure)\n"
            } else if let ingredient = ingredient, !ingredient.isEmpty {
                ingredientsText += "\(ingredient)\n"
            }
        }
        return ingredientsText
    }

    func getIngredientsText(for drink: Drink) -> String {
        var ingredientsText = ""
        let ingredients = [
            drink.strIngredient1, drink.strIngredient2, drink.strIngredient3,
            drink.strIngredient4, drink.strIngredient5, drink.strIngredient6,
            drink.strIngredient7, drink.strIngredient8, drink.strIngredient9,
            drink.strIngredient10, drink.strIngredient11, drink.strIngredient12,
            drink.strIngredient13, drink.strIngredient14, drink.strIngredient15
        ]
        let measures = [
            drink.strMeasure1, drink.strMeasure2, drink.strMeasure3,
            drink.strMeasure4, drink.strMeasure5, drink.strMeasure6,
            drink.strMeasure7, drink.strMeasure8, drink.strMeasure9,
            drink.strMeasure10, drink.strMeasure11, drink.strMeasure12,
            drink.strMeasure13, drink.strMeasure14, drink.strMeasure15
        ]
        
        for (ingredient, measure) in zip(ingredients, measures) {
            if let ingredient = ingredient, let measure = measure, !ingredient.isEmpty, !measure.isEmpty {
                ingredientsText += "\(ingredient): \(measure)\n"
            } else if let ingredient = ingredient, !ingredient.isEmpty {
                ingredientsText += "\(ingredient)\n"
            }
        }
        return ingredientsText
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
