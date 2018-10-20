//
//  Aya.swift
//  QuranEnglish
//
//  Created by Aamir Jawaid on 2018-05-21.
//  Copyright © 2018 Aamir Jawaid. All rights reserved.
//

class Aya {
    var index: Int = -1
    var text: String = ""
    
    convenience init(index: Int, text: String) {
        self.init()
        
        self.index = index
        self.text = text
    }
}
