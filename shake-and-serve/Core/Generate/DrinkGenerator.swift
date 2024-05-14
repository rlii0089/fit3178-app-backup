//
//  DrinkGenerator.swift
//  shake-and-serve
//
//  Created by Raymond Ruimin Li on 14/5/2024.
//

import Foundation

class DrinkGenerator {
    
    static let shared = DrinkGenerator()
    
    private init() {}
    
    func generateDrink(filters: [String], completion: @escaping (Drink?) -> Void) {
        // Make API calls for each filter item individually
        var drinks: [Drink] = []
        
        let dispatchGroup = DispatchGroup()
        
        for filter in filters {
            dispatchGroup.enter()
            fetchDrinks(for: filter) { result in
                switch result {
                case .success(let drink):
                    drinks.append(drink)
                case .failure(let error):
                    print("Error fetching drinks for \(filter): \(error)")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            // Combine the results to match the user-selected filters
            // Here, you can implement logic to filter drinks based on the user-selected filters
            
            // Randomly select a drink from the filtered list
            let randomIndex = Int.random(in: 0..<drinks.count)
            let selectedDrink = drinks[randomIndex]
            
            completion(selectedDrink)
        }
    }
    
    private func fetchDrinks(for filter: String, completion: @escaping (Result<Drink, Error>) -> Void) {
        let url = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=\(filter)"
        
        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "com.example", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let drinks = json["drinks"] as! [[String: Any]]
                
                let randomIndex = Int.random(in: 0..<drinks.count)
                let drinkJSON = drinks[randomIndex]
                
                let drink = self.parseDrink(from: drinkJSON)
                completion(.success(drink))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    private func parseIngredients(from drinkJSON: [String: Any]) -> [String]? {
        var ingredients: [String] = []
        for i in 1...15 {
            if let ingredient = drinkJSON["strIngredient\(i)"] as? String,
               !ingredient.isEmpty,
               let measure = drinkJSON["strMeasure\(i)"] as? String,
               !measure.isEmpty {
                ingredients.append("\(measure) \(ingredient)")
            } else {
                break
            }
        }
        return ingredients.isEmpty ? nil : ingredients
    }

    private func parseDrink(from drinkJSON: [String: Any]) -> Drink {
        let name = drinkJSON["strDrink"] as! String
        let category = drinkJSON["strCategory"] as! String
        let instructions = drinkJSON["strInstructions"] as! String
        let thumbnailURL = drinkJSON["strDrinkThumb"] as! String
        let ingredients = parseIngredients(from: drinkJSON)
        
        return Drink(name: name, category: category, instructions: instructions, thumbnailURL: thumbnailURL, ingredients: ingredients)
    }
    
}
