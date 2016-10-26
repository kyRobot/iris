//
//  File.swift
//  iris
//
//  Created by Kyle Milner on 05/10/2016.
//  Copyright © 2016 kyRobot. All rights reserved.
//

import Foundation

enum ImageType: String {
    case random, urban, nature
}

struct UIConstants {
    static let themes = "Theme"
    static let random = "Random"
    static let urban = "Urban"
    static let nature = "Nature"

    static let update = "Update"
    static let daily = "Daily"
    static let weekly = "Weekly"
    static let themely = "With theme"
    static let never = "Never"

    static let quit = "Quit Iris"
}

enum UpdateFrequency: String {
    case request, daily, weekly, never
}

struct Parameters {
    var size: NSSize?
    var frequency: UpdateFrequency?
}
