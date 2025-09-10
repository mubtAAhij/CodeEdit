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
        Window("String(localized: "extensions", comment: "Window title for extensions manager")", id: SceneID.extensions.rawValue) {
            NavigationSplitView {
                ExtensionsListView(selection: $selection)
            } detail: {
                switch selection.count {
                case 0:
                    Text("String(localized: "select_an_extension", comment: "Placeholder text when no extension is selected")")
                case 1:
                    ExtensionDetailView(ext: selection.first!)
                default:
                    Text("String(localized: "extensions_selected_count", comment: "Shows number of selected extensions")")
                }
            }
            .environmentObject(manager)
            .focusedObject(manager)
        }
    }
}
