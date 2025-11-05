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
        Window(String(localized: "extensions.title", defaultValue: "Extensions", comment: "Window title for extension manager"), id: SceneID.extensions.rawValue) {
            NavigationSplitView {
                ExtensionsListView(selection: $selection)
            } detail: {
                switch selection.count {
                case 0:
                    Text(String(localized: "extensions.select-extension", defaultValue: "Select an extension", comment: "Message when no extension is selected"))
                case 1:
                    ExtensionDetailView(ext: selection.first!)
                default:
                    Text(String(localized: "extensions.selected-count", defaultValue: "\(selection.count) selected", comment: "Message showing number of selected extensions"))
                }
            }
            .environmentObject(manager)
            .focusedObject(manager)
        }
    }
}
