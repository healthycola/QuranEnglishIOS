//
//  Copyright © 2017 Microsoft Corporation. All rights reserved.
//

import Foundation

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
        surah.ayas = ayas
        
        return surah
    }
}

class Aya {
    var index: Int = -1
    var text: String = ""
    var translation: String = ""
}

enum QuranParsingStage {
    case arabic
    case english
}

class QuranParser: NSObject {
    var currentSurah = Surah()
    var allSurahs = [Surah]()
    var allTranslatedSurahs = [Surah]()
    var completion: ((_ arabic: [Surah], _ translated: [Surah]) -> Void)?
    var stage: QuranParsingStage = .arabic
    
    func parse(completion: ((_ arabic: [Surah], _ translated: [Surah]) -> Void)?) {
        self.completion = completion
        allSurahs.removeAll()
        allTranslatedSurahs.removeAll()
        parse(filename: "quran-simple-enhanced")
        stage = .english
        parse(filename: "en.sahih")
    }
    
    func parse(filename: String){
        if let resourcePath = Bundle.main.path(forResource: filename, ofType: "xml") {
            if FileManager().fileExists(atPath: resourcePath) {
                var xmlString = ""
                do {
                    xmlString =  try String(contentsOfFile: resourcePath, encoding: .utf8)
                } catch {
                    
                }
                
                let xmlData = xmlString.data(using: String.Encoding.utf8)!
                let parser = XMLParser(data: xmlData)
                
                parser.delegate = self;
                
                parser.parse()
            }
        }
    }
}

extension QuranParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "sura" {
            currentSurah.index = Int(attributeDict["index"]!)!
            currentSurah.name = attributeDict["name"]!
        } else if elementName == "aya" {
            let aya = Aya()
            aya.index = Int(attributeDict["index"]!)!
            aya.text = attributeDict["text"]!
            
            currentSurah.ayas.append(aya)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "sura" {
            switch stage {
            case .arabic:
                allSurahs.append(currentSurah.copy())
            case .english:
                allTranslatedSurahs.append(currentSurah.copy())
            }
            currentSurah.clear()
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        if stage == .english {
            completion?(allSurahs, allTranslatedSurahs)
        }
    }
}
