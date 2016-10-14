//
//  File.swift
//  iris
//
//  Created by Kyle Milner on 05/10/2016.
//  Copyright © 2016 kyRobot. All rights reserved.
//

import Foundation

enum ImageType {
    case urban, nature, random
}

enum UpdateFrequency {
    case request, daily, weekly
}

struct Parameters {
    var size: NSSize?
    var frequency: UpdateFrequency?
}


