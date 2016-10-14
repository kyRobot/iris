//
//  StatusItemController.swift
//  iris
//
//  Created by Kyle Milner on 14/10/2016.
//  Copyright © 2016 kyRobot. All rights reserved.
//

import Foundation
import Cocoa

class StatusItemController: NSObject, NSMenuDelegate {

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

    override init() {
        super.init()
        commonOptions.size = largestScreenSize()

        if let statusButton = statusItem.button {
            statusButton.image = #imageLiteral(resourceName: "menubar")
        }
        setupMenu()
        statusItem.menu = menu
    }

    fileprivate func setupMenu() {
        menu.addItem(headerMenuItem(title: UIConstants.Themes))
        menu.addItem(themeChoiceMenuItem(title: UIConstants.Random, tag: .random))
        menu.addItem(themeChoiceMenuItem(title: UIConstants.Nature, tag: .nature))
        menu.addItem(themeChoiceMenuItem(title: UIConstants.Urban, tag: .urban))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: UIConstants.Quit, action: #selector(self.quit), keyEquivalent: "q"))
        menu.items.forEach({(item) in item.target = self})
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
        item.tag = tag.rawValue
        return item
    }

    //    MARK: Menu Action functions
    @objc fileprivate func quit(sender: AnyObject) {
        NSApplication.shared().terminate(sender)
    }

    @objc fileprivate func categoryChoice(sender: NSMenuItem) {

        guard let knownType = ImageType(rawValue: sender.tag) else { return }

        selectedCategory = sender.tag
        switch (knownType) {
        case .nature:
            updateImage(theme: .nature)
        case .urban:
            updateImage(theme: .urban)
        case .random:
            updateImage(theme: .random)
        }
    }

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
