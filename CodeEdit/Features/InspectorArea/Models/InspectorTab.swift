//
//  InspectorTab.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 02/06/2023.
//

import SwiftUI
import CodeEditKit
import ExtensionFoundation

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
        case .uiExtension(_, let data):
            return data.icon ?? "e.square"
        }
    }

    var id: String {
        switch self {
        case .file:
            return "file"
        case .gitHistory:
            return "gitHistory"
        case .internalDevelopment:
            return "internalDevelopment"
        case .uiExtension(let endpoint, let data):
            return endpoint.bundleIdentifier + data.sceneID
        }
    }

    var title: String {
        switch self {
        case .file:
            return String(localized: "inspector.tab.file", defaultValue: "File Inspector", comment: "Inspector tab title for file inspector")
        case .gitHistory:
            return String(localized: "inspector.tab.history", defaultValue: "History Inspector", comment: "Inspector tab title for history inspector")
        case .internalDevelopment:
            return String(localized: "inspector.tab.internal-development", defaultValue: "Internal Development", comment: "Inspector tab title for internal development tools")
        case .uiExtension(_, let data):
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
