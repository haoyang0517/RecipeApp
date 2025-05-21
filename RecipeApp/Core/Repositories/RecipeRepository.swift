//
//  RecipeRepository.swift
//  RecipeApp
//
//  Created by Hao Yang Yip on 21/05/2025.
//

import UIKit

protocol RecipeRepository {
    func fetchRecipes(type: String?) async throws -> [RecipeModel]
    func saveRecipe(recipe: RecipeModel) async throws
    func deleteRecipe(id: UUID) async throws
}

class RecipeRepositoryImpl: RecipeRepository {
    private let localDataSource: RecipeLocalDataSource
    init(localDataSource: RecipeLocalDataSource) {
        self.localDataSource = localDataSource
    }
    func fetchRecipes(type: String?) async throws -> [RecipeModel] {
        try await localDataSource.fetchRecipes(type: type)
    }
    func saveRecipe(recipe: RecipeModel) async throws {
        try await localDataSource.saveRecipe(recipe: recipe)
    }
    func deleteRecipe(id: UUID) async throws {
        try await localDataSource.deleteRecipe(id: id)
    }
}
