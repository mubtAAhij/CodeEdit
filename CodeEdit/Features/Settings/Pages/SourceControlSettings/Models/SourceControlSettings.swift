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
                String(localized: "source-control.settings.general", defaultValue: "General", comment: "Section title for general source control settings"),
                String(localized: "source-control.settings.enable-source-control", defaultValue: "Enable source control", comment: "Toggle label to enable source control integration"),
                String(localized: "source-control.settings.refresh-local-status-automatically", defaultValue: "Refresh local status automatically", comment: "Toggle label for automatically refreshing local repository status"),
                String(localized: "source-control.settings.fetch-and-refresh-server-status-automatically", defaultValue: "Fetch and refresh server status automatically", comment: "Toggle label for automatically fetching and refreshing remote status"),
                String(localized: "source-control.settings.add-and-remove-files-automatically", defaultValue: "Add and remove files automatically", comment: "Toggle label for automatically adding and removing files in source control"),
                String(localized: "source-control.settings.select-files-to-commit-automatically", defaultValue: "Select files to commit automatically", comment: "Toggle label for automatically selecting files for commit"),
                String(localized: "source-control.settings.show-source-control-changes", defaultValue: "Show source control changes", comment: "Toggle label for showing source control changes in editor"),
                String(localized: "source-control.settings.include-upstream-changes", defaultValue: "Include upstream changes", comment: "Toggle label for including upstream changes in comparisons"),
                String(localized: "source-control.settings.comparison-view", defaultValue: "Comparison view", comment: "Label for source control comparison view setting"),
                String(localized: "source-control.settings.source-control-navigator", defaultValue: "Source control navigator", comment: "Label for source control navigator setting"),
                String(localized: "source-control.settings.default-branch-name", defaultValue: "Default branch name", comment: "Label for default branch name setting"),
                String(localized: "source-control.settings.git", defaultValue: "Git", comment: "Section title for Git-specific settings"),
                String(localized: "source-control.settings.author-name", defaultValue: "Author Name", comment: "Label for Git author name setting"),
                String(localized: "source-control.settings.author-email", defaultValue: "Author Email", comment: "Label for Git author email setting"),
                String(localized: "source-control.settings.prefer-rebase-when-pulling", defaultValue: "Prefer to rebase when pulling", comment: "Toggle label for preferring rebase during pull operations"),
                String(localized: "source-control.settings.show-merge-commits-in-per-file-log", defaultValue: "Show merge commits in per-file log", comment: "Toggle label for showing merge commits in file history log")
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
