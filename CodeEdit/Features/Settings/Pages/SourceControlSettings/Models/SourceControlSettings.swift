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
                String(localized: "settings.source-control.search.general", defaultValue: "General", comment: "General search term"),
                String(localized: "settings.source-control.search.enable-source-control", defaultValue: "Enable source control", comment: "Enable source control search term"),
                String(localized: "settings.source-control.search.refresh-local-status-automatically", defaultValue: "Refresh local status automatically", comment: "Refresh local status automatically search term"),
                String(localized: "settings.source-control.search.fetch-refresh-server-status-automatically", defaultValue: "Fetch and refresh server status automatically", comment: "Fetch and refresh server status automatically search term"),
                String(localized: "settings.source-control.search.add-remove-files-automatically", defaultValue: "Add and remove files automatically", comment: "Add and remove files automatically search term"),
                String(localized: "settings.source-control.search.select-files-to-commit-automatically", defaultValue: "Select files to commit automatically", comment: "Select files to commit automatically search term"),
                String(localized: "settings.source-control.search.show-source-control-changes", defaultValue: "Show source control changes", comment: "Show source control changes search term"),
                String(localized: "settings.source-control.search.include-upstream-changes", defaultValue: "Include upstream changes", comment: "Include upstream changes search term"),
                String(localized: "settings.source-control.search.comparison-view", defaultValue: "Comparison view", comment: "Comparison view search term"),
                String(localized: "settings.source-control.search.source-control-navigator", defaultValue: "Source control navigator", comment: "Source control navigator search term"),
                String(localized: "settings.source-control.search.default-branch-name", defaultValue: "Default branch name", comment: "Default branch name search term"),
                String(localized: "settings.source-control.search.git", defaultValue: "Git", comment: "Git search term"),
                String(localized: "settings.source-control.search.author-name", defaultValue: "Author Name", comment: "Author name search term"),
                String(localized: "settings.source-control.search.author-email", defaultValue: "Author Email", comment: "Author email search term"),
                String(localized: "settings.source-control.search.prefer-to-rebase-when-pulling", defaultValue: "Prefer to rebase when pulling", comment: "Prefer to rebase when pulling search term"),
                String(localized: "settings.source-control.search.show-merge-commits-per-file-log", defaultValue: "Show merge commits in per-file log", comment: "Show merge commits in per-file log search term")
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
