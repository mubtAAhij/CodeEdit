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
                String(localized: "settings.source-control.section.general", defaultValue: "General", comment: "Section title for general source control settings."),
                String(localized: "settings.source-control.option.enable-source-control", defaultValue: "Enable source control", comment: "Setting label to enable source control features."),
                String(localized: "settings.source-control.option.refresh-local-status-automatically", defaultValue: "Refresh local status automatically", comment: "Setting label for automatically refreshing local source control status."),
                String(localized: "settings.source-control.option.fetch-and-refresh-server-status-automatically", defaultValue: "Fetch and refresh server status automatically", comment: "Setting label for automatically fetching and refreshing remote status."),
                String(localized: "settings.source-control.option.add-and-remove-files-automatically", defaultValue: "Add and remove files automatically", comment: "Setting label for automatically tracking added and removed files."),
                String(localized: "settings.source-control.option.select-files-to-commit-automatically", defaultValue: "Select files to commit automatically", comment: "Setting label for automatically selecting files for commit."),
                String(localized: "settings.source-control.option.show-source-control-changes", defaultValue: "Show source control changes", comment: "Setting label for showing source control changes in the UI."),
                String(localized: "settings.source-control.option.include-upstream-changes", defaultValue: "Include upstream changes", comment: "Setting label for including upstream changes in comparisons."),
                String(localized: "settings.source-control.option.comparison-view", defaultValue: "Comparison view", comment: "Setting label for source control comparison view behavior."),
                String(localized: "settings.source-control.option.navigator", defaultValue: "Source control navigator", comment: "Setting label for source control navigator behavior."),
                String(localized: "settings.source-control.git.default-branch-name", defaultValue: "Default branch name", comment: "Setting label for default Git branch name."),
                String(localized: "settings.source-control.section.git", defaultValue: "Git", comment: "Section title for Git-specific source control settings."),
                String(localized: "settings.source-control.git.author-name", defaultValue: "Author Name", comment: "Setting label for Git author name."),
                String(localized: "settings.source-control.git.author-email", defaultValue: "Author Email", comment: "Setting label for Git author email."),
                String(localized: "settings.source-control.git.prefer-rebase-when-pulling", defaultValue: "Prefer to rebase when pulling", comment: "Setting label for preferring rebase during pull operations."),
                String(localized: "settings.source-control.git.show-merge-commits-in-per-file-log", defaultValue: "Show merge commits in per-file log", comment: "Setting label for showing merge commits in the per-file commit log.")
            ]
            .map { NSLocalizedString($0, comment: "") }
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
