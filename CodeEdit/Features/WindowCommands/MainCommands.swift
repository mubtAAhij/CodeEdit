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
            Button(String(localized: "window-commands.main.about-codeedit", defaultValue: "About CodeEdit", comment: "Main command title to show about dialog")) {
                openWindow(sceneID: .about)
            }

            Button(String(localized: "window-commands.main.check-for-updates", defaultValue: "Check for updates...", comment: "Main command title to check for application updates")) {
                NSApp.sendAction(#selector(SPUStandardUpdaterController.checkForUpdates(_:)), to: nil, from: nil)
            }
        }

        CommandGroup(replacing: .appSettings) {
            Button(String(localized: "window-commands.main.settings", defaultValue: "Settings...", comment: "Main command title to open settings window")) {
                openWindow(sceneID: .settings)
            }
            .keyboardShortcut(",")
        }
    }
}
