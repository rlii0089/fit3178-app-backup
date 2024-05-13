//
//  Cocktail.swift
//  shake-and-serve
//
//  Created by Raymond Ruimin Li on 9/5/2024.
//

import Foundation

struct CocktailsResponse: Codable {
    let drinks: [Cocktail]
}

struct Cocktail: Codable {
    let idDrink: String
    let strDrink: String
    let strCategory: String
    let strGlass: String
    let strInstructions: String
    let strDrinkThumb: String
}
