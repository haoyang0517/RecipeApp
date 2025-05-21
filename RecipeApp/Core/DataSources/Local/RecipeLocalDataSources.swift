//
//  RecipeLocalDataSources.swift
//  RecipeApp
//
//  Created by Hao Yang Yip on 21/05/2025.
//

import UIKit

protocol RecipeLocalDataSource {
    func fetchRecipes(type: String?) async throws -> [RecipeModel]
    func saveRecipe(recipe: RecipeModel) async throws
    func deleteRecipe(id: UUID) async throws

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
    
    func saveRecipe(recipe: RecipeModel) async throws {
        let context = coreDataStack.persistentContainer.viewContext
        try await context.perform {

            let fetchRequest = Recipe.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", recipe.id as NSUUID)
            fetchRequest.fetchLimit = 1
            let existingEntities = try context.fetch(fetchRequest)
            
            let entity: Recipe
            if let existingEntity = existingEntities.first {
                // Edit existing recipe
                entity = existingEntity
            } else {
                // Create new recipe
                entity = Recipe(context: context)
                entity.id = recipe.id
            }
            
            // Update fields
            entity.title = recipe.title
            entity.type = recipe.type
            entity.ingredients = recipe.ingredients
            entity.steps = recipe.steps
            entity.imageData = recipe.imageData
            
            try context.save()
        }
    }

    func deleteRecipe(id: UUID) async throws {
        let context = coreDataStack.persistentContainer.viewContext
        let request = Recipe.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as NSUUID)
        try await context.perform {
            let entities = try context.fetch(request)
            for entity in entities {
                context.delete(entity)
            }
            try context.save()
        }
    }

}

