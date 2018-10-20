//
//  Translations.swift
//  QuranEnglish
//
//  Created by Aamir Jawaid on 2018-10-19.
//  Copyright © 2018 Aamir Jawaid. All rights reserved.
//

import Foundation

enum Translation {
    case Sahih
    
    var filename: String {
        get {
            switch self {
            case .Sahih:
                return "en.sahih"
            }
        }
    }
}
