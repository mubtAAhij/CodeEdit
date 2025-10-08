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
                Toggle(String(localized: "developer_settings.show_internal_inspector", comment: "Toggle for showing internal development inspector"), isOn: $showInternalDevelopmentInspector)
            }

            Section {
                KeyValueTable(
                    items: $lspBinaries,
                    validKeys: LanguageIdentifier.allCases.map { $0.rawValue },
                    keyColumnName: String(localized: "developer_settings.language", comment: "Language label"),
                    valueColumnName: String(localized: "developer_settings.language_server_path", comment: "Language server path label"),
                    newItemInstruction: String(localized: "developer_settings.add_language_server", comment: "Button text for adding a language server")
                ) {
                    Text(String(localized: "developer_settings.add_language_server", comment: "Button text for adding a language server"))
                    Text(
                        String(localized: "developer_settings.lsp_path_instruction", comment: "Instruction text for specifying LSP binary path")
                    )
                } actionBarTrailing: {
                    EmptyView()
                }
                .frame(minHeight: 96)
            } header: {
                Text(String(localized: "developer_settings.lsp_binaries", comment: "LSP binaries section header"))
                Text(String(localized: "developer_settings.lsp_binaries_instruction", comment: "Instruction text for LSP binaries configuration"))
            }
        }
    }
}
