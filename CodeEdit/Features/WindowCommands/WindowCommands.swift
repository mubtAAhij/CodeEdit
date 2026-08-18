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
            Button(String(
                localized: "window-commands.window.welcome-to-codeedit",
                defaultValue: "Welcome to CodeEdit",
                comment: "Window command title to open welcome window"
            )) {
                openWindow(sceneID: .welcome)
            }
            .keyboardShortcut("1", modifiers: [.shift, .command])

            Button(String(
                localized: "window-commands.window.about-codeedit",
                defaultValue: "About CodeEdit",
                comment: "Window command title to open about dialog"
            )) {
                openWindow(sceneID: .about)
            }
            .keyboardShortcut("2", modifiers: [.shift, .command])

            Button(String(
                localized: "window-commands.window.manage-extensions",
                defaultValue: "Manage Extensions",
                comment: "Window command title to open extensions manager"
            )) {
                openWindow(sceneID: .extensions)
            }
            .keyboardShortcut("3", modifiers: [.shift, .command])
        }
    }
}
