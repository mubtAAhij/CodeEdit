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
                Toggle(String(localized: "settings.developer.inspector.toggle", defaultValue: "Show Internal Development Inspector", comment: "Toggle for internal development inspector"), isOn: $showInternalDevelopmentInspector)
            }

            Section {
                KeyValueTable(
                    items: $lspBinaries,
                    validKeys: LanguageIdentifier.allCases.map { $0.rawValue },
                    keyColumnName: String(localized: "settings.developer.lsp.column.language", defaultValue: "Language", comment: "Language column header"),
                    valueColumnName: String(localized: "settings.developer.lsp.column.path", defaultValue: "Language Server Path", comment: "Language server path column header"),
                    newItemInstruction: String(localized: "settings.developer.lsp.add-instruction", defaultValue: "Add a language server", comment: "Instruction for adding a language server")
                ) {
                    Text(String(localized: "settings.developer.lsp.add-header", defaultValue: "Add a language server", comment: "Header for add language server section"))
                    Text(String(localized: "settings.developer.lsp.add-description", defaultValue: "Specify the absolute path to your LSP binary and its associated language.", comment: "Description for adding a language server"))
                } actionBarTrailing: {
                    EmptyView()
                }
                .frame(minHeight: 96)
            } header: {
                Text(String(localized: "settings.developer.lsp.section-title", defaultValue: "LSP Binaries", comment: "LSP binaries section title"))
                Text(String(localized: "settings.developer.lsp.section-description", defaultValue: "Specify the language and the absolute path to the language server binary.", comment: "LSP binaries section description"))
            }
        }
    }
}
