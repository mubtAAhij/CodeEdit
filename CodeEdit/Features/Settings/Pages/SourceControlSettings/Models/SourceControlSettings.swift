//
//  SourceControlPreferences.swift
//  CodeEditModules/Settings
//
//  Created by Nanashi Li on 2022/04/08.
//

import Foundation

extension SettingsData {
    /// The global settings for source control
    struct SourceControlSettings: Codable, Hashable, SearchableSettingsPage {

        var searchKeys: [String] {
            [
                String(localized: "settings.source-control.search-key.general", defaultValue: "General", comment: "Search key for general section"),
                String(localized: "settings.source-control.search-key.enable", defaultValue: "Enable source control", comment: "Search key for enable source control"),
                String(localized: "settings.source-control.search-key.refresh-local", defaultValue: "Refresh local status automatically", comment: "Search key for refresh local status"),
                String(localized: "settings.source-control.search-key.fetch-server", defaultValue: "Fetch and refresh server status automatically", comment: "Search key for fetch server status"),
                String(localized: "settings.source-control.search-key.add-remove", defaultValue: "Add and remove files automatically", comment: "Search key for add remove files"),
                String(localized: "settings.source-control.search-key.select-files", defaultValue: "Select files to commit automatically", comment: "Search key for select files to commit"),
                String(localized: "settings.source-control.search-key.show-changes", defaultValue: "Show source control changes", comment: "Search key for show changes"),
                String(localized: "settings.source-control.search-key.include-upstream", defaultValue: "Include upstream changes", comment: "Search key for include upstream changes"),
                String(localized: "settings.source-control.search-key.comparison-view", defaultValue: "Comparison view", comment: "Search key for comparison view"),
                String(localized: "settings.source-control.search-key.navigator", defaultValue: "Source control navigator", comment: "Search key for source control navigator"),
                String(localized: "settings.source-control.search-key.default-branch", defaultValue: "Default branch name", comment: "Search key for default branch name"),
                String(localized: "settings.source-control.search-key.git", defaultValue: "Git", comment: "Search key for git section"),
                String(localized: "settings.source-control.search-key.author-name", defaultValue: "Author Name", comment: "Search key for author name"),
                String(localized: "settings.source-control.search-key.author-email", defaultValue: "Author Email", comment: "Search key for author email"),
                String(localized: "settings.source-control.search-key.prefer-rebase", defaultValue: "Prefer to rebase when pulling", comment: "Search key for prefer rebase"),
                String(localized: "settings.source-control.search-key.show-merge-commits", defaultValue: "Show merge commits in per-file log", comment: "Search key for show merge commits")
            ]
        }

        /// The general source control settings
        var general: SourceControlGeneral = .init()

        /// The source control git settings
        var git: SourceControlGit = .init()

        /// Default initializer
        init() {}

        /// Explicit decoder init for setting default values when key is not present in `JSON`
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.general = try container.decodeIfPresent(SourceControlGeneral.self, forKey: .general) ?? .init()
            self.git = try container.decodeIfPresent(SourceControlGit.self, forKey: .git) ?? .init()
        }
    }

    struct SourceControlGeneral: Codable, Hashable {
        /// Indicates whether or not the source control is active
        var sourceControlIsEnabled: Bool = true
        /// Indicates whether the status should be refreshed locally without fetching updates from the server.
        var refreshStatusLocally: Bool = true
        /// Indicates whether the application should automatically fetch updates from the server and refresh the status.
        var fetchRefreshServerStatus: Bool = true
        /// Indicates whether new and deleted files should be automatically staged for commit.
        var addRemoveAutomatically: Bool = true
        /// Indicates whether the application should automatically select files to commit.
        var selectFilesToCommit: Bool = true
        /// Indicates whether or not to show the source control changes
        var showSourceControlChanges: Bool = true
        /// Indicates whether or not we should include the upstream
        var includeUpstreamChanges: Bool = true
        /// Indicates whether or not we should open the reported feedback in the browser
        var openFeedbackInBrowser: Bool = true
        /// The selected value of the comparison view
        var revisionComparisonLayout: RevisionComparisonLayout = .localLeft
        /// The selected value of the control navigator
        var controlNavigatorOrder: ControlNavigatorOrder = .sortByName
        /// Default initializer
        init() {}
        /// Explicit decoder init for setting default values when key is not present in `JSON`
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.sourceControlIsEnabled = try container.decodeIfPresent(
                Bool.self,
                forKey: .sourceControlIsEnabled
            ) ?? true
            self.refreshStatusLocally = try container.decodeIfPresent(Bool.self, forKey: .refreshStatusLocally) ?? true
            self.fetchRefreshServerStatus = try container.decodeIfPresent(
                Bool.self,
                forKey: .fetchRefreshServerStatus
            ) ?? true
            self.addRemoveAutomatically = try container.decodeIfPresent(
                Bool.self,
                forKey: .addRemoveAutomatically
            ) ?? true
            self.selectFilesToCommit = try container.decodeIfPresent(Bool.self, forKey: .selectFilesToCommit) ?? true
            self.showSourceControlChanges = try container.decodeIfPresent(
                Bool.self,
                forKey: .showSourceControlChanges
            ) ?? true
            self.includeUpstreamChanges = try container.decodeIfPresent(
                Bool.self,
                forKey: .includeUpstreamChanges
            ) ?? true
            self.openFeedbackInBrowser = try container.decodeIfPresent(
                Bool.self,
                forKey: .openFeedbackInBrowser
            ) ?? true
            self.revisionComparisonLayout = try container.decodeIfPresent(
                RevisionComparisonLayout.self,
                forKey: .revisionComparisonLayout
            ) ?? .localLeft
            self.controlNavigatorOrder = try container.decodeIfPresent(
                ControlNavigatorOrder.self,
                forKey: .controlNavigatorOrder
            ) ?? .sortByName
        }
    }

    /// The style for comparison View
    /// - **localLeft**: Local Revision on Left Side
    /// - **localRight**: Local Revision on Right Side
    enum RevisionComparisonLayout: String, Codable {
        case localLeft
        case localRight
    }

    /// The style for control Navigator
    /// - **sortName**: They are sorted by Name
    /// - **sortDate**: They are sorted by Date
    enum ControlNavigatorOrder: String, Codable {
        case sortByName
        case sortByDate
    }

    struct SourceControlGit: Codable, Hashable {
        /// Indicates whether we should rebase when pulling commits
        var showMergeCommitsPerFileLog: Bool = false
        /// Default initializer
        init() {}
        /// Explicit decoder init for setting default values when key is not present in `JSON`
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.showMergeCommitsPerFileLog = try container.decodeIfPresent(
                Bool.self,
                forKey: .showMergeCommitsPerFileLog
            ) ?? false
        }
    }
}
