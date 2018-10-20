//
//  QuranMetadataParser.swift
//  QuranEnglish
//
//  Created by Aamir Jawaid on 2018-10-13.
//  Copyright © 2018 Aamir Jawaid. All rights reserved.
//

import Foundation

class SurahMetadataParser: DataParser<SurahMetadata> {
    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "sura" {
            let currentSurah = SurahMetadata(index: Int(attributeDict["index"]!)!,
                                             numberOfAyas: Int(attributeDict["ayas"]!)!,
                                             indexOfStartingAyah: Int(attributeDict["ayas"]!)!,
                                             arabicName: attributeDict["name"]!,
                                             arabicNameInEnglish: attributeDict["tname"]!,
                                             translatedName: attributeDict["ename"]!,
                                             type: SurahType(rawValue: attributeDict["type"]!)!,
                                             orderOfRevelation: Int(attributeDict["order"]!)!)
            
            allElements[parser]!.append(currentSurah)
        }
    }
}
