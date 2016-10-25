//
//  File.swift
//  iris
//
//  Created by Kyle Milner on 05/10/2016.
//  Copyright © 2016 kyRobot. All rights reserved.
//

import Foundation

enum ImageType: Int {
    case random, urban, nature
}

struct UIConstants {
    static let Themes = "Theme"
    static let Random = "Random"
    static let Urban = "Urban"
    static let Nature = "Nature"

    static let Quit = "Quit Iris"
}

enum UpdateFrequency {
    case request, daily, weekly
}

struct Parameters {
    var size: NSSize?
    var frequency: UpdateFrequency?
}
