//
//  DeveloperSettingsView.swift
//  CodeEdit
//
//  Created by Abe Malla on 5/16/24.
//

import SwiftUI
import LanguageServerProtocol

/// A view that implements the Developer settings section
struct DeveloperSettingsView: View {
    @AppSettings(\.developerSettings.lspBinaries)
    var lspBinaries

    @AppSettings(\.developerSettings.showInternalDevelopmentInspector)
    var showInternalDevelopmentInspector

    var body: some View {
        SettingsForm {
            Section {
                Toggle("developer_settings.show_internal_inspector", comment: "Toggle label", isOn: $showInternalDevelopmentInspector)
            }

            Section {
                KeyValueTable(
                    items: $lspBinaries,
                    validKeys: LanguageIdentifier.allCases.map { $0.rawValue },
                    keyColumnName: String(localized: "developer_settings.language", comment: "Column name"),
                    valueColumnName: String(localized: "developer_settings.language_server_path", comment: "Column name"),
                    newItemInstruction: String(localized: "developer_settings.add_language_server", comment: "Instruction text")
                ) {
                    Text("developer_settings.add_language_server_title", comment: "Title text")
                    Text(
                        "developer_settings.lsp_binary_instruction",
                        comment: "Description text"
                    )
                } actionBarTrailing: {
                    EmptyView()
                }
                .frame(minHeight: 96)
            } header: {
                Text("developer_settings.lsp_binaries", comment: "Section header")
                Text("developer_settings.lsp_binaries_description", comment: "Section description")
            }
        }
    }
}
