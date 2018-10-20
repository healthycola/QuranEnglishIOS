//
//  QuranMetadata.swift
//  QuranEnglish
//
//  Created by Aamir Jawaid on 2018-10-13.
//  Copyright © 2018 Aamir Jawaid. All rights reserved.
//

import Foundation;

enum SurahType: String {
    case Meccan, Medinan
}

class SurahMetadata: NSObject {
    var index: Int
    var numberOfAyas: Int
    var indexOfStartingAyah: Int
    var arabicName: String
    var arabicNameInEnglish: String
    var translatedName: String
    var type: SurahType
    var orderOfRevelation: Int
    
    init( index: Int,
     numberOfAyas: Int,
     indexOfStartingAyah: Int,
     arabicName: String,
     arabicNameInEnglish: String,
     translatedName: String,
     type: SurahType,
     orderOfRevelation: Int) {
        self.index = index
        self.numberOfAyas = numberOfAyas
        self.indexOfStartingAyah = indexOfStartingAyah
        self.arabicName = arabicName
        self.arabicNameInEnglish = arabicNameInEnglish
        self.translatedName = translatedName
        self.type = type
        self.orderOfRevelation = orderOfRevelation
    }
}
