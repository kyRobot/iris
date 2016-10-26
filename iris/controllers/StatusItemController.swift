//
//  StatusItemController.swift
//  iris
//
//  Created by Kyle Milner on 14/10/2016.
//  Copyright © 2016 kyRobot. All rights reserved.
//

import Foundation
import Cocoa

final class StatusItemController: NSObject, NSMenuDelegate {

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
        let frequency: NSMenuItem = headerMenuItem(title: UIConstants.update)
        let submenu = NSMenu()
        submenu.addItem(frequencyMenuItem(title: UIConstants.daily, representing: .daily))
        submenu.addItem(frequencyMenuItem(title: UIConstants.weekly, representing: .weekly))
        submenu.addItem(frequencyMenuItem(title: UIConstants.hourly, representing: .hourly))
        submenu.addItem(frequencyMenuItem(title: UIConstants.manual, representing: .request))
        menu.addItem(frequency)
        menu.setSubmenu(submenu, for: frequency)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: UIConstants.quit,
                                action: #selector(self.quit),
                                keyEquivalent: "q"))

        for item in menu.items + submenu.items {
            item.target = self
        }
    }

    override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        let selected: Bool
        let represented = menuItem.representedObject

        switch menuItem.action {
        case #selector(categoryChoice(sender:))? :
            selected = represented as? ImageType == preferences.theme
        case #selector(frequencyChoice(sender:))? :
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
                              action: #selector(categoryChoice(sender:)),
                              keyEquivalent: "")
        item.representedObject = representing
        return item
    }

    fileprivate func frequencyMenuItem(title: String, representing: UpdateFrequency) -> NSMenuItem {
        let item = NSMenuItem(title: title,
                              action: #selector(frequencyChoice(sender:)),
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
        if preferences.frequency != frequency {
            preferences.frequency = frequency
            wallpaper.update(frequency: frequency)
        }

    }

}
