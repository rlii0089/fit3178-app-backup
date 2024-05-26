//
//  RecipeModel.swift
//  shake-and-serve
//
//  Created by Raymond Ruimin Li.
//

import Foundation

struct Recipe: Codable {
    let id: String
    let name: String
    let imageURL: String
    let instructions: String
}


class RecipeStorage {
    static let shared = RecipeStorage()
    private let savedRecipesKey = "savedRecipes"

    func saveRecipe(_ recipe: Recipe) {
        var recipes = getSavedRecipes()
        recipes.append(recipe)
        if let data = try? JSONEncoder().encode(recipes) {
            UserDefaults.standard.set(data, forKey: savedRecipesKey)
        }
    }

    func getSavedRecipes() -> [Recipe] {
        if let data = UserDefaults.standard.data(forKey: savedRecipesKey),
           let recipes = try? JSONDecoder().decode([Recipe].self, from: data) {
            return recipes
        }
        return []
    }
}
