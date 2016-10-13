//
//  AppDelegate.swift
//  iris
//
//  Created by Kyle Milner on 04/10/2016.
//  Copyright © 2016 kyRobot. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let source: ImageSource = UnsplashSource()
    var largestKnownScreen: NSSize?

    let tempWindow: NSWindow = NSWindow(contentRect: NSMakeRect(100, 100, 1080, 720),
                                        styleMask: [NSWindowStyleMask.titled,
                                                    NSWindowStyleMask.closable,
                                                    NSWindowStyleMask.resizable,
                                                    NSWindowStyleMask.miniaturizable],
                                        backing: NSBackingStoreType.buffered, defer: true)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        largestKnownScreen = largestScreenSize()

        if let statusButton = statusItem.button {
            statusButton.image = #imageLiteral(resourceName: "menubar")
        }
        statusItem.menu = setupMenu()

    }

    func applicationWillTerminate(_ aNotification: Notification) {

    }

    func quit(sender: AnyObject) {
        NSApplication.shared().terminate(sender)
    }

    fileprivate func setupMenu() -> NSMenu {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Random", action: #selector(AppDelegate.randomImage), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit iris", action: #selector(AppDelegate.quit), keyEquivalent: "q"))
        return menu
    }

    func randomImage() {
        var imageOptions = Parameters()
        imageOptions.size = largestKnownScreen
        guard let supported = source.random(withOptions: imageOptions) else { return }
        asyncSetWallpaper(from: supported)
    }

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

            let controller = NSWindowController(window: self.tempWindow)
            self.tempWindow.contentView = viewController.view
            self.tempWindow.windowController = controller

            controller.showWindow(self)
        }
    }

    fileprivate func largestScreenSize() -> NSSize? {
        let compare: (NSScreen, NSScreen) throws -> Bool = { (a, b) in
            return a.frame.height > b.frame.height
        }
        return try! NSScreen.screens()?.max(by: compare)?.frame.size
    }

}

