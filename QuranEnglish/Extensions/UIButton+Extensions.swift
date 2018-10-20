//
//  UIButton+Extensions.swift
//  QuranEnglish
//
//  Created by Aamir Jawaid on 2018-10-19.
//  Copyright © 2018 Aamir Jawaid. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift

extension UIButton {
    static func getButtonWithFontAwesome(icon: FontAwesome, size: CGFloat, fontAwesomeStyle: FontAwesomeStyle = .solid) -> UIButton {
        let button = UIButton()
        button.titleLabel?.font = UIFont.fontAwesome(ofSize: size, style: fontAwesomeStyle)
        button.setTitle(String.fontAwesomeIcon(name: icon), for: .normal)
        
        return button
    }
}
