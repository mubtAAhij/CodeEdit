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
                String(localized: "settings.developer", comment: "Developer settings search key"),
                String(localized: "settings.language_server_protocol", comment: "Language Server Protocol search key"),
                String(localized: "settings.lsp_binaries", comment: "LSP Binaries search key"),
                String(localized: "settings.show_internal_development_inspector", comment: "Show Internal Development Inspector search key")
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
