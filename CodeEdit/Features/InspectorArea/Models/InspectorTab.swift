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
            return String(localized: "inspector.tab.file.icon", defaultValue: "doc", comment: "File inspector icon")
        case .gitHistory:
            return String(localized: "inspector.tab.history.icon", defaultValue: "clock", comment: "History inspector icon")
        case .internalDevelopment:
            return String(localized: "inspector.tab.internal-development.icon", defaultValue: "hammer", comment: "Internal development inspector icon")
        case .uiExtension(_, let data):
            return data.icon ?? String(localized: "inspector.tab.extension.icon", defaultValue: "e.square", comment: "Extension inspector icon")
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
        case .file:
            return String(localized: "inspector.tab.file", defaultValue: "File Inspector", comment: "File inspector title")
        case .gitHistory:
            return String(localized: "inspector.tab.history", defaultValue: "History Inspector", comment: "History inspector title")
        case .internalDevelopment:
            return String(localized: "inspector.tab.internal-development", defaultValue: "Internal Development", comment: "Internal development inspector title")
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
