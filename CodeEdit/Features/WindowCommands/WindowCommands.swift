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
            Button(String(localized: "menu.welcome", defaultValue: "Welcome to CodeEdit", comment: "Menu item to show Welcome window")) {
                openWindow(sceneID: .welcome)
            }
            .keyboardShortcut("1", modifiers: [.shift, .command])

            Button(String(localized: "menu.about-codeedit", defaultValue: "About CodeEdit", comment: "Menu item to show About CodeEdit window")) {
                openWindow(sceneID: .about)
            }
            .keyboardShortcut("2", modifiers: [.shift, .command])

            Button(String(localized: "menu.manage-extensions", defaultValue: "Manage Extensions", comment: "Menu item to open extension manager")) {
                openWindow(sceneID: .extensions)
            }
            .keyboardShortcut("3", modifiers: [.shift, .command])
        }
    }
}
