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
            statusButton.action = #selector(AppDelegate.itemClicked)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {

    }

    func itemClicked(_ sender: AnyObject) {
        NSApplication.shared().terminate(sender)
    }




}

