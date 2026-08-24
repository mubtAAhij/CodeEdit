//
//  MainCommands.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 13/03/2023.
//

import Sparkle
import SwiftUI

struct MainCommands: Commands {
    @Environment(\.openWindow)
    var openWindow

    var body: some Commands {
        CommandGroup(replacing: .appInfo) {
            Button(String(localized: "window-commands.main.about-codeedit", defaultValue: "About CodeEdit", comment: "Main app command title for About CodeEdit")) {
                openWindow(sceneID: .about)
            }

            Button(String(localized: "window-commands.main.check-for-updates", defaultValue: "Check for updates...", comment: "Main app command title to check for updates")) {
                NSApp.sendAction(#selector(SPUStandardUpdaterController.checkForUpdates(_:)), to: nil, from: nil)
            }
        }

        CommandGroup(replacing: .appSettings) {
            Button(String(localized: "window-commands.main.settings", defaultValue: "Settings...", comment: "Main app command title to open app settings")) {
                openWindow(sceneID: .settings)
            }
            .keyboardShortcut(",")
        }
    }
}
