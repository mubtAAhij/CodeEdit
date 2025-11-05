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
        Window(String(localized: "window.extensions", defaultValue: "Extensions", comment: "Extensions window title"), id: SceneID.extensions.rawValue) {
            NavigationSplitView {
                ExtensionsListView(selection: $selection)
            } detail: {
                switch selection.count {
                case 0:
                    Text(String(localized: "extension.select-extension", defaultValue: "Select an extension", comment: "Prompt to select an extension"))
                case 1:
                    ExtensionDetailView(ext: selection.first!)
                default:
                    Text(String(localized: "extension.selected-count", defaultValue: "\(selection.count) selected", comment: "Message showing number of selected extensions"))
                }
            }
            .environmentObject(manager)
            .focusedObject(manager)
        }
    }
}
