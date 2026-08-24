//
//  UtilityAreaOutputView.swift
//  CodeEdit
//
//  Created by Austin Condiff on 5/25/23.
//

import LogStream
import SwiftUI

struct UtilityAreaOutputView: View {
    enum Sources: Hashable {
        case extensions(ExtensionUtilityAreaOutputSource)
        case languageServer(LanguageServerLogContainer)
        case devOutput

        var title: String {
            switch self {
            case let .extensions(source):
                "Extension - \(source.extensionInfo.name)"
            case let .languageServer(source):
                "Language Server - \(source.id)"
            case .devOutput:
                String(localized: "utility-area.output.source.internal-development", defaultValue: "Internal Development Output", comment: "Output source label for internal development output")
            }
        }

        static func == (_ lhs: Sources, _ rhs: Sources) -> Bool {
            switch (lhs, rhs) {
            case let (.extensions(lhs), .extensions(rhs)):
                return lhs.id == rhs.id
            case let (.languageServer(lhs), .languageServer(rhs)):
                return lhs.id == rhs.id
            case (.devOutput, .devOutput):
                return true
            default:
                return false
            }
        }

        func hash(into hasher: inout Hasher) {
            switch self {
            case let .extensions(source):
                hasher.combine(0)
                hasher.combine(source.id)
            case let .languageServer(source):
                hasher.combine(1)
                hasher.combine(source.id)
            case .devOutput:
                hasher.combine(2)
            }
        }
    }

    @EnvironmentObject private var utilityAreaViewModel: UtilityAreaViewModel

    @State private var filterText: String = ""
    @State private var selectedSource: Sources?

    var body: some View {
        UtilityAreaTabView(model: utilityAreaViewModel.tabViewModel) { _ in
            Group {
                if let selectedSource {
                    switch selectedSource {
                    case let .extensions(source):
                        UtilityAreaOutputLogList(source: source, filterText: $filterText) {
                            UtilityAreaOutputSourcePicker(selectedSource: $selectedSource)
                        }
                    case let .languageServer(source):
                        UtilityAreaOutputLogList(source: source, filterText: $filterText) {
                            UtilityAreaOutputSourcePicker(selectedSource: $selectedSource)
                        }
                    case .devOutput:
                        UtilityAreaOutputLogList(
                            source: InternalDevelopmentOutputSource.shared,
                            filterText: $filterText
                        ) {
                            UtilityAreaOutputSourcePicker(selectedSource: $selectedSource)
                        }
                    }
                } else {
                    Text(String(localized: "utility-area.output.empty", defaultValue: "No output", comment: "Empty state text when output view has no content"))
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                        .frame(maxHeight: .infinity)
                        .paneToolbar {
                            UtilityAreaOutputSourcePicker(selectedSource: $selectedSource)
                            Spacer()
                            UtilityAreaFilterTextField(title: String(localized: "utility-area.output.filter", defaultValue: "Filter", comment: "Filter field label in output utility view"), text: $filterText)
                                .frame(maxWidth: 175)
                            Button {} label: {
                                Image(systemName: "trash")
                            }
                            .disabled(true)
                        }
                }
            }
        }
    }
}
