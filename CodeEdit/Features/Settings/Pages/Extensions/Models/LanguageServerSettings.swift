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
                "Language Servers",
                String(localized: "lsp.lsp-binaries", defaultValue: "LSP Binaries", comment: "Language server settings search key"),
                String(localized: "lsp.linters", defaultValue: "Linters", comment: "Language server settings search key"),
                String(localized: "lsp.formatters", defaultValue: "Formatters", comment: "Language server settings search key"),
                String(localized: "lsp.debug-protocol", defaultValue: "Debug Protocol", comment: "Language server settings search key"),
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
