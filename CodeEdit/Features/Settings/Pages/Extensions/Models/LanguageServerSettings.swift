//
//  LanguageServerSettings.swift
//  CodeEdit
//
//  Created by Abe Malla on 2/2/25.
//

import Foundation

extension SettingsData {
    struct LanguageServerSettings: Codable, Hashable, SearchableSettingsPage {

        /// The search keys
        var searchKeys: [String] {
            [
                String(localized: "settings.extensions.language-servers", defaultValue: "Language Servers", comment: "Settings section title for language servers"),
                String(localized: "settings.extensions.lsp-binaries", defaultValue: "LSP Binaries", comment: "Settings item title for language server binary paths"),
                String(localized: "settings.extensions.linters", defaultValue: "Linters", comment: "Settings item title for linter configuration"),
                String(localized: "settings.extensions.formatters", defaultValue: "Formatters", comment: "Settings item title for formatter configuration"),
                String(localized: "settings.extensions.debug-protocol", defaultValue: "Debug Protocol", comment: "Settings item title for debug protocol configuration"),
                String(localized: "settings.extensions.dap", defaultValue: "DAP", comment: "Settings item title for debug adapter protocol configuration"),
            ]
            .map { NSLocalizedString($0, comment: "") }
        }

        /// Stores the currently installed language servers. The key is the name of the language server.
        var installedLanguageServers: [String: InstalledLanguageServer] = [:]

        /// Default initializer
        init() {
            self.installedLanguageServers = [:]
        }

        /// Explicit decoder init for setting default values when key is not present in `JSON`
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.installedLanguageServers = try container.decodeIfPresent(
                [String: InstalledLanguageServer].self,
                forKey: .installedLanguageServers
            ) ?? [:]
        }
    }

    struct InstalledLanguageServer: Codable, Hashable {
        let packageName: String
        var isEnabled: Bool
        let version: String
    }
}
