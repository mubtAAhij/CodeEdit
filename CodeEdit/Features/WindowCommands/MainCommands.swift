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
            Button(String(localized: "menu.about-codeedit", defaultValue: "About CodeEdit", comment: "About CodeEdit menu item")) {
                openWindow(sceneID: .about)
            }

            Button(String(localized: "menu.check-for-updates", defaultValue: "Check for updates...", comment: "Check for updates menu item")) {
                NSApp.sendAction(#selector(SPUStandardUpdaterController.checkForUpdates(_:)), to: nil, from: nil)
            }
        }

        CommandGroup(replacing: .appSettings) {
            Button(String(localized: "menu.settings", defaultValue: "Settings...", comment: "Settings menu item")) {
                openWindow(sceneID: .settings)
            }
            .keyboardShortcut(",")
        }
    }
}
