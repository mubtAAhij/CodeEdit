//
//  NavigatorTab.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 02/06/2023.
//

import SwiftUI
import CodeEditKit
import ExtensionFoundation

enum NavigatorTab: WorkspacePanelTab {
    case project
    case sourceControl
    case search
    case uiExtension(endpoint: AppExtensionIdentity, data: ResolvedSidebar.SidebarStore)

    var systemImage: String {
        switch self {
        case .project:
            return String(localized: "navigator.tab.project.icon", defaultValue: "folder", comment: "Project navigator icon")
        case .sourceControl:
            return String(localized: "navigator.tab.source-control.icon", defaultValue: "vault", comment: "Source control navigator icon")
        case .search:
            return String(localized: "navigator.tab.search.icon", defaultValue: "magnifyingglass", comment: "Search navigator icon")
        case .uiExtension(_, let data):
            return data.icon ?? String(localized: "navigator.tab.extension.icon", defaultValue: "e.square", comment: "Extension navigator icon")
        }
    }

    var id: String {
        if case .uiExtension(let endpoint, let data) = self {
            return endpoint.bundleIdentifier + data.sceneID
        }
        return title
    }

    var title: String {
        switch self {
        case .project:
            return String(localized: "navigator.tab.project", defaultValue: "Project", comment: "Project navigator title")
        case .sourceControl:
            return String(localized: "navigator.tab.source-control", defaultValue: "Source Control", comment: "Source control navigator title")
        case .search:
            return String(localized: "navigator.tab.search", defaultValue: "Search", comment: "Search navigator title")
        case .uiExtension(_, let data):
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
