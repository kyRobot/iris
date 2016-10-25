//
//  UserPreferences.swift
//  iris
//
//  Created by Kyle Milner on 14/10/2016.
//  Copyright © 2016 kyRobot. All rights reserved.
//

import Foundation

struct Preferences {
    fileprivate static let defaults = UserDefaults.standard

    fileprivate struct Keys {
        static let currentTheme = "CURRENT_THEME"
    }

    init() {

    }

    static var theme: ImageType {
        get {
            return ImageType(rawValue: defaults.integer(forKey: Keys.currentTheme)) ?? .random
        }

        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Keys.currentTheme)
        }
    }


}
