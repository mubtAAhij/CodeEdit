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
            Button(String(localized: "window-commands.main.about-codeedit", defaultValue: "About CodeEdit", comment: "Main menu item to open the about window")) {
                openWindow(sceneID: .about)
            }

            Button(String(localized: "window-commands.main.check-for-updates", defaultValue: "Check for updates...", comment: "Main menu item to check for app updates")) {
                NSApp.sendAction(#selector(SPUStandardUpdaterController.checkForUpdates(_:)), to: nil, from: nil)
            }
        }

        CommandGroup(replacing: .appSettings) {
            Button(String(localized: "window-commands.main.settings", defaultValue: "Settings...", comment: "Main menu item to open application settings")) {
                openWindow(sceneID: .settings)
            }
            .keyboardShortcut(",")
        }
    }
}
