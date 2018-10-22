//
//  SettingsManager.swift
//  QuranEnglish
//
//  Created by Aamir Jawaid on 2018-10-20.
//  Copyright © 2018 Aamir Jawaid. All rights reserved.
//

import Foundation
import UIKit

protocol SettingsObserver {
    func receiveNotification(updatedSetting: Setting)
}

enum Setting {
    case arabicFontSize(CGFloat)
    case englishFontSize(CGFloat)
    case theme(Theme)
}

class SettingsManager {
    static let shared = SettingsManager()
    
    private init() { }
    
    private var observers: [ObjectIdentifier : SettingsObserver] = [:]
    var arabicFontSize: CGFloat = 30 {
        didSet {
            self.notifyObservers(updatedSetting: Setting.arabicFontSize(arabicFontSize))
        }
    }
    
    var englishFontSize: CGFloat = 12 {
        didSet {
            self.notifyObservers(updatedSetting: Setting.englishFontSize(englishFontSize))
        }
    }
    
    var theme: Theme = .theme1 {
        didSet {
            self.notifyObservers(updatedSetting: Setting.theme(theme))
            self.applyTheme(with: theme)
        }
    }
    
    func applyTheme(with theme: Theme) {
        UINavigationBar.appearance().barStyle = UIBarStyle.blackTranslucent
        UINavigationBar.appearance().tintColor = theme.backgroundColor
//        navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
//        navigationController?.navigationBar.barTintColor  = theme.backgroundColor;
        
        // You get your current (selected) theme and apply the main color to the tintColor property of your application’s window.
//        let sharedApplication = UIApplication.shared
//        sharedApplication.delegate?.window??.tintColor = theme.mainColor
//
//        UINavigationBar.appearance().barStyle = theme.barStyle
//        UINavigationBar.appearance().setBackgroundImage(theme.navigationBackgroundImage, for: .default)
//        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "backArrow")
//        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "backArrowMaskFixed")
//
//        UITabBar.appearance().barStyle = theme.barStyle
//        UITabBar.appearance().backgroundImage = theme.tabBarBackgroundImage
//
//        let tabIndicator = UIImage(named: "tabBarSelectionIndicator")?.withRenderingMode(.alwaysTemplate)
//        let tabResizableIndicator = tabIndicator?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 2.0, bottom: 0, right: 2.0))
//        UITabBar.appearance().selectionIndicatorImage = tabResizableIndicator
//
//        let controlBackground = UIImage(named: "controlBackground")?.withRenderingMode(.alwaysTemplate)
//            .resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
//        let controlSelectedBackground = UIImage(named: "controlSelectedBackground")?
//            .withRenderingMode(.alwaysTemplate)
//            .resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
//
//        UISegmentedControl.appearance().setBackgroundImage(controlBackground, for: .normal, barMetrics: .default)
//        UISegmentedControl.appearance().setBackgroundImage(controlSelectedBackground, for: .selected, barMetrics: .default)
//
//        UIStepper.appearance().setBackgroundImage(controlBackground, for: .normal)
//        UIStepper.appearance().setBackgroundImage(controlBackground, for: .disabled)
//        UIStepper.appearance().setBackgroundImage(controlBackground, for: .highlighted)
//        UIStepper.appearance().setDecrementImage(UIImage(named: "fewerPaws"), for: .normal)
//        UIStepper.appearance().setIncrementImage(UIImage(named: "morePaws"), for: .normal)
//
//        UISlider.appearance().setThumbImage(UIImage(named: "sliderThumb"), for: .normal)
//        UISlider.appearance().setMaximumTrackImage(UIImage(named: "maximumTrack")?
//            .resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 6.0)), for: .normal)
//        UISlider.appearance().setMinimumTrackImage(UIImage(named: "minimumTrack")?
//            .withRenderingMode(.alwaysTemplate)
//            .resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 6.0, bottom: 0, right: 0)), for: .normal)
//
//        UISwitch.appearance().onTintColor = theme.mainColor.withAlphaComponent(0.3)
//        UISwitch.appearance().thumbTintColor = theme.mainColor
    }
    
    func addObserver(_ settingsObserver: SettingsObserver & AnyObject) {
        let objectId = ObjectIdentifier(settingsObserver)
        observers[objectId] = settingsObserver
    }
    
    func removeObserver(_ settingsObserver: SettingsObserver & AnyObject) {
        let objectId = ObjectIdentifier(settingsObserver)
        observers.removeValue(forKey: objectId)
    }
    
    private func notifyObservers(updatedSetting: Setting) {
        observers.forEach {
            $1.receiveNotification(updatedSetting: updatedSetting)
        }
    }
}
