//
//  Surah.swift
//  QuranEnglish
//
//  Created by Aamir Jawaid on 2018-05-21.
//  Copyright © 2018 Aamir Jawaid. All rights reserved.
//

class Surah {
    var index: Int = -1
    var name: String = ""
    var ayas: [Aya] = []
}

extension Surah {
    func clear() {
        index = -1
        name = ""
        ayas = []
    }
    
    func copy() -> Surah {
        let surah = Surah()
        surah.index = index
        surah.name = name
        ayas.forEach { (aya) in
            surah.ayas.append(Aya(index: aya.index, text: aya.text))
        }
        
        return surah
    }
}
