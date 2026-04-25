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
                String(localized: "settings.language-servers.search-key.language-servers", defaultValue: "Language Servers", comment: "Search key for language servers"),
                String(localized: "settings.language-servers.search-key.lsp-binaries", defaultValue: "LSP Binaries", comment: "Search key for LSP binaries"),
                String(localized: "settings.language-servers.search-key.linters", defaultValue: "Linters", comment: "Search key for linters"),
                String(localized: "settings.language-servers.search-key.formatters", defaultValue: "Formatters", comment: "Search key for formatters"),
                String(localized: "settings.language-servers.search-key.debug-protocol", defaultValue: "Debug Protocol", comment: "Search key for debug protocol"),
                "DAP",
            ]
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
