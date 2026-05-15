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
        CommandMenu(String(localized: "commands.extensions.menu", defaultValue: "Extensions", comment: "Extensions menu in menu bar")) {
            Button(String(localized: "commands.extensions.open-window", defaultValue: "Open Extensions Window", comment: "Command to open the extensions window")) {
                openWindow(sceneID: .extensions)
            }
        }
    }
}
