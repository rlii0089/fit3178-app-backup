import UIKit

class SavedRecipeCellCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var mealNameLabel: UILabel!

    func configure(with meal: Meal) {
        mealNameLabel.text = meal.strMeal
        if let url = URL(string: meal.strMealThumb ?? "") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        self.mealImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
    
}
