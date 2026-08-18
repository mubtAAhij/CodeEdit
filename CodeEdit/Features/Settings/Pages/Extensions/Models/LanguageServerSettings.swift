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
                String(
                    localized: "settings.extensions.language-servers.title",
                    defaultValue: "Language Servers",
                    comment: "Settings page title for language server configuration"
                ),
                String(
                    localized: "settings.extensions.language-servers.lsp-binaries",
                    defaultValue: "LSP Binaries",
                    comment: "Settings row title for language server binaries"
                ),
                String(
                    localized: "settings.extensions.language-servers.linters",
                    defaultValue: "Linters",
                    comment: "Settings row title for linter integrations"
                ),
                String(
                    localized: "settings.extensions.language-servers.formatters",
                    defaultValue: "Formatters",
                    comment: "Settings row title for formatter integrations"
                ),
                String(
                    localized: "settings.extensions.language-servers.debug-protocol",
                    defaultValue: "Debug Protocol",
                    comment: "Settings row title for debug protocol configuration"
                ),
                String(
                    localized: "settings.extensions.language-servers.dap",
                    defaultValue: "DAP",
                    comment: "Settings row title for debug adapter protocol settings"
                ),
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
