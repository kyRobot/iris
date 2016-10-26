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

    var preferences = Preferences()

    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let menu = NSMenu()
    let source: ImageSource = UnsplashSource()
    var commonOptions = Parameters()

    let tempWindow: NSWindow = NSWindow(contentRect: NSRect(x: 10, y:10, width: 1280, height: 720),
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
        updateImage(theme: preferences.theme)
    }

    fileprivate func setupMenu() {
        menu.addItem(headerMenuItem(title: UIConstants.themes))
        menu.addItem(categoryMenuItem(title: UIConstants.random, representing: .random))
        menu.addItem(categoryMenuItem(title: UIConstants.nature, representing: .nature))
        menu.addItem(categoryMenuItem(title: UIConstants.urban, representing: .urban))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(headerMenuItem(title: UIConstants.update))
        menu.addItem(frequencyMenuItem(title: UIConstants.daily, representing: .daily))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: UIConstants.quit,
                                action: #selector(self.quit),
                                keyEquivalent: "q"))
        menu.items.forEach({(item) in item.target = self})
    }

    override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        let selected: Bool
        let represented = menuItem.representedObject

        switch menuItem.action {
        case #selector(categoryChoice(sender:))? :
            selected = represented as? ImageType == preferences.theme
        case #selector(self.frequencyChoice(sender:))? :
            selected = represented as? UpdateFrequency == preferences.frequency
        default:
            selected = false
        }
        menuItem.state = selected ? NSOnState : NSOffState
        return true
    }

    fileprivate func headerMenuItem(title: String) -> NSMenuItem {
        return NSMenuItem(title: title, action: nil, keyEquivalent: "")
    }

    fileprivate func categoryMenuItem(title: String, representing: ImageType) -> NSMenuItem {
        let item = NSMenuItem(title: title,
                              action: #selector(self.categoryChoice(sender:)),
                              keyEquivalent: "")
        item.representedObject = representing
        return item
    }

    fileprivate func frequencyMenuItem(title: String, representing: UpdateFrequency) -> NSMenuItem {
        let item = NSMenuItem(title: title,
                              action: #selector(self.frequencyChoice(sender:)),
                              keyEquivalent: "")
        item.representedObject = representing
        return item
    }

    //    MARK: Menu Action functions
    @objc fileprivate func quit(sender: AnyObject) {
        NSApplication.shared().terminate(sender)
    }

    @objc fileprivate func categoryChoice(sender: NSMenuItem) {
        guard let theme = sender.representedObject as? ImageType else { return }
        preferences.theme = theme
        updateImage(theme: theme)
    }

    @objc fileprivate func frequencyChoice(sender: NSMenuItem) {
        guard let frequency = sender.representedObject as? UpdateFrequency else { return }
        preferences.frequency = frequency
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
        let compare: (NSScreen, NSScreen) -> Bool = { (this, that) in
            return this.frame.height > that.frame.height
        }
        return NSScreen.screens()?.max(by: compare)?.frame.size
    }





}
