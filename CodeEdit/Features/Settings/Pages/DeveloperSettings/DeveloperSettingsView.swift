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
                Toggle(String(localized: "settings.developer.show-internal-inspector", defaultValue: "Show Internal Development Inspector", comment: "Toggle for showing internal development inspector"), isOn: $showInternalDevelopmentInspector)
            }

            Section {
                KeyValueTable(
                    items: $lspBinaries,
                    validKeys: LanguageIdentifier.allCases.map { $0.rawValue },
                    keyColumnName: String(localized: "settings.developer.lsp-table.language", defaultValue: "Language", comment: "Language column header in LSP binaries table"),
                    valueColumnName: String(localized: "settings.developer.lsp-table.path", defaultValue: "Language Server Path", comment: "Path column header in LSP binaries table"),
                    newItemInstruction: String(localized: "settings.developer.lsp-table.add-server", defaultValue: "Add a language server", comment: "Instruction to add a new language server")
                ) {
                    Text(String(localized: "settings.developer.lsp-table.add-server", defaultValue: "Add a language server", comment: "Instruction to add a new language server"))
                    Text(
                        String(localized: "settings.developer.lsp-table.instruction", defaultValue: "Specify the absolute path to your LSP binary and its associated language.", comment: "Instruction for specifying LSP binary path")
                    )
                } actionBarTrailing: {
                    EmptyView()
                }
                .frame(minHeight: 96)
            } header: {
                Text(String(localized: "settings.developer.lsp-binaries", defaultValue: "LSP Binaries", comment: "LSP Binaries section header"))
                Text(String(localized: "settings.developer.lsp-binaries.description", defaultValue: "Specify the language and the absolute path to the language server binary.", comment: "LSP Binaries section description"))
            }
        }
    }
}
