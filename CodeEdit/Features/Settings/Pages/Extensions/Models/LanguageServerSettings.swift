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
                String(localized: "settings.language_servers.search.language_servers", defaultValue: "Language Servers", comment: "Language servers search key"),
                String(localized: "settings.language_servers.search.lsp_binaries", defaultValue: "LSP Binaries", comment: "LSP binaries search key"),
                String(localized: "settings.language_servers.search.linters", defaultValue: "Linters", comment: "Linters search key"),
                String(localized: "settings.language_servers.search.formatters", defaultValue: "Formatters", comment: "Formatters search key"),
                String(localized: "settings.language_servers.search.debug_protocol", defaultValue: "Debug Protocol", comment: "Debug protocol search key"),
                String(localized: "settings.language_servers.search.dap", defaultValue: "DAP", comment: "DAP search key"),
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
