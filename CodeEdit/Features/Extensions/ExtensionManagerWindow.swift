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
            String(localized: "extensions.window_title", comment: "Window title"),
            id: SceneID.extensions.rawValue
        ) {
            NavigationSplitView {
                ExtensionsListView(selection: $selection)
            } detail: {
                switch selection.count {
                case 0:
                    Text("extensions.select_extension", comment: "Placeholder text")
                case 1:
                    ExtensionDetailView(ext: selection.first!)
                default:
                    Text("extensions.count_selected \(selection.count)", comment: "Selection count")
                }
            }
            .environmentObject(manager)
            .focusedObject(manager)
        }
    }
}
