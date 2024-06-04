//
//  Drink.swift
//  shake-and-serve
//
//  Created by Raymond Ruimin Li on 3/6/2024.
//

import Foundation

// Drink struct to hold individual drink details
struct Drink: Codable {
    let idDrink: String
    let strDrink: String
    let strCategory: String?
    let strAlcoholic: String?
    let strGlass: String?
    let strInstructions: String?
    let strDrinkThumb: String?
    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strIngredient6: String?
    let strIngredient7: String?
    let strIngredient8: String?
    let strIngredient9: String?
    let strIngredient10: String?
    let strIngredient11: String?
    let strIngredient12: String?
    let strIngredient13: String?
    let strIngredient14: String?
    let strIngredient15: String?
}

// Wrapper struct for the drinks array
struct DrinkResponse: Codable {
    let drinks: [Drink]?
}
