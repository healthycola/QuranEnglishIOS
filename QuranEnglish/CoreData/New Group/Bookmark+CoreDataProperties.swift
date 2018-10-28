//
//  Bookmark+CoreDataProperties.swift
//  
//
//  Created by Aamir Jawaid on 2018-10-24.
//
//

import Foundation
import CoreData


extension Bookmark {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bookmark> {
        return NSFetchRequest<Bookmark>(entityName: "Bookmark")
    }

    @NSManaged public var dateadded: NSDate?
    @NSManaged public var ayametadata: AyaMetadata?

}
