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
                String(localized: "general_settings_appearance", comment: "Appearance setting option"),
                String(localized: "general_settings_file_icon_style", comment: "File icon style setting option"),
                "Tab Bar Style",
                String(localized: "general_settings_show_jump_bar", comment: "Show jump bar setting option"),
                String(localized: "general_settings_dim_editors_without_focus", comment: "Dim editors without focus setting option"),
                String(localized: "general_settings_navigator_tab_bar_position", comment: "Navigator tab bar position setting option"),
                String(localized: "inspector_tab_bar_position", comment: "Label for inspector tab bar position setting"),
                String(localized: "show_issues", comment: "Label for show issues setting"),
                String(localized: "show_live_issues", comment: "Label for show live issues setting"),
                "Automatically save change to disk",
                String(localized: "automatically_reveal_in_project_navigator", comment: "Label for automatically reveal in project navigator setting"),
                String(localized: "reopen_behavior", comment: "Label for reopen behavior setting"),
                String(localized: "after_the_last_window_is_closed", comment: "Label for after the last window is closed setting"),
                String(localized: "file_extensions", comment: "Label for file extensions setting"),
                String(localized: "project_navigator_size", comment: "Label for project navigator size setting"),
                String(localized: "find_navigator_detail", comment: "Label for find navigator detail setting"),
                String(localized: "issue_navigator_detail", comment: "Label for issue navigator detail setting"),
                "Show “Open With CodeEdit“ option in Finder",
                String(localized: "settings.general.codeedit_shell_command", comment: "codeedit Shell command"),
                String(localized: "settings.general.dialog_warnings", comment: "Dialog Warnings"),
                String(localized: "settings.general.check_for_updates", comment: "Check for updates"),
                String(localized: "settings.general.auto_check_updates", comment: "Automatically check for app updates"),
                String(localized: "settings.general.include_prerelease", comment: "Include pre-release versions")
            ]
            .map { NSLocalizedString($0, comment: "") }
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
                return String(localized: "settings.general.navigator_detail.one_line", comment: "One Line")
            default:
                return String(localized: "settings.general.navigator_detail.up_to_lines", defaultValue: "Up to \(self.rawValue) lines", comment: "Up to N lines format")
            }
        }
    }
}
