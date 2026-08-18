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
        Window(String(
            localized: "extensions.manager-window.title",
            defaultValue: "Extensions",
            comment: "Title of extension manager window"
        ), id: SceneID.extensions.rawValue) {
            NavigationSplitView {
                ExtensionsListView(selection: $selection)
            } detail: {
                switch selection.count {
                case 0:
                    Text(String(
                        localized: "extensions.manager-window.select-an-extension",
                        defaultValue: "Select an extension",
                        comment: "Placeholder prompt when no extension is selected"
                    ))
                case 1:
                    ExtensionDetailView(ext: selection.first!)
                default:
                    Text(String(format: String(
                        localized: "extensions.manager-window.selection-count",
                        defaultValue: "%d selected",
                        comment: "Selection count label in extension manager window"
                    ), selection.count))
                }
            }
            .environmentObject(manager)
            .focusedObject(manager)
        }
    }
}
