//
//  QuranRepo.swift
//  QuranEnglish
//
//  Created by Aamir Jawaid on 2018-05-21.
//  Copyright © 2018 Aamir Jawaid. All rights reserved.
//

import Foundation

enum Translation {
    case Sahih
    
    var filename: String {
        switch self {
        case .Sahih:
            return "en.sahih";
        }
    }
}

class Settings {
    var quranTranslation: Translation = Translation.Sahih
}

//class QuranRepo {
//    private let parser = QuranParser()
//    private var quran: Quran? = nil
//    
//    func retrieveQuran(settings: Settings, completion: @escaping (_ quran: Quran) -> Void) {
//        if let quran = quran {
//            completion(quran);
//            return;
//        }
//        
//        parser.parse(arabicTextXMLFilename: "quran-simple-enhanced", translation: settings.quranTranslation) { (quran) in
//            self.quran = quran
//            completion(quran)
//        }
//    }
//}

