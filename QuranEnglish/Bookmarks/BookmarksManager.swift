//
//  BookmarksManager.swift
//  QuranEnglish
//
//  Created by Aamir Jawaid on 2018-10-24.
//  Copyright © 2018 Aamir Jawaid. All rights reserved.
//

import Foundation
import CoreData

class BookmarksManager {
    static let shared = BookmarksManager()
    private var coreDataStack: CoreDataStack!
    private var managedContext: NSManagedObjectContext {
        return coreDataStack.managedContext
    }
    
    private init() { }
    
    public func initialize() {
        getBookmarks()
    }
    
    func setContext(_ stack: CoreDataStack) {
        coreDataStack = stack
    }
    
    public var bookmarks: [Bookmark] {
        return self.currentBookmarks
    }
    
    private var currentBookmarks: [Bookmark] = []
    
    func addBookmark(surahIndex: Int, ayaIndex: Int) -> Bookmark? {
        let aya = AyaMetadata(context: managedContext)
        aya.ayaindex = Int16(ayaIndex)
        aya.surahindex = Int16(surahIndex)
        
        let bookmark = Bookmark(context: managedContext)
        bookmark.dateadded = NSDate()

        aya.bookmark = bookmark
        bookmark.ayametadata = aya
        
        if coreDataStack.saveContext() {
            currentBookmarks.append(bookmark)
            return bookmark
        } else {
            return nil
        }
    }
    
    func removeBookmark(_ bookmark: Bookmark) -> Bookmark? {
        managedContext.delete(bookmark)
        if coreDataStack.saveContext() {
            currentBookmarks = currentBookmarks.filter { $0 != bookmark }
            return bookmark
        } else {
            return nil
        }
    }
    
    func getBookmarks() {
        guard let model =
            managedContext
                .persistentStoreCoordinator?.managedObjectModel,
            let fetchRequest = model
                .fetchRequestTemplate(forName: "AllBookmarks")
                as? NSFetchRequest<Bookmark> else {
                    print("Unable to get bookmarks")
                    return
        }
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            self.currentBookmarks = results
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
}
