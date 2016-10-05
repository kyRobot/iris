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


    func applicationDidFinishLaunching(_ aNotification: Notification) {
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
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit iris", action: #selector(AppDelegate.quit), keyEquivalent: "q"))
        return menu
    }




}

