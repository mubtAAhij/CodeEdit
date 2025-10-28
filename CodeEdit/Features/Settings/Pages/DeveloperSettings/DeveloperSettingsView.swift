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
                Toggle("developer.show_internal_inspector", comment: "Toggle to show internal development inspector", isOn: $showInternalDevelopmentInspector)
            }

            Section {
                KeyValueTable(
                    items: $lspBinaries,
                    validKeys: LanguageIdentifier.allCases.map { $0.rawValue },
                    keyColumnName: String(localized: "developer.lsp.language", comment: "Column name for language"),
                    valueColumnName: String(localized: "developer.lsp.server_path", comment: "Column name for language server path"),
                    newItemInstruction: String(localized: "developer.lsp.add_server", comment: "Instruction to add language server")
                ) {
                    Text("developer.lsp.add_server", comment: "Text to add language server")
                    Text(
                        "developer.lsp.add_server_description",
                        comment: "Description for adding language server"
                    )
                } actionBarTrailing: {
                    EmptyView()
                }
                .frame(minHeight: 96)
            } header: {
                Text("developer.lsp.binaries", comment: "Section header for LSP binaries")
                Text("developer.lsp.binaries_description", comment: "Description for LSP binaries section")
            }
        }
    }
}
