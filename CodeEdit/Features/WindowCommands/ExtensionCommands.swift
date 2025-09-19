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
        CommandMenu(String(localized: "extensions", comment: "Extensions menu title")) {
            Button(String(localized: "open_extensions_window", comment: "Menu item to open extensions window")) {
                openWindow(sceneID: .extensions)
            }
        }
    }
}
