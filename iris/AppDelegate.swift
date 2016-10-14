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

    var statusItemController: StatusItemController?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItemController = StatusItemController()
    }

    func applicationWillTerminate(_ aNotification: Notification) {

    }
    
    
}
