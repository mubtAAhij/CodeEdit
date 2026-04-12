//
//  GeneralSettings.swift
//  CodeEditModules/Settings
//
//  Created by Nanashi Li on 2022/04/08.
//

import SwiftUI

extension SettingsData {

    /// The general global setting
    struct GeneralSettings: Codable, Hashable, SearchableSettingsPage {

        /// The appearance of the app
        var appAppearance: Appearances = .system

        /// The show issues behavior of the app
        var showIssues: Issues = .inline

        /// The show live issues behavior of the app
        var showLiveIssues: Bool = true

        /// The search keys
        var searchKeys: [String] {
            [
                String(localized: "general.search-key.appearance", defaultValue: "Appearance", comment: "Appearance search key"),
                String(localized: "general.search-key.file-icon-style", defaultValue: "File Icon Style", comment: "File Icon Style search key"),
                String(localized: "general.search-key.tab-bar-style", defaultValue: "Tab Bar Style", comment: "Tab Bar Style search key"),
                String(localized: "general.search-key.show-jump-bar", defaultValue: "Show Jump Bar", comment: "Show Jump Bar search key"),
                String(localized: "general.search-key.dim-editors-without-focus", defaultValue: "Dim editors without focus", comment: "Dim editors without focus search key"),
                String(localized: "general.search-key.navigator-tab-bar-position", defaultValue: "Navigator Tab Bar Position", comment: "Navigator Tab Bar Position search key"),
                String(localized: "general.search-key.inspector-tab-bar-position", defaultValue: "Inspector Tab Bar Position", comment: "Inspector Tab Bar Position search key"),
                String(localized: "general.search-key.show-issues", defaultValue: "Show Issues", comment: "Show Issues search key"),
                String(localized: "general.search-key.show-live-issues", defaultValue: "Show Live Issues", comment: "Show Live Issues search key"),
                String(localized: "general.search-key.automatically-save-change-to-disk", defaultValue: "Automatically save change to disk", comment: "Automatically save change to disk search key"),
                String(localized: "general.search-key.automatically-reveal-in-project-navigator", defaultValue: "Automatically reveal in project navigator", comment: "Automatically reveal in project navigator search key"),
                String(localized: "general.search-key.reopen-behavior", defaultValue: "Reopen Behavior", comment: "Reopen Behavior search key"),
                String(localized: "general.search-key.after-the-last-window-is-closed", defaultValue: "After the last window is closed", comment: "After the last window is closed search key"),
                String(localized: "general.search-key.file-extensions", defaultValue: "File Extensions", comment: "File Extensions search key"),
                String(localized: "general.search-key.project-navigator-size", defaultValue: "Project Navigator Size", comment: "Project Navigator Size search key"),
                String(localized: "general.search-key.find-navigator-detail", defaultValue: "Find Navigator Detail", comment: "Find Navigator Detail search key"),
                String(localized: "general.search-key.issue-navigator-detail", defaultValue: "Issue Navigator Detail", comment: "Issue Navigator Detail search key"),
                String(localized: "general.search-key.show-open-with-codeedit-option-in-finder", defaultValue: "Show \"Open With CodeEdit\" option in Finder", comment: "Show Open With CodeEdit option in Finder search key"),
                String(localized: "general.search-key.codeedit-shell-command", defaultValue: "'codeedit' Shell command", comment: "codeedit Shell command search key"),
                String(localized: "general.search-key.dialog-warnings", defaultValue: "Dialog Warnings", comment: "Dialog Warnings search key"),
                String(localized: "general.search-key.check-for-updates", defaultValue: "Check for updates", comment: "Check for updates search key"),
                String(localized: "general.search-key.automatically-check-for-app-updates", defaultValue: "Automatically check for app updates", comment: "Automatically check for app updates search key"),
                String(localized: "general.search-key.include-pre-release-versions", defaultValue: "Include pre-release versions", comment: "Include pre-release versions search key")
            ]
        }

        /// Show editor jump bar
        var showEditorJumpBar: Bool = true

        /// Dims editors without focus
        var dimEditorsWithoutFocus: Bool = false

