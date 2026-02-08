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
                NSLocalizedString("settings.developer.title", comment: "Developer"),
                NSLocalizedString("settings.developer.language-server-protocol", comment: "Language Server Protocol"),
                NSLocalizedString("settings.developer.lsp-binaries", comment: "LSP Binaries"),
                NSLocalizedString("settings.developer.show-internal-inspector", comment: "Show Internal Development Inspector")
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
