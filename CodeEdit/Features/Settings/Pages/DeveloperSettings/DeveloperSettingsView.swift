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
                Toggle(String(localized: "developer.show-internal-inspector", defaultValue: "Show Internal Development Inspector", comment: "Show internal development inspector toggle"), isOn: $showInternalDevelopmentInspector)
            }

            Section {
                KeyValueTable(
                    items: $lspBinaries,
                    validKeys: LanguageIdentifier.allCases.map { $0.rawValue },
                    keyColumnName: String(localized: "developer.language", defaultValue: "Language", comment: "Language column name"),
                    valueColumnName: String(localized: "developer.language-server-path", defaultValue: "Language Server Path", comment: "Language server path column name"),
                    newItemInstruction: String(localized: "developer.add-language-server-instruction", defaultValue: "Add a language server", comment: "Add language server instruction")
                ) {
                    Text(String(localized: "developer.add-language-server", defaultValue: "Add a language server", comment: "Add language server header"))
                    Text(String(localized: "developer.lsp-binary-instruction", defaultValue: "Specify the absolute path to your LSP binary and its associated language.", comment: "LSP binary instruction"))
                } actionBarTrailing: {
                    EmptyView()
                }
                .frame(minHeight: 96)
            } header: {
                Text(String(localized: "developer.lsp-binaries", defaultValue: "LSP Binaries", comment: "LSP binaries section header"))
                Text(String(localized: "developer.lsp-binaries-description", defaultValue: "Specify the language and the absolute path to the language server binary.", comment: "LSP binaries description"))
            }
        }
    }
}
