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

    func random(withOptions params: Parameters?) -> URL? {
        return buildUrl(endpoint: "random", options: standardOptions(options: params))
    }

    func today(type: ImageType? = .urban, withOptions params: Parameters?) -> URL? {
        var options = standardOptions(options: params)
        options.frequency = UpdateFrequency.daily
        let category = "category/"
        switch type! {
        case .urban:
            return buildUrl(endpoint: category+"buildings", options: options)
        case .nature:
            return buildUrl(endpoint: category+"nature", options: options)
        }
    }

    fileprivate func buildUrl(endpoint: String, options: Parameters) -> URL? {
        // ordering is important
        var segments = [baseUrl, endpoint]


        segments.append("\(Int(options.size!.width))x\(Int(options.size!.height))")


        return URL(string: segments.joined(separator: slash))
    }

    fileprivate func standardOptions(options: Parameters?) -> Parameters {
        var base = Parameters()
        base.size = options?.size ?? NSSize(width: 1499, height: 900)
        base.frequency = options?.frequency ?? UpdateFrequency.request
        return base
    }
    
}
