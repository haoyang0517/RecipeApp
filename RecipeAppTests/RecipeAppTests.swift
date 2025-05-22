//
//  RecipeAppTests.swift
//  RecipeAppTests
//
//  Created by Hao Yang Yip on 21/05/2025.
//

import XCTest
import RxSwift
import Swinject
import Testing
@testable import RecipeApp

// Mocks
class MockFetchRecipesUseCase: FetchRecipesUseCase {
    var recipes: [RecipeModel] = []
    
    func execute(type: String?) async throws -> [RecipeModel] {

        return type == nil ? recipes : recipes.filter { $0.type == type }
    }
}

class MockRecipeTypeFileDataSource: RecipeTypeFileDataSource {
    var types: [String] = ["Breakfast", "Dessert"]
    
    func fetchRecipeTypes() throws -> [String] {
        return types
    }
}

class RecipeAppLogicTests: XCTestCase {
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        disposeBag = nil
        super.tearDown()
    }
    
    // MARK: - RecipeListViewModel Tests
    func testRecipeListViewModelFetchRecipes() {
        let expectation = XCTestExpectation(description: "Fetch recipes")
        let mockUseCase = MockFetchRecipesUseCase()
        mockUseCase.recipes = [
            RecipeModel(id: UUID(), title: "Pancakes", type: "Breakfast", imageData: nil, ingredients: "", steps: ""),
            RecipeModel(id: UUID(), title: "Cake", type: "Dessert", imageData: nil, ingredients: "", steps: "")
        ]
        let viewModel = RecipeListViewModel(
            fetchRecipesUseCase: mockUseCase,
            recipeTypeDataSource: MockRecipeTypeFileDataSource()
        )
        viewModel.recipes.subscribe(onNext: { recipes in
            if recipes.count > 0 { // Ignore initial
                XCTAssertEqual(recipes.count, 2)
                XCTAssertEqual(recipes[0].title, "Pancakes")
                XCTAssertEqual(recipes[1].title, "Cake")
                expectation.fulfill()
            }
        }).disposed(by: disposeBag)

        viewModel.fetchRecipes()
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testRecipeListViewModelSearchFilter() {
        let expectation = XCTestExpectation(description: "Search filter")
        let mockUseCase = MockFetchRecipesUseCase()
        mockUseCase.recipes = [
            RecipeModel(id: UUID(), title: "Pancakes", type: "Breakfast", imageData: nil, ingredients: "", steps: ""),
            RecipeModel(id: UUID(), title: "Cake", type: "Dessert", imageData: nil, ingredients: "", steps: "")
        ]
        let viewModel = RecipeListViewModel(
            fetchRecipesUseCase: mockUseCase,
            recipeTypeDataSource: MockRecipeTypeFileDataSource()
        )
        
        viewModel.recipes.subscribe(onNext: { recipes in
            if recipes.count == 1 {
                XCTAssertEqual(recipes.first?.title, "Pancakes")
                expectation.fulfill()
            }
        }).disposed(by: disposeBag)
        
        viewModel.fetchRecipes()
        viewModel.searchText.accept("Pancake")
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testRecipeListViewModelTypeFilter() {
        let expectation = XCTestExpectation(description: "Type filter")
        let mockUseCase = MockFetchRecipesUseCase()
        mockUseCase.recipes = [
            RecipeModel(id: UUID(), title: "Pancakes", type: "Breakfast", imageData: nil, ingredients: "", steps: ""),
            RecipeModel(id: UUID(), title: "Cake", type: "Dessert", imageData: nil, ingredients: "", steps: "")
        ]
        let viewModel = RecipeListViewModel(
            fetchRecipesUseCase: mockUseCase,
            recipeTypeDataSource: MockRecipeTypeFileDataSource()
        )
        
        viewModel.recipes.subscribe(onNext: { recipes in
            if recipes.count == 1 {
                XCTAssertEqual(recipes.first?.type, "Breakfast")
                expectation.fulfill()
            }
        }).disposed(by: disposeBag)
        
        viewModel.fetchRecipes()
        viewModel.selectedType.accept("Breakfast")
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testRecipeListViewModelRefresh() {
        let expectation = XCTestExpectation(description: "Refresh")
        let mockUseCase = MockFetchRecipesUseCase()
        mockUseCase.recipes = [
            RecipeModel(id: UUID(), title: "Pancakes", type: "Breakfast", imageData: nil, ingredients: "", steps: "")
        ]
        let viewModel = RecipeListViewModel(
            fetchRecipesUseCase: mockUseCase,
            recipeTypeDataSource: MockRecipeTypeFileDataSource()
        )
        
        var emissionCount = 0
        viewModel.recipes.subscribe(onNext: { recipes in
            emissionCount += 1
            if emissionCount == 2 { // After refresh
                XCTAssertEqual(recipes.count, 1)
                XCTAssertEqual(recipes.first?.title, "Pancakes")
                expectation.fulfill()
            }
        }).disposed(by: disposeBag)
        
        viewModel.fetchRecipes()
        viewModel.refreshSubject.onNext(())
        wait(for: [expectation], timeout: 1.0)
    }
    
    
}
