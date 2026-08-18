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
                    localized: "settings.source-control.model.general",
                    defaultValue: "General",
                    comment: "Source control settings section title for general options"
                ),
                String(
                    localized: "settings.source-control.model.enable-source-control",
                    defaultValue: "Enable source control",
                    comment: "Toggle label to enable source control support"
                ),
                String(
                    localized: "settings.source-control.model.refresh-local-status-automatically",
                    defaultValue: "Refresh local status automatically",
                    comment: "Toggle label for automatic local status refresh"
                ),
                String(
                    localized: "settings.source-control.model.fetch-and-refresh-server-status-automatically",
                    defaultValue: "Fetch and refresh server status automatically",
                    comment: "Toggle label for automatic fetch and remote status refresh"
                ),
                String(
                    localized: "settings.source-control.model.add-and-remove-files-automatically",
                    defaultValue: "Add and remove files automatically",
                    comment: "Toggle label for automatically adding and removing files in source control"
                ),
                String(
                    localized: "settings.source-control.model.select-files-to-commit-automatically",
                    defaultValue: "Select files to commit automatically",
                    comment: "Toggle label for automatically selecting files when committing"
                ),
                String(
                    localized: "settings.source-control.model.show-source-control-changes",
                    defaultValue: "Show source control changes",
                    comment: "Toggle label to display source control changes in editor"
                ),
                String(
                    localized: "settings.source-control.model.include-upstream-changes",
                    defaultValue: "Include upstream changes",
                    comment: "Toggle label to include upstream changes in comparisons"
                ),
                String(
                    localized: "settings.source-control.model.comparison-view",
                    defaultValue: "Comparison view",
                    comment: "Section title for source control comparison view settings"
                ),
                String(
                    localized: "settings.source-control.model.source-control-navigator",
                    defaultValue: "Source control navigator",
                    comment: "Section title for source control navigator settings"
                ),
                String(
                    localized: "settings.source-control.model.default-branch-name",
                    defaultValue: "Default branch name",
                    comment: "Label for default git branch name setting"
                ),
                String(
                    localized: "settings.source-control.model.git",
                    defaultValue: "Git",
                    comment: "Section title for git-specific source control settings"
                ),
                String(
                    localized: "settings.source-control.model.author-name",
                    defaultValue: "Author Name",
                    comment: "Label for git author name setting"
                ),
                String(
                    localized: "settings.source-control.model.author-email",
                    defaultValue: "Author Email",
                    comment: "Label for git author email setting"
                ),
                String(
                    localized: "settings.source-control.model.prefer-to-rebase-when-pulling",
                    defaultValue: "Prefer to rebase when pulling",
                    comment: "Toggle label for pull strategy preference"
                ),
                String(
                    localized: "settings.source-control.model.show-merge-commits-in-per-file-log",
                    defaultValue: "Show merge commits in per-file log",
                    comment: "Toggle label to include merge commits in file history log"
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
