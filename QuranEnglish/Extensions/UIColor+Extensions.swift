//
//  UIColor+Extensions.swift
//  QuranEnglish
//
//  Created by Aamir Jawaid on 2018-10-20.
//  Copyright © 2018 Aamir Jawaid. All rights reserved.
//

import UIKit

extension UIColor {
    static func colorFromHexString (_ hex:String) -> UIColor {
        var cleanColorString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cleanColorString.hasPrefix("#") {
            cleanColorString.remove(at: cleanColorString.startIndex)
        }
        
        if (cleanColorString.count) != 6 {
            print("Warning: \(cleanColorString) didn't contain valid color values. Returning gray")
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cleanColorString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
