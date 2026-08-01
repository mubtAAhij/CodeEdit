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
            Button(String(localized: "commands.about", defaultValue: "About CodeEdit", comment: "Menu item to show About window")) {
                openWindow(sceneID: .about)
            }

            Button(String(localized: "commands.check-updates", defaultValue: "Check for updates...", comment: "Menu item to check for updates")) {
                NSApp.sendAction(#selector(SPUStandardUpdaterController.checkForUpdates(_:)), to: nil, from: nil)
            }
        }

        CommandGroup(replacing: .appSettings) {
            Button(String(localized: "commands.settings", defaultValue: "Settings...", comment: "Menu item to open Settings")) {
                openWindow(sceneID: .settings)
            }
            .keyboardShortcut(",")
        }
    }
}
