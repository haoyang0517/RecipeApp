//
//  CoreDataStack.swift
//  RecipeApp
//
//  Created by Hao Yang Yip on 21/05/2025.
//

import CoreData

class CoreDataStack {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RecipeApp")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()
}
