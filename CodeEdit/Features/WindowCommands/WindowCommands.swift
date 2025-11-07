//
//  WindowCommands.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 13/03/2023.
//

import SwiftUI

struct WindowCommands: Commands {
    @Environment(\.openWindow)
    var openWindow

    var body: some Commands {
        CommandGroup(replacing: .singleWindowList) {
            Button(String(localized: "menu.welcome-to-codeedit", defaultValue: "Welcome to CodeEdit", comment: "Menu item to open welcome window")) {
                openWindow(sceneID: .welcome)
            }
            .keyboardShortcut("1", modifiers: [.shift, .command])

            Button(String(localized: "menu.about-codeedit", defaultValue: "About CodeEdit", comment: "Menu item to show about window")) {
                openWindow(sceneID: .about)
            }
            .keyboardShortcut("2", modifiers: [.shift, .command])

            Button(String(localized: "menu.manage-extensions", defaultValue: "Manage Extensions", comment: "Menu item to open extensions manager")) {
                openWindow(sceneID: .extensions)
            }
            .keyboardShortcut("3", modifiers: [.shift, .command])
        }
    }
}
