//
//  Copyright © 2017 Microsoft Corporation. All rights reserved.
//

import Foundation

class QuranParser: DataParser<Surah> {
    fileprivate var currentSurah: [XMLParser : Surah] = [:]
    
    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if currentSurah[parser] == nil {
            currentSurah[parser] = Surah()
        }
        
        if elementName == "sura" {
            currentSurah[parser]!.index = Int(attributeDict["index"]!)!
            currentSurah[parser]!.name = attributeDict["name"]!
        } else if elementName == "aya" {
            let aya = Aya()
            aya.index = Int(attributeDict["index"]!)!
            aya.text = attributeDict["text"]!
            
            currentSurah[parser]!.ayas.append(aya)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "sura" {
            allElements[parser]!.append(currentSurah[parser]!.copy())
            currentSurah[parser]?.clear()
        }
    }
    
    override func parserDidEndDocument(_ parser: XMLParser) {
        super.parserDidEndDocument(parser)
        currentSurah.removeValue(forKey: parser)
    }
}
