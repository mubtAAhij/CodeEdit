//
//  InspectorTab.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 02/06/2023.
//

import CodeEditKit
import ExtensionFoundation
import SwiftUI

enum InspectorTab: WorkspacePanelTab {
    case file
    case gitHistory
    case internalDevelopment
    case uiExtension(endpoint: AppExtensionIdentity, data: ResolvedSidebar.SidebarStore)

    var systemImage: String {
        switch self {
        case .file:
            return "doc"
        case .gitHistory:
            return "clock"
        case .internalDevelopment:
            return "hammer"
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
        case .file:
            return String(localized: "inspector_tab.file_inspector", defaultValue: "File Inspector", comment: "Inspector tab title for file inspector")
        case .gitHistory:
            return String(localized: "inspector_tab.history_inspector", defaultValue: "History Inspector", comment: "Inspector tab title for history inspector")
        case .internalDevelopment:
            return String(localized: "inspector_tab.internal_development", defaultValue: "Internal Development", comment: "Inspector tab title for internal development tools")
        case let .uiExtension(_, data):
            return data.help ?? data.sceneID
        }
    }

    var body: some View {
        switch self {
        case .file:
            FileInspectorView()
        case .gitHistory:
            HistoryInspectorView()
        case .internalDevelopment:
            InternalDevelopmentInspectorView()
        case let .uiExtension(endpoint, data):
            ExtensionSceneView(with: endpoint, sceneID: data.sceneID)
        }
    }
}
