//
//  SaveRecipeUseCase.swift
//  RecipeApp
//
//  Created by Hao Yang Yip on 21/05/2025.
//

import Foundation

protocol SaveRecipeUseCase {
    func execute(recipe: RecipeModel) async throws
}

class SaveRecipeUseCaseImpl: SaveRecipeUseCase {
    private let repository: RecipeRepository
    init(repository: RecipeRepository) {
        self.repository = repository
    }
    func execute(recipe: RecipeModel) async throws {
        try await repository.saveRecipe(recipe: recipe)
    }
}
