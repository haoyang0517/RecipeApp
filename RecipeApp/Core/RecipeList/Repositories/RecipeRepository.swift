//
//  RecipeRepository.swift
//  RecipeApp
//
//  Created by Hao Yang Yip on 21/05/2025.
//

import UIKit

protocol RecipeRepository {
    func fetchRecipes(type: String?) async throws -> [RecipeModel]
}

class RecipeRepositoryImpl: RecipeRepository {
    private let localDataSource: RecipeLocalDataSource
    init(localDataSource: RecipeLocalDataSource) {
        self.localDataSource = localDataSource
    }
    func fetchRecipes(type: String?) async throws -> [RecipeModel] {
        try await localDataSource.fetchRecipes(type: type)
    }
}
