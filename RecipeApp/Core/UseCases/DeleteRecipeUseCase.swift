//
//  DeleteRecipeUseCase.swift
//  RecipeApp
//
//  Created by Hao Yang Yip on 21/05/2025.
//

import Foundation

protocol DeleteRecipeUseCase {
    func execute(id: UUID) async throws
}

class DeleteRecipeUseCaseImpl: DeleteRecipeUseCase {
    private let repository: RecipeRepository
    init(repository: RecipeRepository) {
        self.repository = repository
    }
    func execute(id: UUID) async throws {
        try await repository.deleteRecipe(id: id)
    }
}
