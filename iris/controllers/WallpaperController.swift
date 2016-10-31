//
//  WallpaperController.swift
//  iris
//
//  Created by Kyle Milner on 26/10/2016.
//  Copyright © 2016 kyRobot. All rights reserved.
//

import Foundation
import Cocoa

final class WallpaperController {

    let source: ImageSource = UnsplashSource()
    var requestOptions = Parameters()
    let prefs = Preferences()
    var timer: Timer?


    private struct Interval {
        static let hour = 1.0 * 60.0 * 60.0
        static let day = hour * 24.0
        static let week = day * 7.0
    }


    init() {
        refreshOptions()
        let _ = resetTimer(frequency: prefs.frequency)
    }

    fileprivate func refreshOptions() {
        requestOptions.frequency = prefs.frequency
        requestOptions.size = largestScreenSize()
    }

    fileprivate func resetTimer(frequency: UpdateFrequency) -> Date? {
        if let existing = timer {
            existing.invalidate()
        }

        switch frequency {
        case .request:
            timer = nil
        case .hourly:
            timer = timer(interval: Interval.hour)
        case .daily:
            timer = timer(interval: Interval.day)
        case .weekly:
            timer = timer(interval: Interval.week)
        }

        return timer?.fireDate
    }

    fileprivate func timer(interval: TimeInterval) -> Timer {
        let recurring =  Timer.scheduledTimer(timeInterval: interval,
                            target: self,
                            selector: #selector(autoUpdate),
                            userInfo: nil,
                            repeats: true)
        recurring.tolerance = interval * 0.20
        return recurring
    }

    @objc
    fileprivate func autoUpdate() {
        update(theme: prefs.theme)
    }

    fileprivate func largestScreenSize() -> NSSize? {
        let compare: (NSScreen, NSScreen) -> Bool = { (this, that) in
            return this.frame.height > that.frame.height
        }
        return NSScreen.screens()?.max(by: compare)?.frame.size
    }

    func update(theme: ImageType) {
        refreshOptions()
        guard let url = source.get(type: theme, withOptions: requestOptions) else { return }
        asyncSetWallpaper(from: url)
    }

    func update(frequency: UpdateFrequency) -> Date? {
        return resetTimer(frequency: frequency)
    }

    //    MARK: Wallpaper changes
    fileprivate func asyncSetWallpaper(from url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                guard let imageData = data, error == nil else { return }
                let fileURL = URL(fileURLWithPath:NSTemporaryDirectory())
                    .appendingPathComponent(UUID().uuidString)
                try imageData.write(to: fileURL)
                let workspace = NSWorkspace.shared()

                try NSScreen.screens()?.forEach { screen in
                    let options = workspace.desktopImageOptions(for: screen)
                    try workspace.setDesktopImageURL(fileURL,
                                                     for: screen,
                                                     options: options!)
                }
            } catch _ {
                // maybe pop a notification here?
                print ("uh oh. find a nice way to report this")
            }
            }.resume()
    }


}
