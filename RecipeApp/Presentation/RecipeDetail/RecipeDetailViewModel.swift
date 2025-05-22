//
//  RecipeDetailViewModel.swift
//  RecipeApp
//
//  Created by Hao Yang Yip on 21/05/2025.
//

import RxSwift
import RxCocoa
import UIKit

class RecipeDetailViewModel {
    let title = BehaviorRelay<String>(value: "")
    let type = BehaviorRelay<String>(value: "")
    let ingredients = BehaviorRelay<String>(value: "")
    let steps = BehaviorRelay<String>(value: "")
    let image = BehaviorRelay<UIImage?>(value: nil)
    let isEditing = BehaviorRelay<Bool>(value: false)
    let recipe: RecipeModel
    private let saveRecipeUseCase: SaveRecipeUseCase
    private let deleteRecipeUseCase: DeleteRecipeUseCase
    private let recipeListViewModel: RecipeListViewModel
    private let disposeBag = DisposeBag()

    init(recipe: RecipeModel, saveRecipeUseCase: SaveRecipeUseCase, deleteRecipeUseCase: DeleteRecipeUseCase, recipeListViewModel: RecipeListViewModel) {
        self.recipe = recipe
        self.saveRecipeUseCase = saveRecipeUseCase
        self.deleteRecipeUseCase = deleteRecipeUseCase
        self.recipeListViewModel = recipeListViewModel
        title.accept(recipe.title)
        type.accept(recipe.type)
        ingredients.accept(recipe.ingredients)
        steps.accept(recipe.steps)
        if let data = recipe.imageData {
            image.accept(UIImage(data: data))
        }
    }

    func saveRecipe() async throws {
        guard !title.value.isEmpty else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Title are required"])
        }

        let updatedRecipe = RecipeModel(
            id: recipe.id,
            title: title.value,
            type: recipe.type,
            imageData: image.value?.jpegData(compressionQuality: 0.8),
            ingredients: ingredients.value,
            steps: steps.value
        )
        try await saveRecipeUseCase.execute(recipe: updatedRecipe)
        recipeListViewModel.refreshSubject.onNext(())
    }

    func deleteRecipe() async throws {
        try await deleteRecipeUseCase.execute(id: recipe.id)
        recipeListViewModel.refreshSubject.onNext(())
    }
}
