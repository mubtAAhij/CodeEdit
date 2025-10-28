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
        CommandMenu(String(localized: "extensions.menu", comment: "Extensions")) {
            Button(String(localized: "extensions.open_window", comment: "Open Extensions Window")) {
                openWindow(sceneID: .extensions)
            }
        }
    }
}
