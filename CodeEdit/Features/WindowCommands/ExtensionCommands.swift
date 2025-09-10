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
        CommandMenu("String(localized: "extensions", comment: "Menu item for extensions management")") {
            Button("String(localized: "open_extensions_window", comment: "Menu command to open the extensions window")") {
                openWindow(sceneID: .extensions)
            }
        }
    }
}
