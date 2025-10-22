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
                Toggle("Show Internal Development Inspector", isOn: $showInternalDevelopmentInspector, comment: "Toggle label")
            }

            Section {
                KeyValueTable(
                    items: $lspBinaries,
                    validKeys: LanguageIdentifier.allCases.map { $0.rawValue },
                    keyColumnName: String(localized: "Language", comment: "Column header"),
                    valueColumnName: String(localized: "Language Server Path", comment: "Column header"),
                    newItemInstruction: String(localized: "Add a language server", comment: "Instruction text")
                ) {
                    Text("Add a language server", comment: "Dialog title")
                    Text(
                        "Specify the absolute path to your LSP binary and its associated language.",
                        comment: "Dialog message"
                    )
                } actionBarTrailing: {
                    EmptyView()
                }
                .frame(minHeight: 96)
            } header: {
                Text("LSP Binaries", comment: "Section header")
                Text("Specify the language and the absolute path to the language server binary.", comment: "Section description")
            }
        }
    }
}
