//
//  AppDIContainer.swift
//  RecipeApp
//
//  Created by Hao Yang Yip on 21/05/2025.
//

import Swinject
import CoreData

class AppDIContainer {
    static let shared = AppDIContainer()
    let container = Container()

    private init() {
        
        container.register(CoreDataStack.self) { _ in CoreDataStack() }
        container.register(RecipeTypeFileDataSource.self) { _ in RecipeTypeFileDataSourceImpl() }
        container.register(RecipeLocalDataSource.self) { r in
            RecipeLocalDataSourceImpl(coreDataStack: r.resolve(CoreDataStack.self)!)
        }
        
        // MARK: Repository
        container.register(RecipeRepository.self) { r in
            RecipeRepositoryImpl(localDataSource: r.resolve(RecipeLocalDataSource.self)!)
        }
        
        // MARK: Use Cases
        container.register(FetchRecipesUseCase.self) { r in
            FetchRecipesUseCaseImpl(repository: r.resolve(RecipeRepository.self)!)
        }
        container.register(SaveRecipeUseCase.self) { r in
            SaveRecipeUseCaseImpl(repository: r.resolve(RecipeRepository.self)!)
        }
        container.register(DeleteRecipeUseCase.self) { r in
            DeleteRecipeUseCaseImpl(repository: r.resolve(RecipeRepository.self)!)
        }
        
        // MARK: Recipe List
        container.register(RecipeListViewModel.self) { r in
            RecipeListViewModel(
                fetchRecipesUseCase: r.resolve(FetchRecipesUseCase.self)!,
                recipeTypeDataSource: r.resolve(RecipeTypeFileDataSource.self)!
            )
        }
        
        container.register(RecipeTypePickerViewController.self) { (r, viewModel: RecipeListViewModel) in
            RecipeTypePickerViewController(viewModel: viewModel)
        }

        // MARK: Recipe Details
        container.register(RecipeDetailViewModel.self) { (r, recipe: RecipeModel) in
            RecipeDetailViewModel(
                recipe: recipe,
                saveRecipeUseCase: r.resolve(SaveRecipeUseCase.self)!,
                deleteRecipeUseCase: r.resolve(DeleteRecipeUseCase.self)!,
                recipeListViewModel: r.resolve(RecipeListViewModel.self)!
            )
        }
        container.register(RecipeDetailViewController.self) { (r, recipe: RecipeModel) in
            let vc = RecipeDetailViewController()
            vc.viewModel = r.resolve(RecipeDetailViewModel.self, argument: recipe)
            return vc
        }
        
        // MARK: Recipe Form
        container.register(RecipeFormViewModel.self) { r in
            RecipeFormViewModel(
                recipeTypeDataSource: r.resolve(RecipeTypeFileDataSource.self)!,
                saveRecipeUseCase: r.resolve(SaveRecipeUseCase.self)!,
                recipeListViewModel: r.resolve(RecipeListViewModel.self)!
            )
        }
        container.register(RecipeFormViewController.self) { r in
            let vc = RecipeFormViewController()
            vc.viewModel = r.resolve(RecipeFormViewModel.self)
            return vc
        }


        setupInitialData()
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        container.resolve(T.self)!
    }

    func setupInitialData() {
        let context = container.resolve(CoreDataStack.self)!.persistentContainer.viewContext
        
        // Check if any recipes already exist
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        do {
            let existingRecipesCount = try context.count(for: fetchRequest)
            if existingRecipesCount > 0 {
                print("Recipes already exist, skip init")
                return // Skip
            }
            
            let initialRecipes = [
                RecipeModel(id: UUID(), title: "Blueberry Pancakes", type: "Breakfast", imageData: UIImage(named: "breakfast")?.jpegData(compressionQuality: 0.8), ingredients: "Flour, Eggs, Milk, Blueberries", steps: "1. Mix ingredients \n2. Cook on skillet"),
                RecipeModel(id: UUID(), title: "Chicken Salad", type: "Lunch", imageData: UIImage(named: "lunch")?.pngData(), ingredients: "Chicken, Lettuce, Tomato, Dressing", steps: "1. Grill chicken \n2. Toss with veggies and dressing"),
                RecipeModel(id: UUID(), title: "Beef Stir Fry", type: "Dinner", imageData: UIImage(named: "dinner")?.pngData(), ingredients: "Beef, Bell Peppers, Soy Sauce, Rice", steps: "1. Stir-fry beef and veggies \n2. Serve over rice"),
                RecipeModel(id: UUID(), title: "Chocolate Cake", type: "Dessert", imageData: UIImage(named: "dessert")?.pngData(), ingredients: "Flour, Cocoa, Sugar, Eggs", steps: "1. Mix ingredients \n2. Bake at 350°F"),
                RecipeModel(id: UUID(), title: "Trail Mix", type: "Snack", imageData: UIImage(named: "snack")?.pngData(), ingredients: "Nuts, Raisins, Chocolate Chips", steps: "1. Mix ingredients \n2. Store in a container"),
                RecipeModel(id: UUID(), title: "Vegetarian Chili", type: "Vegetarian", imageData: UIImage(named: "vege")?.pngData(), ingredients: "Beans, Tomatoes, Chili Powder, Onion", steps: "1. Sauté onion \n2. Simmer with beans and spices")
            ]
            
            for recipe in initialRecipes {
                let entity = Recipe(context: context)
                entity.id = recipe.id
                entity.title = recipe.title
                entity.type = recipe.type
                entity.ingredients = recipe.ingredients
                entity.steps = recipe.steps
                entity.imageData = recipe.imageData
            }
            
            if context.hasChanges {
                try context.save()
                print("Initial recipes successfully added to Core Data.")
            }
        } catch {
            print("Failed to fetch or save initial data: \(error)")
        }
    }}
