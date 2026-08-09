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
        Window(String(localized: "extensions.manager.window-title", defaultValue: "Extensions", comment: "Title of extension manager window"), id: SceneID.extensions.rawValue) {
            NavigationSplitView {
                ExtensionsListView(selection: $selection)
            } detail: {
                switch selection.count {
                case 0:
                    Text(String(localized: "extensions.manager.select-extension", defaultValue: "Select an extension", comment: "Placeholder prompting user to select an extension"))
                case 1:
                    ExtensionDetailView(ext: selection.first!)
                default:
                    Text("\(selection.count) selected")
                }
            }
            .environmentObject(manager)
            .focusedObject(manager)
        }
    }
}
