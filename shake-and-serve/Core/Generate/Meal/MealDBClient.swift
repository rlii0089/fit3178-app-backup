//
//  MealDBClient.swift
//  shake-and-serve
//
//  Created by Raymond Ruimin Li.
//

import Foundation

class MealDBClient {
    static let shared = MealDBClient()
    private let baseURL = "https://www.themealdb.com/api/json/v1/1"
    private let session = URLSession.shared
    
    enum FilterType: String {
        case category = "list.php?c=list"
        case area = "list.php?a=list"
        case ingredient = "list.php?i=list"
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
                        if let categories = json["meals"] as? [[String: String]] {
                            let categoryNames = categories.compactMap { $0["strCategory"] }
                            completion(categoryNames.sorted())
                        }
                    case .area:
                        if let areas = json["meals"] as? [[String: String]] {
                            let areaNames = areas.compactMap { $0["strArea"] }
                            completion(areaNames.sorted())
                        }
                    case .ingredient:
                        if let ingredients = json["meals"] as? [[String: String]] {
                            let ingredientNames = ingredients.compactMap { $0["strIngredient"]}
                            completion(ingredientNames.sorted())
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
