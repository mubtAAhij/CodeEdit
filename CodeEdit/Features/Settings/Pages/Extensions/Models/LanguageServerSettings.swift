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
                String(localized: "settings.lsp.binaries", defaultValue: "LSP Binaries", comment: "LSP binaries label"),
                String(localized: "settings.lsp.linters", defaultValue: "Linters", comment: "Linters label"),
                String(localized: "settings.lsp.formatters", defaultValue: "Formatters", comment: "Formatters label"),
                String(localized: "settings.lsp.debug-protocol", defaultValue: "Debug Protocol", comment: "Debug protocol label"),
                "DAP",
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
