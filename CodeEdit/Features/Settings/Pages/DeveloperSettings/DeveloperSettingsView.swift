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
                Toggle(String(localized: "Show Internal Development Inspector", comment: "Toggle to show internal development inspector"), isOn: $showInternalDevelopmentInspector)
            }

            Section {
                KeyValueTable(
                    items: $lspBinaries,
                    validKeys: LanguageIdentifier.allCases.map { $0.rawValue },
                    keyColumnName: String(localized: "Language", comment: "Column name for language"),
                    valueColumnName: String(localized: "Language Server Path", comment: "Column name for language server path"),
                    newItemInstruction: String(localized: "Add a language server", comment: "Instruction to add a language server")
                ) {
                    Text(String(localized: "Add a language server", comment: "Header text to add a language server"))
                    Text(
                        String(localized: "Specify the absolute path to your LSP binary and its associated language.", comment: "Description text for adding a language server")
                    )
                } actionBarTrailing: {
                    EmptyView()
                }
                .frame(minHeight: 96)
            } header: {
                Text(String(localized: "LSP Binaries", comment: "Section header for LSP binaries"))
                Text(String(localized: "Specify the language and the absolute path to the language server binary.", comment: "Section description for LSP binaries"))
            }
        }
    }
}
