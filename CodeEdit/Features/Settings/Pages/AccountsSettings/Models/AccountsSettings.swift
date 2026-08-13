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
                String(localized: "autolocalized.accountssettings.accounts", defaultValue: "Accounts", comment: ""),
                String(localized: "autolocalized.accountssettings.delete-account", defaultValue: "Delete Account...", comment: ""),
                String(localized: "autolocalized.accountssettings.add-account", defaultValue: "Add Account...", comment: "")
            ]
            .enumerated()
            .map { index, key in
                switch index {
                case 0:
                    String(
                        localized: "settings.accounts.search.accounts",
                        defaultValue: key,
                        comment: "Search keyword for accounts settings page"
                    )
                case 1:
                    String(
                        localized: "settings.accounts.search.delete-account",
                        defaultValue: key,
                        comment: "Search keyword for delete account action"
                    )
                default:
                    String(
                        localized: "settings.accounts.search.add-account",
                        defaultValue: key,
                        comment: "Search keyword for add account action"
                    )
                }
            }
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
