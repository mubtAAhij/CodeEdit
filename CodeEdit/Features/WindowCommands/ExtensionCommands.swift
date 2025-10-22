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
        CommandMenu(Text("extensions.menu", comment: "Menu title")) {
            Button(String(localized: "extensions.open_window", comment: "Button text")) {
                openWindow(sceneID: .extensions)
            }
        }
    }
}
