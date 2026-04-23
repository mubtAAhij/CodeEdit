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
                Toggle(String(localized: "developer-settings.show-inspector", defaultValue: "Show Internal Development Inspector", comment: "Toggle for internal development inspector"), isOn: $showInternalDevelopmentInspector)
            }

            Section {
                KeyValueTable(
                    items: $lspBinaries,
                    validKeys: LanguageIdentifier.allCases.map { $0.rawValue },
                    keyColumnName: String(localized: "developer-settings.column.language", defaultValue: "Language", comment: "Language column header"),
                    valueColumnName: String(localized: "developer-settings.column.lsp-path", defaultValue: "Language Server Path", comment: "Language server path column header"),
                    newItemInstruction: String(localized: "developer-settings.add-lsp-instruction", defaultValue: "Add a language server", comment: "Instruction for adding a new language server")
                ) {
                    Text(String(localized: "developer-settings.add-lsp-title", defaultValue: "Add a language server", comment: "Title for adding a new language server"))
                    Text(String(localized: "developer-settings.add-lsp-description", defaultValue: "Specify the absolute path to your LSP binary and its associated language.", comment: "Description for adding a new language server"))
                } actionBarTrailing: {
                    EmptyView()
                }
                .frame(minHeight: 96)
            } header: {
                Text(String(localized: "developer-settings.lsp-binaries", defaultValue: "LSP Binaries", comment: "LSP binaries section header"))
                Text(String(localized: "developer-settings.lsp-binaries-description", defaultValue: "Specify the language and the absolute path to the language server binary.", comment: "LSP binaries section description"))
            }
        }
    }
}
