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
                Toggle(String(localized: "settings.developer.inspector", defaultValue: "Show Internal Development Inspector", comment: "Show Internal Development Inspector toggle"), isOn: $showInternalDevelopmentInspector)
            }

            Section {
                KeyValueTable(
                    items: $lspBinaries,
                    validKeys: LanguageIdentifier.allCases.map { $0.rawValue },
                    keyColumnName: String(localized: "settings.developer.language", defaultValue: "Language", comment: "Language column name"),
                    valueColumnName: String(localized: "settings.developer.lsp.path", defaultValue: "Language Server Path", comment: "Language Server Path column name"),
                    newItemInstruction: String(localized: "settings.developer.add.lsp.instruction", defaultValue: "Add a language server", comment: "Add a language server instruction")
                ) {
                    Text(String(localized: "settings.developer.add.lsp.header", defaultValue: "Add a language server", comment: "Add a language server header"))
                    Text(
                        String(localized: "settings.developer.add.lsp.description", defaultValue: "Specify the absolute path to your LSP binary and its associated language.", comment: "Add a language server description")
                    )
                } actionBarTrailing: {
                    EmptyView()
                }
                .frame(minHeight: 96)
            } header: {
                Text(String(localized: "settings.developer.lsp.binaries", defaultValue: "LSP Binaries", comment: "LSP Binaries section header"))
                Text(String(localized: "settings.developer.lsp.binaries.description", defaultValue: "Specify the language and the absolute path to the language server binary.", comment: "LSP Binaries section description"))
            }
        }
    }
}
