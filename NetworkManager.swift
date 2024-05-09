//
//  NetworkManager.swift
//  shake-and-serve
//
//  Created by Raymond Ruimin Li on 9/5/2024.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private let baseURL = "https://www.thecocktaildb.com/api/json/v1/1"
    
    func fetchCocktailsByIngredient(ingredient: String, completion: @escaping ([Cocktail]?, Error?) -> Void) {
        let urlString = "\(baseURL)/filter.php?i=\(ingredient)"
        
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "Invalid URL", code: -1, userInfo: nil))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                let cocktails = try JSONDecoder().decode(CocktailsResponse.self, from: data)
                completion(cocktails.drinks, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }

}