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
    let menu = NSMenu()
    let source: ImageSource = UnsplashSource()
    var commonOptions = Parameters()

    var selectedCategory: Int = -999

    let tempWindow: NSWindow = NSWindow(contentRect: NSMakeRect(100, 100, 1080, 720),
                                        styleMask: [NSWindowStyleMask.titled,
                                                    NSWindowStyleMask.closable,
                                                    NSWindowStyleMask.resizable,
                                                    NSWindowStyleMask.miniaturizable],
                                        backing: NSBackingStoreType.buffered, defer: true)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        commonOptions.size = largestScreenSize()

        if let statusButton = statusItem.button {
            statusButton.image = #imageLiteral(resourceName: "menubar")
        }
        setupMenu()
        statusItem.menu = menu
    }

    func applicationWillTerminate(_ aNotification: Notification) {

    }

    func quit(sender: AnyObject) {
        NSApplication.shared().terminate(sender)
    }

    fileprivate func setupMenu() {
        menu.addItem(headerMenuItem(title: "Theme"))
        menu.addItem(themeChoiceMenuItem(title: "Random", tag: .random))
        menu.addItem(themeChoiceMenuItem(title: "Nature", tag: .nature))
        menu.addItem(themeChoiceMenuItem(title: "Urban", tag: .urban))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit iris", action: #selector(AppDelegate.quit), keyEquivalent: "q"))
    }

    override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        if (menuItem.action == #selector(self.categoryChoice(sender:))) {
            menuItem.state = (menuItem.tag == selectedCategory ? NSOnState : NSOffState)
        }
        return true
    }

    fileprivate func headerMenuItem(title: String) -> NSMenuItem {
        return NSMenuItem(title: title, action: nil, keyEquivalent: "")
    }

    fileprivate func themeChoiceMenuItem(title: String, tag: ImageType) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: #selector(self.categoryChoice(sender:)), keyEquivalent: "")
        item.tag = tag.hashValue
        return item
    }

    @objc fileprivate func categoryChoice(sender: NSMenuItem) {
        selectedCategory = sender.tag
        switch sender.tag {
        case ImageType.nature.hashValue:
            updateImage(theme: .nature)
        case ImageType.urban.hashValue:
            updateImage(theme: .urban)
        case ImageType.random.hashValue:
            updateImage(theme: .random)
        default: break
        }
    }

//    MARK: Menu Action functions
    fileprivate func updateImage(theme: ImageType) {
        guard let url = source.get(type: theme, withOptions: commonOptions) else { return }
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

