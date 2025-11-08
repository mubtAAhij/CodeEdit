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
                String(localized: "settings.developer.title", defaultValue: "Developer", comment: "Developer settings search key"),
                String(localized: "settings.developer.lsp", defaultValue: "Language Server Protocol", comment: "Language Server Protocol settings search key"),
                String(localized: "settings.developer.lsp-binaries", defaultValue: "LSP Binaries", comment: "LSP Binaries settings search key"),
                String(localized: "settings.developer.show-inspector", defaultValue: "Show Internal Development Inspector", comment: "Show Internal Development Inspector settings search key")
            ]
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
