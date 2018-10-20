//
//  Quran.swift
//  QuranEnglish
//
//  Created by Aamir Jawaid on 2018-05-21.
//  Copyright © 2018 Aamir Jawaid. All rights reserved.
//

class Quran {
    var surahs: [Surah]
    var translation: (translation: Translation, surahs: [Surah])?
    var metadata: [SurahMetadata]
    init(surahs: [Surah], metadata: [SurahMetadata], translation: (translation: Translation, surahs: [Surah])?) {
        self.surahs = surahs
        self.translation = translation
        self.metadata = metadata
    }
}
