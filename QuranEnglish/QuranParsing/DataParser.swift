//
//  DataParser.swift
//  QuranEnglish
//
//  Created by Aamir Jawaid on 2018-10-13.
//  Copyright © 2018 Aamir Jawaid. All rights reserved.
//

import Foundation

class DataParser<T>: NSObject, XMLParserDelegate {
    typealias ResultCompletion = (_ result: [T]) -> Void
    fileprivate var completions: [XMLParser:ResultCompletion] = [:]
    var allElements: [XMLParser : [T]] = [:]
    
    func parse(filename: String, completion: @escaping ResultCompletion) throws {
        if let resourcePath = Bundle.main.path(forResource: filename, ofType: "xml") {
            if FileManager().fileExists(atPath: resourcePath) {
                var xmlString = ""
                do {
                    xmlString =  try String(contentsOfFile: resourcePath, encoding: .utf8)
                } catch {
                    throw QuranParsingError.unableToReadContents(filename: resourcePath);
                }
                
                let xmlData = xmlString.data(using: String.Encoding.utf8)!
                let parser = XMLParser(data: xmlData)
                allElements[parser] = [T]()
                completions[parser] = completion
                
                parser.delegate = self
                parser.parse()
            } else {
                throw QuranParsingError.fileNotFound(filename: filename)
            }
        } else {
            throw QuranParsingError.fileNotFound(filename: filename)
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        fatalError("Not implemented")
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        if let completion = completions[parser] {
            completion(allElements[parser]!)
            
            completions.removeValue(forKey: parser)
            allElements.removeValue(forKey: parser)
        }
    }
}
