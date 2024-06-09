import UIKit

class SavedRecipeCellCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var savedRecipeImageView: UIImageView!
    @IBOutlet weak var savedRecipeNameLabel: UILabel!

    func configure(with meal: Meal) {
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
    }
    
    
    func configure(with drink: Drink) {
        savedRecipeNameLabel.text = drink.strDrink
        if let url = URL(string: drink.strDrinkThumb ?? "") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        self.savedRecipeImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
    
}
