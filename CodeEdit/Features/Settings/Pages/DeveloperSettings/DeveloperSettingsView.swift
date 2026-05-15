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
                Toggle(String(localized: "settings.developer.show-internal-inspector", defaultValue: "Show Internal Development Inspector", comment: "Toggle to show internal development inspector"), isOn: $showInternalDevelopmentInspector)
            }

            Section {
                KeyValueTable(
                    items: $lspBinaries,
                    validKeys: LanguageIdentifier.allCases.map { $0.rawValue },
                    keyColumnName: String(localized: "settings.developer.lsp.language", defaultValue: "Language", comment: "Language column name"),
                    valueColumnName: String(localized: "settings.developer.lsp.path", defaultValue: "Language Server Path", comment: "Language server path column name"),
                    newItemInstruction: String(localized: "settings.developer.lsp.add-server", defaultValue: "Add a language server", comment: "New item instruction for LSP binary")
                ) {
                    Text(String(localized: "settings.developer.lsp.add-server-title", defaultValue: "Add a language server", comment: "Title for adding language server"))
                    Text(
                        String(localized: "settings.developer.lsp.add-server-description", defaultValue: "Specify the absolute path to your LSP binary and its associated language.", comment: "Description for adding language server")
                    )
                } actionBarTrailing: {
                    EmptyView()
                }
                .frame(minHeight: 96)
            } header: {
                Text(String(localized: "settings.developer.lsp.header", defaultValue: "LSP Binaries", comment: "LSP Binaries section header"))
                Text(String(localized: "settings.developer.lsp.header-description", defaultValue: "Specify the language and the absolute path to the language server binary.", comment: "LSP Binaries section description"))
            }
        }
    }
}
