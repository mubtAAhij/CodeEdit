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
                Toggle(String(localized: "settings.developer.show-internal-dev-inspector", defaultValue: "Show Internal Development Inspector", comment: "Toggle to show internal development inspector"), isOn: $showInternalDevelopmentInspector)
            }

            Section {
                KeyValueTable(
                    items: $lspBinaries,
                    validKeys: LanguageIdentifier.allCases.map { $0.rawValue },
                    keyColumnName: String(localized: "settings.developer.language-column", defaultValue: "Language", comment: "Column name for language in LSP binaries table"),
                    valueColumnName: String(localized: "settings.developer.path-column", defaultValue: "Language Server Path", comment: "Column name for language server path"),
                    newItemInstruction: String(localized: "settings.developer.add-lsp-instruction", defaultValue: "Add a language server", comment: "Instruction for adding a language server")
                ) {
                    Text(String(localized: "settings.developer.add-lsp-header", defaultValue: "Add a language server", comment: "Header text for adding a language server"))
                    Text(String(
                        localized: "settings.developer.add-lsp-description",
                        defaultValue: "Specify the absolute path to your LSP binary and its associated language.",
                        comment: "Description for adding a language server"
                    ))
                } actionBarTrailing: {
                    EmptyView()
                }
                .frame(minHeight: 96)
            } header: {
                Text(String(localized: "settings.developer.lsp-binaries-title", defaultValue: "LSP Binaries", comment: "Section title for LSP binaries"))
                Text(String(localized: "settings.developer.lsp-binaries-description", defaultValue: "Specify the language and the absolute path to the language server binary.", comment: "Description for LSP binaries section"))
            }
        }
    }
}
