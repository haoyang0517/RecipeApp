//
//  FetchRecipeUseCase.swift
//  RecipeApp
//
//  Created by Hao Yang Yip on 21/05/2025.
//

import UIKit

protocol FetchRecipesUseCase {
    func execute(type: String?) async throws -> [RecipeModel]
}

class FetchRecipesUseCaseImpl: FetchRecipesUseCase {
    private let repository: RecipeRepository
    init(repository: RecipeRepository) {
        self.repository = repository
    }
    func execute(type: String?) async throws -> [RecipeModel] {
        try await repository.fetchRecipes(type: type)
    }
}
