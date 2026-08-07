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
        CommandMenu(String(localized: "window-commands.extensions.menu.title", defaultValue: "Extensions", comment: "Title of extensions command menu")) {
            Button(String(localized: "window-commands.extensions.open-window.title", defaultValue: "Open Extensions Window", comment: "Menu item title to open the extensions window")) {
                openWindow(sceneID: .extensions)
            }
        }
    }
}
