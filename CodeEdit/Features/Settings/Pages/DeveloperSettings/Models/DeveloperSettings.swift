//
//  DeveloperSettings.swift
//  CodeEdit
//
//  Created by Abe Malla on 5/15/24.
//

import Foundation

extension SettingsData {
    struct DeveloperSettings: Codable, Hashable, SearchableSettingsPage {

        /// The search keys
        var searchKeys: [String] {
            [
                String(localized: "settings.developer.title", defaultValue: "Developer", comment: "Title for developer settings section"),
                String(localized: "settings.developer.language-server-protocol", defaultValue: "Language Server Protocol", comment: "Title for language server protocol settings"),
                String(localized: "settings.developer.lsp-binaries", defaultValue: "LSP Binaries", comment: "Title for language server binary paths settings"),
                String(localized: "settings.developer.show-internal-development-inspector", defaultValue: "Show Internal Development Inspector", comment: "Toggle title for showing internal development inspector")
            ]
            .map { NSLocalizedString($0, comment: "") }
        }

        /// A dictionary that stores a file type and a path to an LSP binary
        var lspBinaries: [String: String] = [:]

        /// Toggle for showing the internal development inspector
        var showInternalDevelopmentInspector: Bool = false

        /// Default initializer
        init() {}

        /// Explicit decoder init for setting default values when key is not present in `JSON`
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.lspBinaries = try container.decodeIfPresent(
                [String: String].self,
                forKey: .lspBinaries
            ) ?? [:]

            self.showInternalDevelopmentInspector = try container.decodeIfPresent(
                Bool.self,
                forKey: .showInternalDevelopmentInspector
            ) ?? false
        }
    }
}
