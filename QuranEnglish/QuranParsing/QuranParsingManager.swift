//
//  QuranManager.swift
//  QuranEnglish
//
//  Created by Aamir Jawaid on 2018-10-13.
//  Copyright © 2018 Aamir Jawaid. All rights reserved.
//

class QuranParserManager {
    private let quranParser: QuranParser
    private let surahMetadataParser: SurahMetadataParser
    
    init() {
        quranParser = QuranParser()
        surahMetadataParser = SurahMetadataParser()
    }
    
    func parse(
        arabicTextXMLFilename: String,
        translation: Translation?,
        completion: @escaping ((_ quran: Quran?, _ error: Error?) -> Void)
        ) throws {
        var quranSurahs: [Surah] = []
        var translatedSurahs: [Surah]?
        var surahMetadatas: [SurahMetadata] = []
        var numberOfCompletions = 2;
        
        let onCompletion: (() throws -> Void) = { () in
            guard numberOfCompletions == 0 else {
                return
            }
            
            if let translation = translation {
                if let translatedSurahs = translatedSurahs {
                    
                    try self.validate(arabic: quranSurahs, translation: translatedSurahs)
                    
                    completion(Quran(surahs: quranSurahs, metadata: surahMetadatas, translation: (translation: translation, surahs: translatedSurahs)), nil)
                }
            } else {
                completion(Quran(surahs: quranSurahs, metadata: surahMetadatas, translation: nil), nil)
            }
        }
        
        try quranParser.parse(filename: arabicTextXMLFilename, completion: { (surahs) in
            quranSurahs = surahs;
            do {
                numberOfCompletions = numberOfCompletions - 1
                try onCompletion()
            } catch {
                completion(nil, error)
            }
        })
        
        if let translation = translation {
            numberOfCompletions = numberOfCompletions + 1
            try quranParser.parse(filename: translation.filename, completion: { (surahs) in
                translatedSurahs = surahs;
                do {
                    numberOfCompletions = numberOfCompletions - 1
                    try onCompletion()
                } catch {
                    completion(nil, error)
                }
            })
        }
        
        try surahMetadataParser.parse(filename: "quran-data", completion: { (_surahMetadatas) in
            surahMetadatas = _surahMetadatas
            do {
                numberOfCompletions = numberOfCompletions - 1
                try onCompletion()
            } catch {
                completion(nil, error)
            }
        })
    }
    
    private func validate(arabic: [Surah], translation: [Surah]) throws {
        if (arabic.count != translation.count) {
            throw QuranParsingError.arabicAndTranslationMismatch(error: "Different number of surahs between arabic and translation (\(arabic.count), \(translation.count)")
        }
        
        for (index, arabicSurah) in arabic.enumerated() {
            if arabicSurah.ayas.count != translation[index].ayas.count {
                throw QuranParsingError.arabicAndTranslationMismatch(error: "Different number of ayas between arabic and translation for surah \(translation[index].name) (\(arabicSurah.ayas.count),  \(translation[index].ayas.count)")
            }
        }
    }
}
