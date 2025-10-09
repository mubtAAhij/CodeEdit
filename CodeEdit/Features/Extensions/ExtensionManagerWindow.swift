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
        Window(String(localized: "extension_manager.window_title", comment: "Window title for the Extensions manager"), id: SceneID.extensions.rawValue) {
            NavigationSplitView {
                ExtensionsListView(selection: $selection)
            } detail: {
                switch selection.count {
                case 0:
                    Text(String(localized: "extension_manager.select_extension", comment: "Message shown when no extension is selected"))
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
