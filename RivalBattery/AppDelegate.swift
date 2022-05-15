import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var popover: NSPopover!
    var statusBarItem: NSStatusItem!
    let statusBarMenu = NSMenu(title: "Status Bar Menu")

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()
        
        // Create the popover
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 400)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover
        
        // Create the status item
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        
        if let button = self.statusBarItem.button {
            button.image = NSImage(systemSymbolName: "battery.0", accessibilityDescription: "Battery")
            button.action = #selector(togglePopover(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
            statusBarMenu.addItem(
                withTitle: "Quit",
                action: #selector(AppDelegate.quit),
                keyEquivalent: "")
            
            
            // Setting menu
            button.menu = statusBarMenu
        }
        
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        //        if let button = self.statusBarItem.button {
        //            if self.popover.isShown {
        //                self.popover.performClose(sender)
        //            } else {
        //                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        //            }
        //        }
        let event = NSApp.currentEvent!
        if let button = self.statusBarItem.button {
            if event.type == NSEvent.EventType.leftMouseUp {
                if self.popover.isShown {
                    self.popover.performClose(sender)
                } else {
                    self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                }
                
            } else {
                // FIXME: This was deprecated in 11.0 for some reason
                self.statusBarItem.popUpMenu(statusBarMenu)
            }
        }
    }
    @objc func quit() {
        NSApp.terminate(self)
    }
}

