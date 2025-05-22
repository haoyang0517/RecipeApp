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
    let searchText = BehaviorRelay<String>(value: "")
    let refreshSubject = PublishSubject<Void>()
    private let fetchRecipesUseCase: FetchRecipesUseCase
    private let recipeTypeDataSource: RecipeTypeFileDataSource
    private let disposeBag = DisposeBag()

    init(fetchRecipesUseCase: FetchRecipesUseCase, recipeTypeDataSource: RecipeTypeFileDataSource) {
        self.fetchRecipesUseCase = fetchRecipesUseCase
        self.recipeTypeDataSource = recipeTypeDataSource
        bindData()
        fetchRecipeTypes()
    }

    private func fetchRecipeTypes() {
        do {
            let types = try recipeTypeDataSource.fetchRecipeTypes()
            recipeTypes.accept(types)
        } catch {
            print("Error fetching recipe types: \(error)")
        }
    }

    func fetchRecipes() {
        Task {
            do {
                let fetchedRecipes = try await fetchRecipesUseCase.execute(type: selectedType.value)
                recipes.accept(fetchedRecipes)
            } catch {
                print("Error fetching recipes: \(error)")
            }
        }
    }

    private func bindData() {
        Observable.combineLatest(selectedType, searchText, refreshSubject.startWith(()))
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] type, searchText, _ in
                guard let self = self else { return }
                Task {
                    do {
                        let fetchedRecipes = try await self.fetchRecipesUseCase.execute(type: type)
                        let filteredRecipes = fetchedRecipes.filter { recipe in
                            searchText.isEmpty || recipe.title.lowercased().contains(searchText.lowercased())
                        }
                        self.recipes.accept(filteredRecipes)
                    } catch {
                        print("Error filtering recipes: \(error)")
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}
