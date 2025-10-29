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
        CommandMenu(String(localized: "Extensions", comment: "Menu title for extensions")) {
            Button(String(localized: "Open Extensions Window", comment: "Button to open extensions window")) {
                openWindow(sceneID: .extensions)
            }
        }
    }
}
