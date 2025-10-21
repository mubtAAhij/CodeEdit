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
                Toggle(String(localized: "developerSettings.showInternalDevelopmentInspector", comment: "Toggle label"), isOn: $showInternalDevelopmentInspector)
            }

            Section {
                KeyValueTable(
                    items: $lspBinaries,
                    validKeys: LanguageIdentifier.allCases.map { $0.rawValue },
                    keyColumnName: String(localized: "developerSettings.language", comment: "Column name"),
                    valueColumnName: String(localized: "developerSettings.languageServerPath", comment: "Column name"),
                    newItemInstruction: String(localized: "developerSettings.addLanguageServer", comment: "Placeholder text")
                ) {
                    Text(String(localized: "developerSettings.addLanguageServerTitle", comment: "Title text"))
                    Text(
                        String(localized: "developerSettings.addLanguageServerDescription", comment: "Description text")
                    )
                } actionBarTrailing: {
                    EmptyView()
                }
                .frame(minHeight: 96)
            } header: {
                Text(String(localized: "developerSettings.lspBinariesHeader", comment: "Section header"))
                Text(String(localized: "developerSettings.lspBinariesDescription", comment: "Description text"))
            }
        }
    }
}
