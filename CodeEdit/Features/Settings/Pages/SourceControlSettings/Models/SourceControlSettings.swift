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
                String(localized: "source.control.settings.search.general", defaultValue: "General", comment: "Search key for general source control settings section"),
                String(localized: "source.control.settings.search.enable", defaultValue: "Enable source control", comment: "Search key for enabling source control"),
                String(localized: "source.control.settings.search.refresh.local", defaultValue: "Refresh local status automatically", comment: "Search key for automatic local status refresh setting"),
                String(localized: "source.control.settings.search.fetch.server", defaultValue: "Fetch and refresh server status automatically", comment: "Search key for automatic server status fetch setting"),
                String(localized: "source.control.settings.search.add.remove", defaultValue: "Add and remove files automatically", comment: "Search key for automatic file staging setting"),
                String(localized: "source.control.settings.search.select.files", defaultValue: "Select files to commit automatically", comment: "Search key for automatic file selection setting"),
                String(localized: "source.control.settings.search.show.changes", defaultValue: "Show source control changes", comment: "Search key for showing source control changes setting"),
                String(localized: "source.control.settings.search.upstream", defaultValue: "Include upstream changes", comment: "Search key for including upstream changes setting"),
                String(localized: "source.control.settings.search.comparison.view", defaultValue: "Comparison view", comment: "Search key for comparison view setting"),
                String(localized: "source.control.settings.search.navigator", defaultValue: "Source control navigator", comment: "Search key for source control navigator setting"),
                String(localized: "source.control.settings.search.default.branch", defaultValue: "Default branch name", comment: "Search key for default branch name setting"),
                String(localized: "source.control.settings.search.git", defaultValue: "Git", comment: "Search key for Git settings section"),
                String(localized: "source.control.settings.search.author.name", defaultValue: "Author Name", comment: "Search key for Git author name setting"),
                String(localized: "source.control.settings.search.author.email", defaultValue: "Author Email", comment: "Search key for Git author email setting"),
                String(localized: "source.control.settings.search.rebase", defaultValue: "Prefer to rebase when pulling", comment: "Search key for Git rebase preference setting"),
                String(localized: "source.control.settings.search.merge.commits", defaultValue: "Show merge commits in per-file log", comment: "Search key for showing merge commits in log setting")
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
