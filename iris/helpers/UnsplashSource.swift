//
//  UnsplashSource.swift
//  iris
//
//  Created by Kyle Milner on 05/10/2016.
//  Copyright © 2016 kyRobot. All rights reserved.
//

import Foundation
import Cocoa

final class UnsplashSource: ImageSource {

    fileprivate let baseUrl = "https://source.unsplash.com"
    fileprivate let slash = "/"

    func random(withOptions params: Parameters?) -> URL? {
        return get(type: ImageType.random, withOptions: params)
    }

    func get(type: ImageType? = .random, withOptions params: Parameters?) -> URL? {
        let options = standardOptions(overrides: params)
        if options.frequency == .never {
            return nil
        }
        let category = "category/"
        switch type! {
        case .urban:
            return buildUrl(endpoint: category+"buildings", options: options)
        case .nature:
            return buildUrl(endpoint: category+"nature", options: options)
        case .random:
            return random(withOptions: options)
        }
    }

    fileprivate func buildUrl(endpoint: String, options: Parameters) -> URL? {
        // ordering is important
        var segments = [baseUrl, endpoint]

        segments.append("\(Int(options.size!.width))x\(Int(options.size!.height))")

        if let frequency = options.frequency {
            if frequency == .daily || frequency == .weekly {
                segments.append(frequency.rawValue)
            }
        }


        return URL(string: segments.joined(separator: slash))
    }

    fileprivate func standardOptions(overrides: Parameters?) -> Parameters {
        var base = Parameters()
        base.size = overrides?.size ?? NSSize(width: 1499, height: 900)
        base.frequency = overrides?.frequency ?? UpdateFrequency.request
        return base
    }

}
