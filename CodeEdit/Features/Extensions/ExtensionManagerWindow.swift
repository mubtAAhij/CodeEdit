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
            String(localized: "extensions.title", comment: "Window title"),
            id: SceneID.extensions.rawValue
        ) {
            NavigationSplitView {
                ExtensionsListView(selection: $selection)
            } detail: {
                switch selection.count {
                case 0:
                    Text(String(localized: "extensions.selectExtension", comment: "Empty state message"))
                case 1:
                    ExtensionDetailView(ext: selection.first!)
                default:
                    Text(String(localized: "extensions.countSelected", comment: "Selection count", arguments: selection.count))
                }
            }
            .environmentObject(manager)
            .focusedObject(manager)
        }
    }
}