        /// The show file extensions behavior of the app
        var fileExtensionsVisibility: FileExtensionsVisibility = .showAll

        /// The file extensions collection to display
        var shownFileExtensions: FileExtensions = .default

        /// The file extensions collection to hide
        var hiddenFileExtensions: FileExtensions = .default

        /// The style for file icons
        var fileIconStyle: FileIconStyle = .color

        /// The position for the navigator sidebar tab bar
        var navigatorTabBarPosition: SidebarTabBarPosition = .top

        /// The position for the inspector sidebar tab bar
        var inspectorTabBarPosition: SidebarTabBarPosition = .top

        /// The reopen behavior of the app
        var reopenBehavior: ReopenBehavior = .welcome

        /// Decides what the app does after a workspace is closed
        var reopenWindowAfterClose: ReopenWindowBehavior = .doNothing

        /// The size of the project navigator
        var projectNavigatorSize: ProjectNavigatorSize = .medium

        /// The Find Navigator Detail line limit
        var findNavigatorDetail: NavigatorDetail = .upTo3

        /// The Issue Navigator Detail line limit
        var issueNavigatorDetail: NavigatorDetail = .upTo3

        /// The reveal file in navigator when focus changes behavior of the app.
        var revealFileOnFocusChange: Bool = false

        /// Auto save behavior toggle
        var isAutoSaveOn: Bool = true

        /// Default initializer
        init() {}

