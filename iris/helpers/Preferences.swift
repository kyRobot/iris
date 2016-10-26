//
//  UserPreferences.swift
//  iris
//
//  Created by Kyle Milner on 14/10/2016.
//  Copyright © 2016 kyRobot. All rights reserved.
//

import Foundation

struct Preferences {
    fileprivate let defaults = UserDefaults.standard

    fileprivate struct Keys {
        static let currentTheme = "CURRENT_THEME"
        static let update = "UPDATE_FREQUENCY"
    }

    init() {

    }

    var theme: ImageType {
        get {
            return ImageType(rawValue: defaults.string(forKey: Keys.currentTheme)!) ?? .random
        }

        set {
            defaults.set(newValue.rawValue, forKey: Keys.currentTheme)
        }
    }

    var frequency: UpdateFrequency {
        get {
            return UpdateFrequency(rawValue: defaults.string(forKey: Keys.update)!) ?? .request
        }

        set {
            defaults.set(newValue.rawValue, forKey: Keys.update)
        }
    }


}
