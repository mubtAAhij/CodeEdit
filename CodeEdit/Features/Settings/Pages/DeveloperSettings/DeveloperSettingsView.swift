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
                Toggle(String(localized: "settings.developer.show-internal-development-inspector", defaultValue: "Show Internal Development Inspector", comment: "Toggle label to show the internal development inspector."), isOn: $showInternalDevelopmentInspector)
            }

            Section {
                KeyValueTable(
                    items: $lspBinaries,
                    validKeys: LanguageIdentifier.allCases.map { $0.rawValue },
                    keyColumnName: String(localized: "settings.developer.language-server.language-column-title", defaultValue: "Language", comment: "Column title for language in language server list."),
                    valueColumnName: String(localized: "settings.developer.language-server.path-column-title", defaultValue: "Language Server Path", comment: "Column title for language server binary path."),
                    newItemInstruction: String(localized: "settings.developer.language-server.add.button-label", defaultValue: "Add a language server", comment: "Button label to add a new language server entry.")
                ) {
                    Text(String(localized: "settings.developer.language-server.add.sheet-title", defaultValue: "Add a language server", comment: "Sheet title for adding a language server."))
                    Text(
                        String(localized: "settings.developer.language-server.add.sheet-message", defaultValue: "Specify the absolute path to your LSP binary and its associated language.", comment: "Helper text describing language server path requirements.")
                    )
                } actionBarTrailing: {
                    EmptyView()
                }
                .frame(minHeight: 96)
            } header: {
                Text(String(localized: "settings.developer.language-server.section-title", defaultValue: "LSP Binaries", comment: "Section title listing configured LSP binaries."))
                Text(String(localized: "settings.developer.language-server.section-description", defaultValue: "Specify the language and the absolute path to the language server binary.", comment: "Section description for configured language server binaries."))
            }
        }
    }
}
