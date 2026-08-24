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
            Button(
                String(
                    localized: "window-commands.window.welcome",
                    defaultValue: "Welcome to CodeEdit",
                    comment: "Window command to open the welcome window"
                )
            ) {
                openWindow(sceneID: .welcome)
            }
            .keyboardShortcut("1", modifiers: [.shift, .command])

            Button(
                String(
                    localized: "window-commands.window.about",
                    defaultValue: "About CodeEdit",
                    comment: "Window command to open the about window"
                )
            ) {
                openWindow(sceneID: .about)
            }
            .keyboardShortcut("2", modifiers: [.shift, .command])

            Button(
                String(
                    localized: "window-commands.window.manage-extensions",
                    defaultValue: "Manage Extensions",
                    comment: "Window command to open the extensions manager"
                )
            ) {
                openWindow(sceneID: .extensions)
            }
            .keyboardShortcut("3", modifiers: [.shift, .command])
        }
    }
}
