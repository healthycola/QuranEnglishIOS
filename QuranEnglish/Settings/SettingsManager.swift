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
}

class SettingsManager {
    static let shared = SettingsManager()
    
    private init() { }
    
    private var observers: [ObjectIdentifier : SettingsObserver] = [:]
    var arabicFontSize: CGFloat = 20 {
        didSet {
            self.notifyObservers(updatedSetting: Setting.arabicFontSize(arabicFontSize))
        }
    }
    
    var englishFontSize: CGFloat = 15 {
        didSet {
            self.notifyObservers(updatedSetting: Setting.englishFontSize(englishFontSize))
        }
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
