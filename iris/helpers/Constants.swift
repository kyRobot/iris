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
    static let manual = "Manually"
    static let hourly = "Hourly"

    static let quit = "Quit Iris"

    static let nextUpdate = "Next update:"
    static let noUpdate = "\(nextUpdate) Never"
}

enum UpdateFrequency: String {
    case request, hourly, daily, weekly
}

struct Parameters {
    var size: NSSize?
    var frequency: UpdateFrequency?
}
