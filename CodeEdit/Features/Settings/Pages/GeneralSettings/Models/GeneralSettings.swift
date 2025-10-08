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
                String(localized: "general_settings.appearance", comment: "Label for appearance settings section"),
                String(localized: "general_settings.file_icon_style", comment: "Label for file icon style setting"),
                "Tab Bar Style",
                String(localized: "general_settings.show_jump_bar", comment: "Label for show jump bar setting"),
                String(localized: "general_settings.dim_editors_without_focus", comment: "Label for dim editors without focus setting"),
                String(localized: "general_settings.navigator_tab_bar_position", comment: "Label for navigator tab bar position setting"),
                String(localized: "general_settings.inspector_tab_bar_position", comment: "Label for inspector tab bar position setting"),
                String(localized: "general_settings.show_issues", comment: "Label for show issues setting"),
                String(localized: "general_settings.show_live_issues", comment: "Label for show live issues setting"),
                "Automatically save change to disk",
                String(localized: "general_settings.auto_reveal_in_project_navigator", comment: "Label for automatically reveal in project navigator setting"),
                String(localized: "general_settings.reopen_behavior", comment: "Label for reopen behavior setting"),
                String(localized: "general_settings.after_last_window_closed", comment: "Label for after last window is closed setting"),
                String(localized: "general_settings.file_extensions", comment: "Label for file extensions setting"),
                String(localized: "general_settings.project_navigator_size", comment: "Label for project navigator size setting"),
                String(localized: "general_settings.find_navigator_detail", comment: "Label for find navigator detail setting"),
                String(localized: "general_settings.issue_navigator_detail", comment: "Label for issue navigator detail setting"),
                "Show “Open With CodeEdit“ option in Finder",
                String(localized: "general_settings.codeedit_shell_command", comment: "Label for codeedit shell command setting"),
                String(localized: "general_settings.dialog_warnings", comment: "Label for dialog warnings setting"),
                String(localized: "general_settings.check_for_updates", comment: "Label for check for updates setting"),
                String(localized: "general_settings.auto_check_for_updates", comment: "Label for automatically check for app updates setting"),
                String(localized: "general_settings.include_prerelease", comment: "Option to include pre-release versions in updates")
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
                return String(localized: "navigator_detail.one_line", comment: "Label for single line display option")
            default:
                return "Up to \(self.rawValue) lines"
            }
        }
    }
}
