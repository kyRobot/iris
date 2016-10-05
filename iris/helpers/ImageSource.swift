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

    func random() -> URL?

    func today(type: ImageType?) -> URL?
}
