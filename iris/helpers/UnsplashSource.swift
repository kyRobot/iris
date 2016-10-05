//
//  UnsplashSource.swift
//  iris
//
//  Created by Kyle Milner on 05/10/2016.
//  Copyright © 2016 kyRobot. All rights reserved.
//

import Foundation
import Cocoa

class UnsplashSource: ImageSource {

    fileprivate let baseUrl = "https://source.unsplash.com"
    fileprivate let slash = "/"

    func random() -> URL? {
        return buildUrl(segment: "random")
    }

    func today(type: ImageType? = .Urban) -> URL? {
        switch type! {
        case .Urban:
            return buildUrl(segment: "buildings")
        case .Nature:
            return buildUrl(segment: "nature")
        }
    }

    fileprivate func buildUrl(segment: String) -> URL? {
        return URL(string:[baseUrl, segment].joined(separator: slash))
    }
    
}
