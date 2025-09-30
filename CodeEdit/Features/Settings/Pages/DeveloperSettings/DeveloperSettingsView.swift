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
                Toggle(String(localized: "show_internal_development_inspector", comment: "Toggle to show internal development inspector"), isOn: $showInternalDevelopmentInspector)
            }

            Section {
                KeyValueTable(
                    items: $lspBinaries,
                    validKeys: LanguageIdentifier.allCases.map { $0.rawValue },
                    keyColumnName: String(localized: "language", comment: "Column header for programming language"),
                    valueColumnName: String(localized: "language_server_path", comment: "Column header for language server binary path"),
                    newItemInstruction: String(localized: "add_language_server", comment: "Instruction for adding a language server")
                ) {
                    Text(String(localized: "add_language_server", comment: "Instruction for adding a language server"))
                    Text(
                        String(localized: "specify_lsp_binary_path", comment: "Description for LSP binary path specification")
                    )
                } actionBarTrailing: {
                    EmptyView()
                }
                .frame(minHeight: 96)
            } header: {
                Text(String(localized: "lsp_binaries", comment: "Section header for LSP binaries settings"))
                Text(String(localized: "specify_language_binary_path", comment: "Description for language server binary configuration"))
            }
        }
    }
}
