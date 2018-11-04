//
//  SurahTableViewCell.swift
//  QuranEnglish
//
//  Created by Aamir Jawaid on 2018-11-04.
//  Copyright © 2018 Aamir Jawaid. All rights reserved.
//

import Foundation
import SwipeCellKit
import UIKit

class SurahViewCell: SwipeTableViewCell {
    @IBOutlet private weak var arabicText: UILabel!
    @IBOutlet private weak var translation: UILabel!
    @IBOutlet private weak var index: UILabel!
    @IBOutlet private weak var secondaryBackground: UIView!
    @IBOutlet private weak var secondaryBackgroundShadow: UIView!
    @IBOutlet private weak var bookmarkView: UIView!
    
    public static let reuseIdentifier = "surahViewCell"
    
    private var theme: Theme!
    
    func setup(theme: Theme, arabicText: String, index: Int, translation: String?, isBookmarked: Bool) {
        backgroundColor = theme.backgroundColor
        secondaryBackground.backgroundColor = theme.secondaryBackgroundColor
        secondaryBackgroundShadow.backgroundColor = theme.foreground
        self.theme = theme
        self.arabicText.textColor = theme.foreground
        self.translation.textColor = theme.foreground
        self.index.textColor = theme.foreground
        self.bookmarkView.backgroundColor = isBookmarked ? theme.primaryTint : UIColor.clear
        
        setArabicText(arabicText)
        setTranslationText(translation)
        self.index.text = String(index)
    }
    
    func setBookmark(_ value: Bool) {
        self.bookmarkView.backgroundColor = value ? theme.primaryTint : UIColor.clear
    }
    
    private func setArabicText(_ arabicText: String) {
        let attributedString = NSMutableAttributedString(string: arabicText)
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 2 // Whatever line spacing you want in points
        paragraphStyle.alignment = .right
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.currentArabicFont(), range: NSMakeRange(0, attributedString.length))
        // *** Set Attributed String to your label ***
        self.arabicText.attributedText = attributedString
    }
    
    private func setTranslationText(_ text: String?) {
        if let text = text {
            let attributedString = NSMutableAttributedString(string: text)
            // *** Create instance of `NSMutableParagraphStyle`
            let paragraphStyle = NSMutableParagraphStyle()
            // *** set LineSpacing property in points ***
            paragraphStyle.lineSpacing = 4 // Whatever line spacing you want in points
            // *** Apply attribute to string ***
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.currentEnglishFont(), range: NSMakeRange(0, attributedString.length))
            // *** Set Attributed String to your label ***
            self.translation.attributedText = attributedString
        } else {
            self.translation.text = ""
        }
    }
}

extension UITableView {
    func registerSurahViewCell() {
        self.register(UINib(nibName: XibName.surahTableViewCell.rawValue, bundle: nil), forCellReuseIdentifier: SurahViewCell.reuseIdentifier)
    }
}
