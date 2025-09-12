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
            Button("String(localized: "about_codeedit", comment: "Menu item to show About CodeEdit dialog")") {
                openWindow(sceneID: .about)
            }

            Button("String(localized: "check_for_updates", comment: "Menu item to check for updates")") {
                NSApp.sendAction(#selector(SPUStandardUpdaterController.checkForUpdates(_:)), to: nil, from: nil)
            }
        }

        CommandGroup(replacing: .appSettings) {
            Button("String(localized: "settings", comment: "Menu item to open Settings")") {
                openWindow(sceneID: .settings)
            }
            .keyboardShortcut(",")
        }
    }
}
