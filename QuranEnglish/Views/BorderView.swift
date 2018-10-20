//
//  BorderView.swift
//  QuranEnglish
//
//  Created by Aamir Jawaid on 2018-10-16.
//  Copyright © 2018 Aamir Jawaid. All rights reserved.
//

import Foundation
import UIKit

enum BorderType {
    case Vertical, Horizontal
}

class BorderView: UIView {
    required init?(coder aDecoder: NSCoder) {
        self.height = 0
        self.width = 0
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        self.height = 0
        self.width = 0
        super.init(frame: frame)
    }
    
    private var height: CGFloat
    private var width: CGFloat
    
    convenience init(borderType: BorderType, length: CGFloat, thickness: CGFloat = 1) {
        var height: CGFloat
        var width: CGFloat
        switch borderType {
        case .Horizontal:
            height = thickness
            width = length
        case .Vertical:
            height = length
            width = thickness
        }
        
        self.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        self.height = height
        self.width = width
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: height)
    }
}
