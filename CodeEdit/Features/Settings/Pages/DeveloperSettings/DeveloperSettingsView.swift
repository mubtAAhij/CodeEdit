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
                Toggle(String(localized: "settings.developer.show_internal_inspector", defaultValue: "Show Internal Development Inspector", comment: "Show internal development inspector toggle"), isOn: $showInternalDevelopmentInspector)
            }

            Section {
                KeyValueTable(
                    items: $lspBinaries,
                    validKeys: LanguageIdentifier.allCases.map { $0.rawValue },
                    keyColumnName: String(localized: "settings.developer.language", defaultValue: "Language", comment: "Language column name"),
                    valueColumnName: String(localized: "settings.developer.lsp_path", defaultValue: "Language Server Path", comment: "Language server path column name"),
                    newItemInstruction: String(localized: "settings.developer.add_lsp", defaultValue: "Add a language server", comment: "Add language server instruction")
                ) {
                    Text(String(localized: "settings.developer.add_lsp_header", defaultValue: "Add a language server", comment: "Add language server header"))
                    Text(
                        String(localized: "settings.developer.lsp_instruction", defaultValue: "Specify the absolute path to your LSP binary and its associated language.", comment: "LSP binary instruction")
                    )
                } actionBarTrailing: {
                    EmptyView()
                }
                .frame(minHeight: 96)
            } header: {
                Text(String(localized: "settings.developer.lsp_binaries", defaultValue: "LSP Binaries", comment: "LSP binaries section header"))
                Text(String(localized: "settings.developer.lsp_binaries_desc", defaultValue: "Specify the language and the absolute path to the language server binary.", comment: "LSP binaries description"))
            }
        }
    }
}
