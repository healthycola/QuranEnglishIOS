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
    
    var defaultKey: String {
        switch self {
        case .arabicFontSize:
            return "arabicFontSize"
        case .englishFontSize:
            return "englishFontSize"
        case .theme:
            return "theme"
        }
    }
    
    func saveToUserDefaults() {
        let defaults = UserDefaults.standard
        switch self {
        case .arabicFontSize(let value):
            defaults.set(value, forKey: self.defaultKey)
        case .englishFontSize(let value):
            defaults.set(value, forKey: self.defaultKey)
        case .theme(let theme):
            defaults.set(theme.rawValue, forKey: self.defaultKey)
        }
    }
}

protocol ISettings {
    var englishFontSize: CGFloat { get }
    var arabicFontSize: CGFloat { get }
    var theme: Theme { get }
}

class SettingsManager: ISettings {
    static let shared = SettingsManager()
    
    private init() {
        self.arabicFontSize = UserDefaults.standard.value(forKey: Setting.arabicFontSize(0).defaultKey) as? CGFloat ?? 30
        self.englishFontSize = UserDefaults.standard.value(forKey: Setting.englishFontSize(0).defaultKey) as? CGFloat ?? 14
        let themeString = UserDefaults.standard.value(forKey: Setting.theme(.theme1).defaultKey) as? String ?? ""
        self.theme = Theme(rawValue: themeString) ?? .theme1
    }
    
    private var observers: [ObjectIdentifier : SettingsObserver] = [:]
    var arabicFontSize: CGFloat = 30 {
        didSet {
            let setting = Setting.arabicFontSize(arabicFontSize)
            self.notifyObservers(updatedSetting: setting)
            setting.saveToUserDefaults()
        }
    }
    
    var englishFontSize: CGFloat = 12 {
        didSet {
            let setting = Setting.englishFontSize(englishFontSize)
            self.notifyObservers(updatedSetting: Setting.englishFontSize(englishFontSize))
            setting.saveToUserDefaults()
        }
    }
    
    var theme: Theme = .theme1 {
        didSet {
            let setting = Setting.theme(theme)
            self.notifyObservers(updatedSetting: setting)
            setting.saveToUserDefaults()
            self.applyTheme(with: theme)
        }
    }
    
    func applyTheme(with theme: Theme) {
        UINavigationBar.appearance().barStyle = UIBarStyle.blackTranslucent
        UINavigationBar.appearance().tintColor = theme.backgroundColor
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
