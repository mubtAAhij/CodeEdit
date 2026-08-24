//
//  ExtensionCommands.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 24/03/2023.
//

import CodeEditKit
import SwiftUI

struct ExtensionCommands: Commands {
    @FocusedObject var manager: ExtensionManager?

    @Environment(\.openWindow)
    var openWindow

    var body: some Commands {
        CommandMenu(String(localized: "window-commands.extensions.menu-title", defaultValue: "Extensions", comment: "Command menu title for extensions")) {
            Button(String(localized: "window-commands.extensions.open-window", defaultValue: "Open Extensions Window", comment: "Menu item title to open extensions window")) {
                openWindow(sceneID: .extensions)
            }
        }
    }
}
