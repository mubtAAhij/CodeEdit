//
//  ExtensionManagerWindow.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 24/03/2023.
//

import SwiftUI

struct ExtensionManagerWindow: Scene {
    @ObservedObject var manager = ExtensionManager.shared

    @State var selection = Set<ExtensionInfo>()

    var body: some Scene {
        Window(String(localized: "extensions.window-title", defaultValue: "Extensions", comment: "Extensions window title"), id: SceneID.extensions.rawValue) {
            NavigationSplitView {
                ExtensionsListView(selection: $selection)
            } detail: {
                switch selection.count {
                case 0:
                    Text(String(localized: "extensions.select-extension", defaultValue: "Select an extension", comment: "Empty state when no extension is selected"))
                case 1:
                    ExtensionDetailView(ext: selection.first!)
                default:
                    Text(String(format: String(localized: "extensions.multiple-selected", defaultValue: "%d selected", comment: "Multiple extensions selected"), selection.count))
                }
            }
            .environmentObject(manager)
            .focusedObject(manager)
        }
    }
}
