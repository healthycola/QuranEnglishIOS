//
//  UIFont+Extneions.swift
//  QuranEnglish
//
//  Created by Aamir Jawaid on 2018-10-13.
//  Copyright © 2018 Aamir Jawaid. All rights reserved.
//

import Foundation
import UIKit

enum ArabicFont: String {
    case AlNile = "AlNile"
    case AlNileBold = "AlNile-Bold"
    case Alkalami = "Alkalami-Regular"
    case AlBayan = "AlBayan"
    case AraAlBayanBold = "AraAlBayan-Bold"
}

enum EnglishFont: String {
    case Palatino = "Palatino-Roman"
}

extension UIFont {
    static func arabicFont(arabicFont: ArabicFont, size: CGFloat) -> UIFont {
        return UIFont(name: arabicFont.rawValue, size: size)!
    }
    
    static func englishFont(englishFont: EnglishFont, size: CGFloat) -> UIFont {
        return UIFont(name: englishFont.rawValue, size: size)!
    }
    
    static func printAllFonts() {
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
    }
    
    static func currentArabicFont() -> UIFont {
        return UIFont.arabicFont(arabicFont: .AlNileBold, size: SettingsManager.shared.arabicFontSize)
    }
    
    static func currentEnglishFont() -> UIFont {
        return UIFont.englishFont(englishFont: .Palatino, size: SettingsManager.shared.englishFontSize)
    }
}
