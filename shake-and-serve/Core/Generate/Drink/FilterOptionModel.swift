//
//  FilterOptionModel.swift
//  shake-and-serve
//
//  Created by Raymond Ruimin Li on 16/5/2024.
//

import Foundation

struct FilterOption: Decodable {
    let strCategory: String?
    let strGlass: String?
    let strIngredient1: String?
    let strAlcoholic: String?
}

struct FilterOptionsResponse: Decodable {
    let drinks: [FilterOption]
}
