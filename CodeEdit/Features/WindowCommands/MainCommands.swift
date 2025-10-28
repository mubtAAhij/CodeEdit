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
            Button("window.about_codeedit", comment: "Menu item to open about window") {
                openWindow(sceneID: .about)
            }

            Button("menu.check_for_updates", comment: "Menu item to check for updates") {
                NSApp.sendAction(#selector(SPUStandardUpdaterController.checkForUpdates(_:)), to: nil, from: nil)
            }
        }

        CommandGroup(replacing: .appSettings) {
            Button("menu.settings", comment: "Menu item to open settings") {
                openWindow(sceneID: .settings)
            }
            .keyboardShortcut(",")
        }
    }
}
