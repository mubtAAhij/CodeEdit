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
                Toggle(String(localized: "developer_settings.show_internal_inspector", comment: "Toggle to show internal development inspector"), isOn: $showInternalDevelopmentInspector)
            }

            Section {
                KeyValueTable(
                    items: $lspBinaries,
                    validKeys: LanguageIdentifier.allCases.map { $0.rawValue },
                    keyColumnName: String(localized: "developer_settings.language", comment: "Column header for language selection"),
                    valueColumnName: String(localized: "developer_settings.language_server_path", comment: "Column header for language server path"),
                    newItemInstruction: String(localized: "developer_settings.add_language_server", comment: "Button text to add a language server")
                ) {
                    Text(String(localized: "developer_settings.add_language_server", comment: "Button text to add a language server"))
                    Text(
                        String(localized: "developer_settings.lsp_path_instruction", comment: "Instructions for specifying LSP binary path")
                    )
                } actionBarTrailing: {
                    EmptyView()
                }
                .frame(minHeight: 96)
            } header: {
                Text(String(localized: "developer_settings.lsp_binaries", comment: "Section header for LSP binaries"))
                Text(String(localized: "developer_settings.lsp_binary_description", comment: "Description for LSP binaries section"))
            }
        }
    }
}
