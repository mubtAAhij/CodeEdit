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
                String(
                    localized: "settings.source-control.general.section",
                    defaultValue: "General",
                    comment: "Section title for general source control settings"
                ),
                String(
                    localized: "settings.source-control.enable-source-control.option",
                    defaultValue: "Enable source control",
                    comment: "Option label to enable source control integration"
                ),
                String(
                    localized: "settings.source-control.refresh-local-status-automatically.option",
                    defaultValue: "Refresh local status automatically",
                    comment: "Option label to auto-refresh local source control status"
                ),
                String(
                    localized: "settings.source-control.fetch-and-refresh-server-status-automatically.option",
                    defaultValue: "Fetch and refresh server status automatically",
                    comment: "Option label to auto-fetch and refresh remote status"
                ),
                String(
                    localized: "settings.source-control.add-and-remove-files-automatically.option",
                    defaultValue: "Add and remove files automatically",
                    comment: "Option label for automatically staging file additions and removals"
                ),
                String(
                    localized: "settings.source-control.select-files-to-commit-automatically.option",
                    defaultValue: "Select files to commit automatically",
                    comment: "Option label for automatic commit file selection"
                ),
                String(
                    localized: "settings.source-control.show-source-control-changes.option",
                    defaultValue: "Show source control changes",
                    comment: "Option label to show source control changes in the editor"
                ),
                String(
                    localized: "settings.source-control.include-upstream-changes.option",
                    defaultValue: "Include upstream changes",
                    comment: "Option label to include upstream changes in source control views"
                ),
                String(
                    localized: "settings.source-control.comparison-view.option",
                    defaultValue: "Comparison view",
                    comment: "Option label for source control comparison view setting"
                ),
                String(
                    localized: "settings.source-control.navigator.option",
                    defaultValue: "Source control navigator",
                    comment: "Option label for source control navigator settings"
                ),
                String(
                    localized: "settings.source-control.default-branch-name.option",
                    defaultValue: "Default branch name",
                    comment: "Option label for default git branch name"
                ),
                String(
                    localized: "settings.source-control.git.section",
                    defaultValue: "Git",
                    comment: "Section title for Git-specific settings"
                ),
                String(
                    localized: "settings.source-control.git.author-name.option",
                    defaultValue: "Author Name",
                    comment: "Option label for Git author name"
                ),
                String(
                    localized: "settings.source-control.git.author-email.option",
                    defaultValue: "Author Email",
                    comment: "Option label for Git author email"
                ),
                String(
                    localized: "settings.source-control.git.prefer-rebase-when-pulling.option",
                    defaultValue: "Prefer to rebase when pulling",
                    comment: "Option label to prefer rebase strategy when pulling"
                ),
                String(
                    localized: "settings.source-control.git.show-merge-commits-in-per-file-log.option",
                    defaultValue: "Show merge commits in per-file log",
                    comment: "Option label to include merge commits in per-file history"
                )
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
