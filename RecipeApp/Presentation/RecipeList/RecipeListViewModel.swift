//
//  RecipeListViewModel.swift
//  RecipeApp
//
//  Created by Hao Yang Yip on 21/05/2025.
//

import RxSwift
import RxCocoa

class RecipeListViewModel {
    let recipes = BehaviorRelay<[RecipeModel]>(value: [])
    let recipeTypes = BehaviorRelay<[String]>(value: [])
    let selectedType = BehaviorRelay<String?>(value: nil)
    let refreshSubject = PublishSubject<Void>()
    private let fetchRecipesUseCase: FetchRecipesUseCase
    private let recipeTypeDataSource: RecipeTypeFileDataSource
    private let disposeBag = DisposeBag()

    init(fetchRecipesUseCase: FetchRecipesUseCase, recipeTypeDataSource: RecipeTypeFileDataSource) {
        self.fetchRecipesUseCase = fetchRecipesUseCase
        self.recipeTypeDataSource = recipeTypeDataSource
        bind()
    }

    func fetchRecipes() {
        Task {
            do {
                let types = try recipeTypeDataSource.fetchRecipeTypes()
                recipeTypes.accept(types)
                let recipes = try await fetchRecipesUseCase.execute(type: selectedType.value)
                self.recipes.accept(recipes)
            } catch {
                print("Error: \(error)")
            }
        }
    }

    private func bind() {
        selectedType
            .subscribe(onNext: { [weak self] type in
                Task {
                    do {
                        let recipes = try await self?.fetchRecipesUseCase.execute(type: type)
                        self?.recipes.accept(recipes ?? [])
                    } catch {
                        print("Error: \(error)")
                    }
                }
            })
            .disposed(by: disposeBag)
        
        refreshSubject
            .subscribe(onNext: { [weak self] in
                self?.fetchRecipes()
            })
            .disposed(by: disposeBag)

    }
}
