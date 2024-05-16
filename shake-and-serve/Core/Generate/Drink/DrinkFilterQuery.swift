//
//  DrinkFilterQuery.swift
//  shake-and-serve
//
//  Created by Raymond Ruimin Li on 16/5/2024.
//

import Foundation

struct DrinkFilterQuery {
    var category: String?
    var glass: String?
    var ingredient: String?
    var alcoholic: String?
}

protocol DrinkFilterQueryDelegate: AnyObject {
    func didReceiveDrinks(_ drinks: [Drink])
    func didFailWithError(_ error: Error)
}

class DrinkFilterQueryManager {
    weak var delegate: DrinkFilterQueryDelegate?
    
    func fetchDrinks(for query: DrinkFilterQuery) {
        var urlString = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?"
        var filters: [String] = []
        if let category = query.category {
            filters.append("c=\(category)")
        }
        if let glass = query.glass {
            filters.append("g=\(glass)")
        }
        if let ingredient = query.ingredient {
            filters.append("i=\(ingredient)")
        }
        if let alcoholic = query.alcoholic {
            filters.append("a=\(alcoholic)")
        }
        
        urlString += filters.joined(separator: "&")
        
        guard let url = URL(string: urlString) else {
            delegate?.didFailWithError(NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                self.delegate?.didFailWithError(error)
                return
            }
            guard let data = data else {
                self.delegate?.didFailWithError(NSError(domain: "No data received", code: 1, userInfo: nil))
                return
            }
            do {
                let drinksResponse = try JSONDecoder().decode(DrinksResponse.self, from: data)
                let drinks = drinksResponse.drinks
                self.delegate?.didReceiveDrinks(drinks)
            } catch {
                self.delegate?.didFailWithError(error)
            }
        }.resume()
    }
}
