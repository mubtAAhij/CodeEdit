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
                Toggle(String(localized: "settings.developer.show-internal-development-inspector", defaultValue: "Show Internal Development Inspector", comment: "Toggle label to show internal development inspector"), isOn: $showInternalDevelopmentInspector)
            }

            Section {
                KeyValueTable(
                    items: $lspBinaries,
                    validKeys: LanguageIdentifier.allCases.map { $0.rawValue },
                    keyColumnName: String(localized: "settings.developer.language", defaultValue: "Language", comment: "Field label for language selection in developer settings"),
                    valueColumnName: String(localized: "settings.developer.language-server-path", defaultValue: "Language Server Path", comment: "Field label for language server executable path"),
                    newItemInstruction: String(localized: "settings.developer.add-language-server.title", defaultValue: "Add a language server", comment: "Title for add language server section or dialog")
                ) {
                    Text(String(localized: "settings.developer.add-language-server.action", defaultValue: "Add a language server", comment: "Button title to add a language server"))
                    Text(
                        String(localized: "settings.developer.add-language-server.description", defaultValue: "Specify the absolute path to your LSP binary and its associated language.", comment: "Help text explaining how to add a language server")
                    )
                } actionBarTrailing: {
                    EmptyView()
                }
                .frame(minHeight: 96)
            } header: {
                Text(String(localized: "settings.developer.lsp-binaries", defaultValue: "LSP Binaries", comment: "Section title listing configured LSP binaries"))
                Text(String(localized: "settings.developer.lsp-binaries.description", defaultValue: "Specify the language and the absolute path to the language server binary.", comment: "Help text for configuring language and binary path for LSP entries"))
            }
        }
    }
}
