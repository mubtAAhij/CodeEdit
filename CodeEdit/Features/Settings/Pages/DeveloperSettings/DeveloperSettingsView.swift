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
                Toggle(String(localized: "settings.developer.show-inspector", defaultValue: "Show Internal Development Inspector", comment: "Toggle for showing internal development inspector"), isOn: $showInternalDevelopmentInspector)
            }

            Section {
                KeyValueTable(
                    items: $lspBinaries,
                    validKeys: LanguageIdentifier.allCases.map { $0.rawValue },
                    keyColumnName: String(localized: "settings.developer.language", defaultValue: "Language", comment: "Column name for language in LSP binaries table"),
                    valueColumnName: String(localized: "settings.developer.lsp-path", defaultValue: "Language Server Path", comment: "Column name for language server path"),
                    newItemInstruction: String(localized: "settings.developer.add-server-instruction", defaultValue: "Add a language server", comment: "Instruction for adding a language server")
                ) {
                    Text(String(localized: "settings.developer.add-server-header", defaultValue: "Add a language server", comment: "Header text for adding language server"))
                    Text(String(localized: "settings.developer.add-server-description", defaultValue: "Specify the absolute path to your LSP binary and its associated language.", comment: "Description for adding language server"))
                } actionBarTrailing: {
                    EmptyView()
                }
                .frame(minHeight: 96)
            } header: {
                Text(String(localized: "settings.developer.lsp-binaries-header", defaultValue: "LSP Binaries", comment: "Section header for LSP binaries"))
                Text(String(localized: "settings.developer.lsp-binaries-description", defaultValue: "Specify the language and the absolute path to the language server binary.", comment: "Description for LSP binaries section"))
            }
        }
    }
}
