//
//  RecipeModel.swift
//  RecipeApp
//
//  Created by Hao Yang Yip on 21/05/2025.
//

import Foundation
import CoreData

struct RecipeModel: Identifiable {
    let id: UUID
    let title: String
    let type: String
    let imageData: Data?
    let ingredients: String
    let steps: String
}

extension Recipe {
    func toModel() -> RecipeModel {
        RecipeModel(
            id: id ?? UUID(),
            title: title ?? "",
            type: type ?? "",
            imageData: imageData,
            ingredients: ingredients ?? "",
            steps: steps ?? ""
        )
    }
}
