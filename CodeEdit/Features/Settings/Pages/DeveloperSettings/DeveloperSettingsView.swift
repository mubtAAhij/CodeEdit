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
                Toggle(String(localized: "developer-settings.show-internal-inspector", defaultValue: "Show Internal Development Inspector", comment: "Toggle label for showing internal development inspector"), isOn: $showInternalDevelopmentInspector)
            }

            Section {
                KeyValueTable(
                    items: $lspBinaries,
                    validKeys: LanguageIdentifier.allCases.map { $0.rawValue },
                    keyColumnName: String(localized: "developer-settings.lsp.language", defaultValue: "Language", comment: "Column name for language in LSP table"),
                    valueColumnName: String(localized: "developer-settings.lsp.server-path", defaultValue: "Language Server Path", comment: "Column name for language server path in LSP table"),
                    newItemInstruction: String(localized: "developer-settings.lsp.add-server", defaultValue: "Add a language server", comment: "Instruction for adding a new language server")
                ) {
                    Text(String(localized: "developer-settings.lsp.add-server", defaultValue: "Add a language server", comment: "Instruction for adding a new language server"))
                    Text(
                        String(localized: "developer-settings.lsp.add-server-description", defaultValue: "Specify the absolute path to your LSP binary and its associated language.", comment: "Description for adding a language server")
                    )
                } actionBarTrailing: {
                    EmptyView()
                }
                .frame(minHeight: 96)
            } header: {
                Text(String(localized: "developer-settings.lsp.header", defaultValue: "LSP Binaries", comment: "Section header for LSP binaries"))
                Text(String(localized: "developer-settings.lsp.header-description", defaultValue: "Specify the language and the absolute path to the language server binary.", comment: "Section header description for LSP binaries"))
            }
        }
    }
}
