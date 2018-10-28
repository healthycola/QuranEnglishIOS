//
//  AyaMetadata+CoreDataProperties.swift
//  
//
//  Created by Aamir Jawaid on 2018-10-24.
//
//

import Foundation
import CoreData


extension AyaMetadata {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AyaMetadata> {
        return NSFetchRequest<AyaMetadata>(entityName: "AyaMetadata")
    }

    @NSManaged public var ayaindex: Int16
    @NSManaged public var surahindex: Int16
    @NSManaged public var bookmark: Bookmark?

}