        // swiftlint:disable function_body_length
        /// Explicit decoder init for setting default values when key is not present in `JSON`
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.appAppearance = try container.decodeIfPresent(
                Appearances.self,
                forKey: .appAppearance
            ) ?? .system
            self.showIssues = try container.decodeIfPresent(
                Issues.self,
                forKey: .showIssues
            ) ?? .inline
            self.showLiveIssues = try container.decodeIfPresent(
                Bool.self,
                forKey: .showLiveIssues
            ) ?? true
            self.showEditorJumpBar = try container.decodeIfPresent(
                Bool.self,
                forKey: .showEditorJumpBar
            ) ?? true
            self.dimEditorsWithoutFocus = try container.decodeIfPresent(
                Bool.self,
                forKey: .dimEditorsWithoutFocus
            ) ?? false
            self.fileExtensionsVisibility = try container.decodeIfPresent(
                FileExtensionsVisibility.self,
                forKey: .fileExtensionsVisibility
            ) ?? .showAll
            self.shownFileExtensions = try container.decodeIfPresent(
                FileExtensions.self,
                forKey: .shownFileExtensions
            ) ?? .default
            self.hiddenFileExtensions = try container.decodeIfPresent(
                FileExtensions.self,
                forKey: .hiddenFileExtensions
            ) ?? .default
            self.fileIconStyle = try container.decodeIfPresent(
                FileIconStyle.self,
                forKey: .fileIconStyle
            ) ?? .color
            self.navigatorTabBarPosition = try container.decodeIfPresent(
                SidebarTabBarPosition.self,
                forKey: .navigatorTabBarPosition
            ) ?? .top
            self.inspectorTabBarPosition = try container.decodeIfPresent(
                SidebarTabBarPosition.self,
                forKey: .inspectorTabBarPosition
            ) ?? .top
            self.reopenBehavior = try container.decodeIfPresent(
                ReopenBehavior.self,
                forKey: .reopenBehavior
            ) ?? .welcome
            self.reopenWindowAfterClose = try container.decodeIfPresent(
                ReopenWindowBehavior.self,
                forKey: .reopenWindowAfterClose
            ) ?? .doNothing
            self.projectNavigatorSize = try container.decodeIfPresent(
                ProjectNavigatorSize.self,
                forKey: .projectNavigatorSize
            ) ?? .medium
            self.findNavigatorDetail = try container.decodeIfPresent(
                NavigatorDetail.self,
                forKey: .findNavigatorDetail
            ) ?? .upTo3
            self.issueNavigatorDetail = try container.decodeIfPresent(
                NavigatorDetail.self,
                forKey: .issueNavigatorDetail
            ) ?? .upTo3
            self.revealFileOnFocusChange = try container.decodeIfPresent(
                Bool.self,
                forKey: .revealFileOnFocusChange
            ) ?? false
            self.isAutoSaveOn = try container.decodeIfPresent(
                Bool.self,
                forKey: .isAutoSaveOn
            ) ?? true
        }
        // swiftlint:enable function_body_length
    }

    /// The appearance of the app
    /// - **system**: uses the system appearance
    /// - **dark**: always uses dark appearance
    /// - **light**: always uses light appearance
    enum Appearances: String, Codable {
        case system
        case light
        case dark

        /// Applies the selected appearance
        func applyAppearance() {
            switch self {
            case .system:
                NSApp.appearance = nil

            case .dark:
                NSApp.appearance = .init(named: .darkAqua)

            case .light:
                NSApp.appearance = .init(named: .aqua)
            }
        }
    }

    /// The style for issues display
    ///  - **inline**: Issues show inline
    ///  - **minimized** Issues show minimized
    enum Issues: String, Codable {
        case inline
        case minimized
    }

    /// The style for file extensions visibility
    ///  - **hideAll**: File extensions are hidden
    ///  - **showAll** File extensions are visible
    ///  - **showOnly** Specific file extensions are visible
    ///  - **hideOnly** Specific file extensions are hidden
    enum FileExtensionsVisibility: Codable, Hashable {
        case hideAll
        case showAll
        case showOnly
        case hideOnly
    }

    /// The collection of file extensions used by
    /// ``FileExtensionsVisibility/showOnly`` or  ``FileExtensionsVisibility/hideOnly`` preference
    struct FileExtensions: Codable, Hashable {
        var extensions: [String]

        var string: String {
            get {
                extensions.joined(separator: ", ")
            }
            set {
                extensions = newValue
                    .components(separatedBy: ",")
                    .map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })
                    .filter({ !$0.isEmpty || string.count < newValue.count })
            }
        }

        static var `default` = FileExtensions(extensions: [
            "c", "cc", "cpp", "h", "hpp", "m", "mm", "gif",
            "icns", "jpeg", "jpg", "png", "tiff", "swift"
        ])
    }
    /// The style for file icons
    /// - **color**: File icons appear in their default colors
    /// - **monochrome**: File icons appear monochromatic
    enum FileIconStyle: String, Codable {
        case color
        case monochrome
    }

    /// The position for a sidebar tab bar
    /// - **top**: Tab bar is positioned at the top of the sidebar
    /// - **side**: Tab bar is positioned to the side of the sidebar
    enum SidebarTabBarPosition: String, Codable {
        case top, side
    }

    /// The reopen behavior of the app
    /// - **welcome**: On restart the app will show the welcome screen
    /// - **openPanel**: On restart the app will show an open panel
    /// - **newDocument**: On restart a new empty document will be created
    enum ReopenBehavior: String, Codable {
        case welcome
        case openPanel
        case newDocument
    }

    enum ReopenWindowBehavior: String, Codable {
        case showWelcomeWindow
        case doNothing
        case quit
    }

    enum ProjectNavigatorSize: String, Codable {
        case small
        case medium
        case large

        /// Returns the row height depending on the `projectNavigatorSize` in `Settings`.
        ///
        /// * `small`: 20
        /// * `medium`: 22
        /// * `large`: 24
        var rowHeight: Double {
            switch self {
            case .small: return 20
            case .medium: return 22
            case .large: return 24
            }
        }
    }

    /// The Navigation Detail behavior of the app
    ///  - Use **rawValue** to set lineLimit
    enum NavigatorDetail: Int, Codable, CaseIterable {
        case upTo1 = 1
        case upTo2 = 2
        case upTo3 = 3
        case upTo4 = 4
        case upTo5 = 5
        case upTo10 = 10
        case upTo30 = 30

        var label: String {
            switch self {
            case .upTo1:
                return String(localized: "general.navigator-detail.one-line", defaultValue: "One Line", comment: "One Line navigator detail")
            default:
                return String(format: String(localized: "general.navigator-detail.up-to-lines", defaultValue: "Up to %d lines", comment: "Up to N lines navigator detail"), self.rawValue)
            }
        }
    }
}
