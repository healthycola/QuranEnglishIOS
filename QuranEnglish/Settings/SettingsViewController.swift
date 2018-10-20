//
//  SettingsViewController.swift
//  QuranEnglish
//
//  Created by Aamir Jawaid on 2018-10-20.
//  Copyright © 2018 Aamir Jawaid. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    private let fontChangeStep: Float = 5
    @IBOutlet weak var arabicFontSlider: UISlider! {
        didSet {
            arabicFontSlider.setValue(Float(SettingsManager.shared.arabicFontSize), animated: false)
        }
    }
    @IBOutlet weak var englishFontSlider: UISlider! {
        didSet {
            englishFontSlider.setValue(Float(SettingsManager.shared.englishFontSize), animated: false)
        }
    }
    @IBOutlet fileprivate weak var arabicTextPreview: UILabel! {
        didSet {
            arabicTextPreview.text = "اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ"
            arabicTextPreview.font = UIFont.currentArabicFont()
        }
    }
    @IBOutlet fileprivate weak var englishTextPreview: UILabel! {
        didSet {
            englishTextPreview.text = "Guide us to the straight path"
            englishTextPreview.font = UIFont.currentEnglishFont()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SettingsManager.shared.addObserver(self)
        navigationItem.title = "Settings"
    }
    
    deinit {
        SettingsManager.shared.removeObserver(self)
    }
    
    @IBAction func fontSliderChange(_ sender: UISlider) {
        let roundedStepValue = round(sender.value / fontChangeStep) * fontChangeStep
        sender.value = roundedStepValue
        
        if sender == arabicFontSlider {
            SettingsManager.shared.arabicFontSize = CGFloat(roundedStepValue)
        } else if sender == englishFontSlider {
            SettingsManager.shared.englishFontSize = CGFloat(roundedStepValue)
        }
    }
}

extension SettingsViewController: SettingsObserver {
    func receiveNotification(updatedSetting: Setting) {
        switch updatedSetting {
        case .arabicFontSize(_):
            arabicTextPreview.font = UIFont.currentArabicFont()
            break
        case .englishFontSize(_):
            englishTextPreview.font = UIFont.currentEnglishFont()
            break
        }
    }
}
