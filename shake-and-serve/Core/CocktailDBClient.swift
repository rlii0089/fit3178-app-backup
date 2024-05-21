//
//  CocktailDBClient.swift
//  shake-and-serve
//
//  Created by Raymond Ruimin Li on 19/5/2024.
//

import Foundation

class CocktailDBClient {
    static let shared = CocktailDBClient()
    private let baseURL = "https://www.thecocktaildb.com/api/json/v1/1"
    private let session = URLSession.shared
    
    enum FilterType: String {
        case category = "list.php?c=list"
        case glass = "list.php?g=list"
        case ingredient = "list.php?i=list"
        case alcoholic = "list.php?a=list"
    }
    
    func fetchFilters(type: FilterType, completion: @escaping ([String]?) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(type.rawValue)") else {
            completion(nil)
            return
        }
        
        session.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    switch type {
                    case .category:
                        if let categories = json["drinks"] as? [[String: String]] {
                            let categoryNames = categories.compactMap { $0["strCategory"] }
                            completion(categoryNames.sorted())
                        }
                    case .glass:
                        if let glasses = json["drinks"] as? [[String: String]] {
                            let glassNames = glasses.compactMap { $0["strGlass"] }
                            completion(glassNames.sorted())
                        }
                    case .ingredient:
                        if let ingredients = json["drinks"] as? [[String: String]] {
                            let ingredientNames = ingredients.compactMap { $0["strIngredient1"] }
                            completion(ingredientNames.sorted())
                        }
                    case .alcoholic:
                        if let alcoholics = json["drinks"] as? [[String: String]] {
                            let alcoholicNames = alcoholics.compactMap { $0["strAlcoholic"] }
                            completion(alcoholicNames.sorted())
                        }
                    }
                } else {
                    completion(nil)
                }
            } catch {
                completion(nil)
            }
        }.resume()
    }
}
