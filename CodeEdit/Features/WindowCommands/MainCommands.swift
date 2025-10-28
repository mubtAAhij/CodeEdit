//
//  MainCommands.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 13/03/2023.
//

import SwiftUI
import Sparkle

struct MainCommands: Commands {
    @Environment(\.openWindow)
    var openWindow

    var body: some Commands {
        CommandGroup(replacing: .appInfo) {
            Button("window.about", comment: "About window menu item") {
                openWindow(sceneID: .about)
            }

            Button("menu.check_for_updates", comment: "Check for updates menu item") {
                NSApp.sendAction(#selector(SPUStandardUpdaterController.checkForUpdates(_:)), to: nil, from: nil)
            }
        }

        CommandGroup(replacing: .appSettings) {
            Button("menu.settings", comment: "Settings menu item") {
                openWindow(sceneID: .settings)
            }
            .keyboardShortcut(",")
        }
    }
}
