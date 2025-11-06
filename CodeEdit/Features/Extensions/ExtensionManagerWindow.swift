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
        Window(String(localized: "extensions.title", defaultValue: "Extensions", comment: "Extensions window title"), id: SceneID.extensions.rawValue) {
            NavigationSplitView {
                ExtensionsListView(selection: $selection)
            } detail: {
                switch selection.count {
                case 0:
                    Text(String(localized: "extensions.select-prompt", defaultValue: "Select an extension", comment: "Prompt to select an extension from the list"))
                case 1:
                    ExtensionDetailView(ext: selection.first!)
                default:
                    Text(String(localized: "extensions.selected-count", defaultValue: "\(selection.count) selected", comment: "Number of selected extensions"))
                }
            }
            .environmentObject(manager)
            .focusedObject(manager)
        }
    }
}
