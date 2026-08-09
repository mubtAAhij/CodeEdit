//
//  DeveloperSettingsView.swift
//  CodeEdit
//
//  Created by Abe Malla on 5/16/24.
//

import LanguageServerProtocol
import SwiftUI

/// A view that implements the Developer settings section
struct DeveloperSettingsView: View {
    @AppSettings(\.developerSettings.lspBinaries)
    var lspBinaries

    @AppSettings(\.developerSettings.showInternalDevelopmentInspector)
    var showInternalDevelopmentInspector

    var body: some View {
        SettingsForm {
            Section {
                Toggle(String(localized: "settings.developer.show_internal_development_inspector", defaultValue: "Show Internal Development Inspector", comment: "Toggle label to show the internal development inspector"), isOn: $showInternalDevelopmentInspector)
            }

            Section {
                KeyValueTable(
                    items: $lspBinaries,
                    validKeys: LanguageIdentifier.allCases.map { $0.rawValue },
                    keyColumnName: String(localized: "settings.developer.language_server.language", defaultValue: "Language", comment: "Column header for language in language server configuration table"),
                    valueColumnName: String(localized: "settings.developer.language_server.path", defaultValue: "Language Server Path", comment: "Column header for language server binary path"),
                    newItemInstruction: String(localized: "settings.developer.language_server.add.title", defaultValue: "Add a language server", comment: "Title text for adding a language server entry")
                ) {
                    Text(String(localized: "settings.developer.language_server.add.button", defaultValue: "Add a language server", comment: "Button title to add a language server entry"))
                    Text(
                        String(localized: "settings.developer.language_server.add.description", defaultValue: "Specify the absolute path to your LSP binary and its associated language.", comment: "Description text explaining how to add a language server")
                    )
                } actionBarTrailing: {
                    EmptyView()
                }
                .frame(minHeight: 96)
            } header: {
                Text(String(localized: "settings.developer.lsp_binaries.title", defaultValue: "LSP Binaries", comment: "Section title for configured LSP binaries"))
                Text(String(localized: "settings.developer.lsp_binaries.description", defaultValue: "Specify the language and the absolute path to the language server binary.", comment: "Description text for LSP binaries section"))
            }
        }
    }
}
