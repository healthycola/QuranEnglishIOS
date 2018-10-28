//
//  FastScroll+Extensions.swift
//  QuranEnglish
//
//  Created by Aamir Jawaid on 2018-10-28.
//  Copyright © 2018 Aamir Jawaid. All rights reserved.
//

import Foundation
import FastScroll

extension FastScrollTableView {
    func setup() {
        self.handleMarginRight = 5
        self.handleRadius = 5
        self.handleWidth = 10
        self.handleHeight = 10
        self.scrollbarMarginRight = 9
        self.scrollbarMarginTop = 80
        self.bubbleMarginRight = 10
        self.bubbleShadowOpacity = 0
        self.handleShadowOpacity = 0
        self.handleTimeToDisappear = 1
    }
    
    func updateWithSettings(_ settings: ISettings) {
        self.bubbleColor = settings.theme.secondaryBackgroundColor
        self.bubbleTextColor = settings.theme.primaryTint
        self.handleColor = settings.theme.primaryTint
        self.scrollbarColor = settings.theme.foreground.withAlphaComponent(0.5)
        self.bubbleTextSize = settings.englishFontSize
    }
}
