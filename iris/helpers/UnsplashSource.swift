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

    func random(withOptions params: Parameters? = nil) -> URL? {
        return buildUrl(endpoint: "random", options: params)
    }

    func today(type: ImageType? = .urban) -> URL? {
        switch type! {
        case .urban:
            return buildUrl(endpoint: "buildings", options: nil)
        case .nature:
            return buildUrl(endpoint: "nature", options: nil)
        }
    }

    fileprivate func buildUrl(endpoint: String, options: Parameters?) -> URL? {
        var segments = [baseUrl, endpoint]

        if let size = options?.size {
            segments.append("\(Int(size.width))x\(Int(size.height))")
        }

        return URL(string: segments.joined(separator: slash))
    }
    
}
