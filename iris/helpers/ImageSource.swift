//
//  ImageSource.swift
//  iris
//
//  Created by Kyle Milner on 05/10/2016.
//  Copyright © 2016 kyRobot. All rights reserved.
//

import Foundation
import Cocoa

protocol ImageSource {

    // Should return a random image, with optional parameter overrides
    func random(withOptions: Parameters?) -> URL?

    // Should return an Image with the given ImageType, with optional parameter overrides
    func get(type: ImageType?, withOptions: Parameters?) -> URL?
}
