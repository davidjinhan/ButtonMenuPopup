//
//  UserDefaultsHelper.swift
//  ButtonMenuPopup
//
//  Created by HanJin on 2017. 3. 27..
//  Copyright © 2017년 DavidJinHan. All rights reserved.
//

import Foundation

class UserDefaultsHelper {

    struct Fruits {
        
        struct Key {
            static let ButtonsSequence = "Fruits.ButtonsSequence"
            static let EnabledButtons = "Fruits.EnabledButtons"
        }
        
        struct Default {
            static let ButtonsSequence: [String] = ButtonType.fruit.buttonStrings
            static let EnabledButtons: [String] = ButtonType.fruit.buttonStrings
        }
        
        static var buttonsSequence: [String] {
            get {
                if let sequenceArray = UserDefaults.standard.object(forKey: Key.ButtonsSequence) as? [String] {
                    return sequenceArray
                } else {
                    return Default.ButtonsSequence
                }
            }
            set {
                UserDefaults.standard.set(newValue, forKey: Key.ButtonsSequence)
            }
        }
        
        static var enabledButtons: [String] {
            get {
                if let sequenceArray = UserDefaults.standard.object(forKey: Key.EnabledButtons) as? [String] {
                    return sequenceArray
                } else {
                    return Default.EnabledButtons
                }
            }
            set {
                UserDefaults.standard.set(newValue, forKey: Key.EnabledButtons)
            }
        }
    }
    
    struct Vegetable {
        
        struct Key {
            static let ButtonsSequence = "Vegetable.ButtonsSequence"
            static let EnabledButtons = "Vegetable.EnabledButtons"
        }
        
        struct Default {
            static let ButtonsSequence: [String] = ButtonType.vegetable.buttonStrings
            static let EnabledButtons: [String] = ButtonType.vegetable.buttonStrings
        }
        
        static var buttonsSequence: [String] {
            get {
                if let sequenceArray = UserDefaults.standard.object(forKey: Key.ButtonsSequence) as? [String] {
                    return sequenceArray
                } else {
                    return Default.ButtonsSequence
                }
            }
            set {
                UserDefaults.standard.set(newValue, forKey: Key.ButtonsSequence)
            }
        }
        
        static var enabledButtons: [String] {
            get {
                if let sequenceArray = UserDefaults.standard.object(forKey: Key.EnabledButtons) as? [String] {
                    return sequenceArray
                } else {
                    return Default.EnabledButtons
                }
            }
            set {
                UserDefaults.standard.set(newValue, forKey: Key.EnabledButtons)
            }
        }
    }
}
