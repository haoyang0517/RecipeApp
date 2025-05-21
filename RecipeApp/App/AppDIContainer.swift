//
//  AppDIContainer.swift
//  RecipeApp
//
//  Created by Hao Yang Yip on 21/05/2025.
//

import Swinject

class AppDIContainer {
    static let shared = AppDIContainer()
    let container = Container()

    private init() {
        container.register(CoreDataStack.self) { _ in CoreDataStack() }
        container.register(RecipeTypeFileDataSource.self) { _ in RecipeTypeFileDataSourceImpl() }
        container.register(RecipeLocalDataSource.self) { r in
            RecipeLocalDataSourceImpl(coreDataStack: r.resolve(CoreDataStack.self)!)
        }
        container.register(RecipeRepository.self) { r in
            RecipeRepositoryImpl(localDataSource: r.resolve(RecipeLocalDataSource.self)!)
        }
        container.register(FetchRecipesUseCase.self) { r in
            FetchRecipesUseCaseImpl(repository: r.resolve(RecipeRepository.self)!)
        }
        container.register(RecipeListViewModel.self) { r in
            RecipeListViewModel(
                fetchRecipesUseCase: r.resolve(FetchRecipesUseCase.self)!,
                recipeTypeDataSource: r.resolve(RecipeTypeFileDataSource.self)!
            )
        }
        setupInitialData()
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        container.resolve(T.self)!
    }

    func setupInitialData() {
        let context = container.resolve(CoreDataStack.self)!.persistentContainer.viewContext
        let recipes = [
            RecipeModel(id: UUID(), title: "Pancakes", type: "Breakfast", imageData: nil, ingredients: "Flour, Eggs, Milk", steps: "1. Mix ingredients \n2. Cook on skillet"),
            RecipeModel(id: UUID(), title: "Chocolate Cake", type: "Dessert", imageData: nil, ingredients: "Flour, Cocoa, Sugar", steps: "1. Mix ingredients \n2. Bake at 350°F")
        ]
        for recipe in recipes {
            let entity = Recipe(context: context)
            entity.id = recipe.id
            entity.title = recipe.title
            entity.type = recipe.type
            entity.ingredients = recipe.ingredients
            entity.steps = recipe.steps
        }
        try? context.save()
    }
}
