//
//  Theme.swift
//  QuranEnglish
//
//  Created by Aamir Jawaid on 2018-10-20.
//  Copyright © 2018 Aamir Jawaid. All rights reserved.
//

import UIKit

enum Theme: String {
    case theme1 = "Theme1"
    case theme2 = "Theme2"
    
    var backgroundColor: UIColor {
        switch self {
        case .theme1:
            return UIColor.colorFromHexString("292D3E")
        case .theme2:
            return UIColor.colorFromHexString("#FAFAFA")
        }
    }
    
    var secondaryBackgroundColor: UIColor {
        switch self {
        case .theme1:
            return UIColor.colorFromHexString("333747")
        case .theme2:
            return UIColor.colorFromHexString("#EEEEEE")
        }
    }
    
    var primaryTint: UIColor {
        switch self {
        case .theme1:
            return UIColor.colorFromHexString("FFCB6B")
        case .theme2:
            return UIColor.colorFromHexString("#7C4DFF")
        }
    }
    
    var foreground: UIColor {
        switch self {
        case .theme1:
            return UIColor.colorFromHexString("FFFFFF")
        case .theme2:
            return UIColor.colorFromHexString("464d51")
        }
    }
    
    var barStyle: UIBarStyle {
        switch self {
        case .theme1:
            return UIBarStyle.blackTranslucent
        case .theme2:
            return UIBarStyle.default
        }
    }
}
