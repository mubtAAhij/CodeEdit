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
            Button("About CodeEdit", comment: "Menu item") {
                openWindow(sceneID: .about)
            }

            Button("Check for updates...", comment: "Menu item") {
                NSApp.sendAction(#selector(SPUStandardUpdaterController.checkForUpdates(_:)), to: nil, from: nil)
            }
        }

        CommandGroup(replacing: .appSettings) {
            Button("Settings...", comment: "Menu item") {
                openWindow(sceneID: .settings)
            }
            .keyboardShortcut(",")
        }
    }
}
