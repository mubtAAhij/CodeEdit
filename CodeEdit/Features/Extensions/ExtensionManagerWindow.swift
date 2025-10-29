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
        Window(
            String(localized: "Extensions", comment: "Extensions window title"),
            id: SceneID.extensions.rawValue
        ) {
            NavigationSplitView {
                ExtensionsListView(selection: $selection)
            } detail: {
                switch selection.count {
                case 0:
                    Text(String(localized: "Select an extension", comment: "Prompt when no extension is selected"))
                case 1:
                    ExtensionDetailView(ext: selection.first!)
                default:
                    Text(String(localized: "\(selection.count) selected", comment: "Label showing number of selected extensions"))
                }
            }
            .environmentObject(manager)
            .focusedObject(manager)
        }
    }
}
