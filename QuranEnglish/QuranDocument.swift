//
//  QuranDocument.swift
//  QuranEnglish
//
//  Created by Aamir Jawaid on 2018-06-16.
//  Copyright © 2018 Aamir Jawaid. All rights reserved.
//

import Foundation

class QuranDocument {
    
    // MARK: - Properties
    
    private static var sharedQuranDocument: QuranDocument = {
        let document = QuranDocument()
        return document
    }()
    
    private init() {
        self.loading = false
    }
    
    var parsingManager = QuranParserManager()
    var quran: Quran?
    var loading: Bool
    
    func initialize(onCompletion: @escaping (_ error: Error?) -> Void) {
        self.loading = true
        do {
            try parsingManager.parse(arabicTextXMLFilename: "quran-simple-enhanced", translation: Translation.Sahih) { (quran, error) in
            self.quran = quran
            self.loading = false
            onCompletion(error)
            }
        } catch {
            self.loading = false
            onCompletion(error)
        }
    }
    
    // MARK: - Accessors
    
    class func shared() -> QuranDocument {
        return sharedQuranDocument
    }
}
