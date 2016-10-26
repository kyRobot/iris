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
    let wallpaper = WallpaperController()
    var preferences = Preferences()



    override init() {
        super.init()

        if let statusButton = statusItem.button {
            statusButton.image = #imageLiteral(resourceName: "menubar")
        }
        setupMenu()
        statusItem.menu = menu
        wallpaper.update(theme: preferences.theme)
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
        wallpaper.update(theme: theme)
    }

    @objc fileprivate func frequencyChoice(sender: NSMenuItem) {
        guard let frequency = sender.representedObject as? UpdateFrequency else { return }
        preferences.frequency = frequency
    }

}
