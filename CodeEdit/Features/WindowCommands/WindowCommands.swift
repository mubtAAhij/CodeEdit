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
            Button(String(localized: "window.welcome", comment: "Welcome to CodeEdit button text")) {
                openWindow(sceneID: .welcome)
            }
            .keyboardShortcut("1", modifiers: [.shift, .command])

            Button(String(localized: "window.about", comment: "About CodeEdit button text")) {
                openWindow(sceneID: .about)
            }
            .keyboardShortcut("2", modifiers: [.shift, .command])

            Button(String(localized: "window.manage_extensions", comment: "Manage Extensions button text")) {
                openWindow(sceneID: .extensions)
            }
            .keyboardShortcut("3", modifiers: [.shift, .command])
        }
    }
}
