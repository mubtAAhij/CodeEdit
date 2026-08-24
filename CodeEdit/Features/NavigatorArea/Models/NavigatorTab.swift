//
//  NavigatorTab.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 02/06/2023.
//

import CodeEditKit
import ExtensionFoundation
import SwiftUI

enum NavigatorTab: WorkspacePanelTab {
    case project
    case sourceControl
    case search
    case uiExtension(endpoint: AppExtensionIdentity, data: ResolvedSidebar.SidebarStore)

    var systemImage: String {
        switch self {
        case .project:
            return "folder"
        case .sourceControl:
            return "vault"
        case .search:
            return "magnifyingglass"
        case let .uiExtension(_, data):
            return data.icon ?? "e.square"
        }
    }

    var id: String {
        if case let .uiExtension(endpoint, data) = self {
            return endpoint.bundleIdentifier + data.sceneID
        }
        return title
    }

    var title: String {
        switch self {
        case .project:
            return String(localized: "navigator.tab.project", defaultValue: "Project", comment: "Navigator tab title for project files")
        case .sourceControl:
            return String(localized: "navigator.tab.source-control", defaultValue: "Source Control", comment: "Navigator tab title for source control")
        case .search:
            return String(localized: "navigator.tab.search", defaultValue: "Search", comment: "Navigator tab title for search")
        case let .uiExtension(_, data):
            return data.help ?? data.sceneID
        }
    }

    var body: some View {
        switch self {
        case .project:
            ProjectNavigatorView()
        case .sourceControl:
            SourceControlNavigatorView()
        case .search:
            FindNavigatorView()
        case let .uiExtension(endpoint, data):
            ExtensionSceneView(with: endpoint, sceneID: data.sceneID)
        }
    }
}
