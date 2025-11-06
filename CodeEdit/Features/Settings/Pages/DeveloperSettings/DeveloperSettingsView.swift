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
                    keyColumnName: String(localized: "settings.developer.language", defaultValue: "Language", comment: "Language field label for LSP"),
                    valueColumnName: String(localized: "settings.developer.lsp-path", defaultValue: "Language Server Path", comment: "Language server path field label"),
                    newItemInstruction: String(localized: "settings.developer.add-lsp", defaultValue: "Add a language server", comment: "Placeholder for language field")
                ) {
                    Text(String(localized: "settings.developer.add-lsp", defaultValue: "Add a language server", comment: "Placeholder for language field"))
                    Text(
                        String(localized: "settings.developer.lsp-path-description", defaultValue: "Specify the absolute path to your LSP binary and its associated language.", comment: "Description for LSP path field")
                    )
                } actionBarTrailing: {
                    EmptyView()
                }
                .frame(minHeight: 96)
            } header: {
                Text(String(localized: "settings.developer.lsp-binaries", defaultValue: "LSP Binaries", comment: "LSP binaries settings label"))
                Text(String(localized: "settings.developer.lsp-binaries-description", defaultValue: "Specify the language and the absolute path to the language server binary.", comment: "Description for LSP binaries section"))
            }
        }
    }
}
