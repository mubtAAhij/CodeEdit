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
                    keyColumnName: String(localized: "settings.developer.language-column", defaultValue: "Language", comment: "Column name for programming language"),
                    valueColumnName: String(localized: "settings.developer.lsp-path-column", defaultValue: "Language Server Path", comment: "Column name for language server path"),
                    newItemInstruction: String(localized: "settings.developer.add-lsp-instruction", defaultValue: "Add a language server", comment: "Instruction to add a language server")
                ) {
                    Text(String(localized: "settings.developer.add-lsp-title", defaultValue: "Add a language server", comment: "Title for adding a language server"))
                    Text(
                        String(localized: "settings.developer.add-lsp-description", defaultValue: "Specify the absolute path to your LSP binary and its associated language.", comment: "Description for adding a language server")
                    )
                } actionBarTrailing: {
                    EmptyView()
                }
                .frame(minHeight: 96)
            } header: {
                Text(String(localized: "settings.developer.lsp-binaries-header", defaultValue: "LSP Binaries", comment: "Header for LSP binaries section"))
                Text(String(localized: "settings.developer.lsp-binaries-description", defaultValue: "Specify the language and the absolute path to the language server binary.", comment: "Description for LSP binaries section"))
            }
        }
    }
}
