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
                Toggle(String(localized: "show_internal_development_inspector", comment: "Toggle to show/hide internal development inspector"), isOn: $showInternalDevelopmentInspector)
            }

            Section {
                KeyValueTable(
                    items: $lspBinaries,
                    validKeys: LanguageIdentifier.allCases.map { $0.rawValue },
                    keyColumnName: String(localized: "language", comment: "Column header for programming language"),
                    valueColumnName: String(localized: "language_server_path", comment: "Column header for language server binary path"),
                    newItemInstruction: String(localized: "add_language_server", comment: "Instruction text for adding new language server")
                ) {
                    Text(String(localized: "add_language_server", comment: "Button text for adding new language server"))
                    Text(
                        String(localized: "specify_lsp_path_instruction", comment: "Instruction text explaining how to specify LSP binary path")
                    )
                } actionBarTrailing: {
                    EmptyView()
                }
                .frame(minHeight: 96)
            } header: {
                Text(String(localized: "lsp_binaries", comment: "Section header for language server protocol binaries"))
                Text(String(localized: "specify_language_and_path_instruction", comment: "Section description for language server configuration"))
            }
        }
    }
}
