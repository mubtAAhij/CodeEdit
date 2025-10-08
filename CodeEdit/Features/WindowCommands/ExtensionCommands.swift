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
        CommandMenu(String(localized: "menu.extensions", comment: "Extensions menu title")) {
            Button(String(localized: "extensions.open_window", comment: "Open extensions window action")) {
                openWindow(sceneID: .extensions)
            }
        }
    }
}
