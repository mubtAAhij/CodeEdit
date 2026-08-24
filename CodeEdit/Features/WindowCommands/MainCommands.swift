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
            Button(String(localized: "window-commands.main.about", defaultValue: "About CodeEdit", comment: "Main app command to open the About window")) {
                openWindow(sceneID: .about)
            }

            Button(String(localized: "window-commands.main.check-updates", defaultValue: "Check for updates...", comment: "Main app command to check for updates")) {
                NSApp.sendAction(#selector(SPUStandardUpdaterController.checkForUpdates(_:)), to: nil, from: nil)
            }
        }

        CommandGroup(replacing: .appSettings) {
            Button(String(localized: "window-commands.main.settings", defaultValue: "Settings...", comment: "Main app command to open settings")) {
                openWindow(sceneID: .settings)
            }
            .keyboardShortcut(",")
        }
    }
}
