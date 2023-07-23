//
//  ApplicationMenu.swift
//  Lunchi
//
//  Created by Raul Villarreal on 21/07/23.
//

import Foundation
import SwiftUI

class ApplicationMenu: NSObject {
    let menu = NSMenu()
    var settingsWindowController: NSWindowController?
    
    func createMenu() -> NSMenu {
        let recipeView = RecipeView()
        let topView = NSHostingController(rootView: recipeView)
        topView.view.frame.size = CGSize(width: 225, height: 225)
        
        let customMenuItem = NSMenuItem()
        customMenuItem.view = topView.view
        menu.addItem(customMenuItem)
        menu.addItem(NSMenuItem.separator())
        
        let webLinkMenuItem = NSMenuItem(title: "Raul Villarreal", action: #selector(openLink), keyEquivalent: "")
        webLinkMenuItem.target = self
        webLinkMenuItem.representedObject = "https://www.linkedin.com/in/raulvillarreals/"
        menu.addItem(webLinkMenuItem)
        
        let settingsMenuItem = NSMenuItem(title: "Settings", action: #selector(openSettings), keyEquivalent: ",")
        settingsMenuItem.target = self
        menu.addItem(settingsMenuItem)
        
        let quitMenuItem = NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q")
        quitMenuItem.target = self
        menu.addItem(quitMenuItem)
        
        return menu
    }
    
    @objc func openLink(sender: NSMenuItem) {
        let link = sender.representedObject as! String
        guard let url = URL(string: link) else { return }
        NSWorkspace.shared.open(url)
    }
    
    @objc func quit(sender: NSMenuItem) {
        NSApp.terminate(self)
    }
    
    @objc func openSettings(sender: NSMenuItem) {
        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
    }

}
