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
            Button(String(localized: "window-commands.main.about", defaultValue: "About CodeEdit", comment: "Command title to open the About window")) {
                openWindow(sceneID: .about)
            }

            Button(String(localized: "window-commands.main.check-for-updates", defaultValue: "Check for updates...", comment: "Command title to check for application updates")) {
                NSApp.sendAction(#selector(SPUStandardUpdaterController.checkForUpdates(_:)), to: nil, from: nil)
            }
        }

        CommandGroup(replacing: .appSettings) {
            Button(String(localized: "window-commands.main.settings", defaultValue: "Settings...", comment: "Command title to open settings")) {
                openWindow(sceneID: .settings)
            }
            .keyboardShortcut(",")
        }
    }
}
