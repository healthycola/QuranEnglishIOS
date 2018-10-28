//
//  CoreDataStack.swift
//  QuranEnglish
//
//  Created by Aamir Jawaid on 2018-10-24.
//  Copyright © 2018 Aamir Jawaid. All rights reserved.
//

import Foundation
import CoreData
class CoreDataStack {
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    public lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores {
            (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext() -> Bool {
//        guard managedContext.hasChanges else {
//            print("Warn: No changes in context")
//            return true
//        }
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
            return false
        }
    }
}
