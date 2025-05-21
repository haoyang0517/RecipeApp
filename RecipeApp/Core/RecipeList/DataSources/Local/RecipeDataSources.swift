//
//  RecipeDataSources.swift
//  RecipeApp
//
//  Created by Hao Yang Yip on 21/05/2025.
//

import UIKit

protocol RecipeLocalDataSource {
    func fetchRecipes(type: String?) async throws -> [RecipeModel]
    func saveRecipe(recipe: Recipe) async throws
}

class RecipeLocalDataSourceImpl: RecipeLocalDataSource {
    private let coreDataStack: CoreDataStack
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    func fetchRecipes(type: String?) async throws -> [RecipeModel] {
        let context = coreDataStack.persistentContainer.viewContext
        let request = Recipe.fetchRequest()
        if let type = type {
            request.predicate = NSPredicate(format: "type == %@", type)
        }
        let entities = try await context.perform { try context.fetch(request) }
        return entities.map { $0.toModel() }
    }
    
    func saveRecipe(recipe: Recipe) async throws {
        let context = coreDataStack.persistentContainer.viewContext
        try await context.perform {
            let entity = Recipe(context: context)
            entity.id = recipe.id
            entity.title = recipe.title
            entity.type = recipe.type
            entity.ingredients = recipe.ingredients
            entity.steps = recipe.steps
            entity.imageData = recipe.imageData
            try context.save()
        }
//        let context = coreDataStack.persistentContainer.viewContext
//        try await context.perform {
//            let entity = RecipeModel(context: context)
//            entity.id = recipe.id
//            entity.title = recipe.title
//            entity.type = recipe.type
//            entity.ingredients = recipe.ingredients.joined(separator: ",")
//            entity.steps = recipe.steps.joined(separator: ",")
//            entity.imageData = recipe.imageData
//            try context.save()
    }

}

