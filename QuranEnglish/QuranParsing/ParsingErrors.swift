//
//  ParsingErrors.swift
//  QuranEnglish
//
//  Created by Aamir Jawaid on 2018-10-13.
//  Copyright © 2018 Aamir Jawaid. All rights reserved.
//

import Foundation

enum QuranParsingError: Error {
    case fileNotFound(filename: String)
    case unableToReadContents(filename: String)
    case parsingError(filename: String)
    case arabicAndTranslationMismatch(error: String)
}
