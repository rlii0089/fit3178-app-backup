//
//  DrinkModels.swift
//  shake-and-serve
//
//  Created by Raymond Ruimin Li on 16/5/2024.
//

import Foundation

struct Drink: Decodable {
    let id: String
    let name: String
    let ingredients: [String]
    let instructions: String
    let imageUrl: String?
    // Add any other properties you need
}

struct DrinksResponse: Decodable {
    let drinks: [Drink]
}
