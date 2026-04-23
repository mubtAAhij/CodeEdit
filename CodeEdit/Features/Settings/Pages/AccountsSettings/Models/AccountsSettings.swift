//
//  AccountsPreferences.swift
//  CodeEditModules/Settings
//
//  Created by Nanashi Li on 2022/04/08.
//

import Foundation

extension SettingsData {

    /// The global settings for source control accounts
    struct AccountsSettings: Codable, Hashable, SearchableSettingsPage {
        /// The list of git accounts the user has saved
        var sourceControlAccounts: GitAccounts = .init()

        /// The search keys
        var searchKeys: [String] {
            [
                String(localized: "accounts-settings.accounts", defaultValue: "Accounts", comment: "Accounts search key"),
                String(localized: "accounts-settings.delete-account", defaultValue: "Delete Account...", comment: "Delete account search key"),
                String(localized: "accounts-settings.add-account", defaultValue: "Add Account...", comment: "Add account search key")
            ]
        }

        /// Default initializer
        init() {}

        /// Explicit decoder init for setting default values when key is not present in `JSON`
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.sourceControlAccounts = try container.decodeIfPresent(
                GitAccounts.self,
                forKey: .sourceControlAccounts
            ) ?? .init()
        }
    }

    struct GitAccounts: Codable, Hashable {
        /// This id will store the account name as the identifiable
        var gitAccounts: [SourceControlAccount] = []

        var sshKey: String = ""
        /// Default initializer
        init() {}
        /// Explicit decoder init for setting default values when key is not present in `JSON`
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.gitAccounts = try container.decodeIfPresent([SourceControlAccount].self, forKey: .gitAccounts) ?? []
            self.sshKey = try container.decodeIfPresent(String.self, forKey: .sshKey) ?? ""
        }
    }
}
