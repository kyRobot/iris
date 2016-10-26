//
//  WallpaperController.swift
//  iris
//
//  Created by Kyle Milner on 26/10/2016.
//  Copyright © 2016 kyRobot. All rights reserved.
//

import Foundation
import Cocoa

class WallpaperController {

    let source: ImageSource = UnsplashSource()
    var requestOptions = Parameters()

    let window: NSWindow = NSWindow(contentRect: NSRect(x: 10, y:10, width: 1280, height: 720),
                                        styleMask: [NSWindowStyleMask.titled,
                                                    NSWindowStyleMask.closable,
                                                    NSWindowStyleMask.resizable,
                                                    NSWindowStyleMask.miniaturizable],
                                        backing: NSBackingStoreType.buffered, defer: true)

    init() {
        requestOptions.size = largestScreenSize()
    }

    fileprivate func largestScreenSize() -> NSSize? {
        let compare: (NSScreen, NSScreen) -> Bool = { (this, that) in
            return this.frame.height > that.frame.height
        }
        return NSScreen.screens()?.max(by: compare)?.frame.size
    }

    func update(theme: ImageType) {
        guard let url = source.get(type: theme, withOptions: requestOptions) else { return }
        asyncSetWallpaper(from: url)
    }

    //    MARK: Wallpaper changes
    fileprivate func asyncSetWallpaper(from url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let imageData = data, error == nil else { return }
            self.showAsWindow(data: imageData)
            //            self.setAsWallpaper(data: imageData)
            }.resume()
    }

    fileprivate func setAsWallpaper(data: Data) {
        do {
            let fileURL = URL(fileURLWithPath:NSTemporaryDirectory())
                .appendingPathComponent(UUID().uuidString)
            try data.write(to: fileURL)
            let workspace = NSWorkspace.shared()
            try NSScreen.screens()?.forEach { screen in
                try workspace.setDesktopImageURL(fileURL,
                                            for: screen,
                                            options: workspace.desktopImageOptions(for: screen)!)
            }
        } catch _ {
            // maybe pop a notification here?
            print ("uh oh. find a nice way to report this")
        }
    }

    fileprivate func showAsWindow(data: Data) {
        let image = NSImage(data: data)
        // Jump onto main thread to update UI
        DispatchQueue.main.async {
            let imageView = NSImageView()
            imageView.image = image
            let viewController = NSViewController()
            viewController.view = imageView

            let controller = NSWindowController(window: self.window)
            self.window.contentView = viewController.view
            self.window.windowController = controller

            controller.showWindow(self)
        }
    }


}
