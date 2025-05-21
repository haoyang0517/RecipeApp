//
//  RecipeFormViewModel.swift
//  RecipeApp
//
//  Created by Hao Yang Yip on 21/05/2025.
//

import RxSwift
import RxCocoa
import UIKit

class RecipeFormViewModel {
    let recipeTypes = BehaviorRelay<[String]>(value: [])
    let title = BehaviorRelay<String>(value: "")
    let selectedType = BehaviorRelay<String?>(value: nil)
    let ingredients = BehaviorRelay<String>(value: "")
    let steps = BehaviorRelay<String>(value: "")
    let image = BehaviorRelay<UIImage?>(value: nil)
    private let recipeTypeDataSource: RecipeTypeFileDataSource
    private let saveRecipeUseCase: SaveRecipeUseCase
    private let recipeListViewModel: RecipeListViewModel
    private let disposeBag = DisposeBag()

    init(recipeTypeDataSource: RecipeTypeFileDataSource, saveRecipeUseCase: SaveRecipeUseCase, recipeListViewModel: RecipeListViewModel) {
        self.recipeTypeDataSource = recipeTypeDataSource
        self.saveRecipeUseCase = saveRecipeUseCase
        self.recipeListViewModel = recipeListViewModel
        fetchRecipeTypes()
    }

    private func fetchRecipeTypes() {
        do {
            let types = try recipeTypeDataSource.fetchRecipeTypes()
            recipeTypes.accept(types)
            selectedType.accept(types.first)
        } catch {
            print("Error fetching recipe types: \(error)")
        }
    }

    func saveRecipe() async throws {
        guard let type = selectedType.value, !title.value.isEmpty else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Title and type are required"])
        }
        let recipe = RecipeModel(
            id: UUID(),
            title: title.value,
            type: type,
            imageData: image.value?.jpegData(compressionQuality: 0.8),
            ingredients: ingredients.value,
            steps: steps.value
        )
        try await saveRecipeUseCase.execute(recipe: recipe)
        recipeListViewModel.refreshSubject.onNext(())
    }
}
