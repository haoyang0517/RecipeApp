//
//  RecipeTypeFileDataSource.swift
//  RecipeApp
//
//  Created by Hao Yang Yip on 21/05/2025.
//

import UIKit

protocol RecipeTypeFileDataSource {
    func fetchRecipeTypes() throws -> [String]
}

class RecipeTypeFileDataSourceImpl: RecipeTypeFileDataSource {
    func fetchRecipeTypes() throws -> [String] {
        guard let url = Bundle.main.url(forResource: "recipetypes", withExtension: "json") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "recipetypes.json not found"])
        }
        let data = try Data(contentsOf: url)
        let json = try JSONDecoder().decode([String: [String]].self, from: data)
        return json["recipeTypes"] ?? []
    }
}
