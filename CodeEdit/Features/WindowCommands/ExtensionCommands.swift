//
//  ExtensionCommands.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 24/03/2023.
//

import SwiftUI
import CodeEditKit

struct ExtensionCommands: Commands {
    @FocusedObject var manager: ExtensionManager?

    @Environment(\.openWindow)
    var openWindow

    var body: some Commands {
        CommandMenu(String(localized: "extensions.menu.title", defaultValue: "Extensions", comment: "Extensions menu title")) {
            Button(String(localized: "extensions.menu.open-window", defaultValue: "Open Extensions Window", comment: "Menu item to open extensions window")) {
                openWindow(sceneID: .extensions)
            }
        }
    }
}
