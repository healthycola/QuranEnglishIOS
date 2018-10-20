//
//  UIBarButtonItem.swift
//  QuranEnglish
//
//  Created by Aamir Jawaid on 2018-10-19.
//  Copyright © 2018 Aamir Jawaid. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift

extension UIBarButtonItem {
    static func getFontAwesomeBarButton(icon: FontAwesome, size: CGFloat, fontAwesomeStyle: FontAwesomeStyle = .solid) -> UIBarButtonItem {
        let attributes = [
            NSAttributedString.Key.font: UIFont.fontAwesome(ofSize: size, style: fontAwesomeStyle)
        ]
        
        let button = UIBarButtonItem()
        [UIControl.State.normal, .highlighted, .disabled].forEach {
            button.setTitleTextAttributes(attributes, for: $0)
        }
        button.title = String.fontAwesomeIcon(name: icon)
        
        return button
    }
}
