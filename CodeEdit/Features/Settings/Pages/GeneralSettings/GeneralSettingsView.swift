//
//  GeneralSettingsView.swift
//  CodeEdit
//
//  Created by Austin Condiff on 4/1/23.
//

import SwiftUI

/// A view that implements the `General` settings page
struct GeneralSettingsView: View {
    private let inputWidth: Double = 160
    private let textEditorWidth: Double = 220
    private let textEditorHeight: Double = 30

    @EnvironmentObject var updater: SoftwareUpdater
    @FocusState private var focusedField: UUID?

    @AppSettings(\.general)
    var settings

    @State private var openInCodeEdit: Bool = true

    init() {
        guard let defaults = UserDefaults.init(
            suiteName: String(localized: "general.shared_defaults_suite", defaultValue: "app.codeedit.CodeEdit.shared", comment: "Shared user defaults suite name")
        ) else {
            print("Failed to get/init shared defaults")
            return
        }

        self.openInCodeEdit = defaults.bool(forKey: String(localized: "general.open_in_ce_key", defaultValue: "enableOpenInCE", comment: "User defaults key for open in CodeEdit"))
    }

    var body: some View {
        SettingsForm {
            Section {
                appearance
                fileIconStyle
                showEditorJumpBar
                dimEditorsWithoutFocus
                navigatorTabBarPosition
                inspectorTabBarPosition
            }
            Section {
                showIssues
                showLiveIssues
            }
            Section {
                autoSave
                revealFileOnFocusChangeToggle
                reopenBehavior
                afterWindowsCloseBehaviour
                fileExtensions
            }
            Section {
                projectNavigatorSize
                findNavigatorDetail
                issueNavigatorDetail
            }
            Section {
                openInCodeEditToggle
                shellCommand
                dialogWarnings

            }
            Section {
                updateChecker
                autoUpdateToggle
                // TODO: Uncomment when production build is released.
                // prereleaseToggle
            }
        }
    }
}

/// The extension of the view with all the preferences
private extension GeneralSettingsView {
    var appearance: some View {
        Picker(String(localized: "general.appearance", defaultValue: "Appearance", comment: "Appearance picker label"), selection: $settings.appAppearance) {
            Text(String(localized: "general.appearance.system", defaultValue: "System", comment: "System appearance option"))
                .tag(SettingsData.Appearances.system)
            Divider()
            Text(String(localized: "general.appearance.light", defaultValue: "Light", comment: "Light appearance option"))
                .tag(SettingsData.Appearances.light)
            Text(String(localized: "general.appearance.dark", defaultValue: "Dark", comment: "Dark appearance option"))
                .tag(SettingsData.Appearances.dark)
        }
        .onChange(of: settings.appAppearance) { _, tag in
            tag.applyAppearance()
        }
    }

    // TODO: Implement reflecting Show Issues preference and remove disabled modifier
    var showIssues: some View {
        Picker(String(localized: "general.show_issues", defaultValue: "Show Issues", comment: "Show Issues picker label"), selection: $settings.showIssues) {
            Text(String(localized: "general.show_issues.inline", defaultValue: "Show Inline", comment: "Show Inline issues option"))
                .tag(SettingsData.Issues.inline)
            Text(String(localized: "general.show_issues.minimized", defaultValue: "Show Minimized", comment: "Show Minimized issues option"))
                .tag(SettingsData.Issues.minimized)
        }
    }

    var showLiveIssues: some View {
        Toggle(String(localized: "general.show_live_issues", defaultValue: "Show Live Issues", comment: "Show Live Issues toggle"), isOn: $settings.showLiveIssues)
    }

    var showEditorJumpBar: some View {
        Toggle(String(localized: "general.show_jump_bar", defaultValue: "Show Jump Bar", comment: "Show Jump Bar toggle"), isOn: $settings.showEditorJumpBar)
    }

    var dimEditorsWithoutFocus: some View {
        Toggle(String(localized: "general.dim_editors_without_focus", defaultValue: "Dim editors without focus", comment: "Dim editors without focus toggle"), isOn: $settings.dimEditorsWithoutFocus)
    }

    var fileExtensions: some View {
        Group {
            Picker(String(localized: "general.file_extensions", defaultValue: "File Extensions", comment: "File Extensions picker label"), selection: $settings.fileExtensionsVisibility) {
                Text(String(localized: "general.file_extensions.hide_all", defaultValue: "Hide all", comment: "Hide all file extensions option"))
                    .tag(SettingsData.FileExtensionsVisibility.hideAll)
                Text(String(localized: "general.file_extensions.show_all", defaultValue: "Show all", comment: "Show all file extensions option"))
                    .tag(SettingsData.FileExtensionsVisibility.showAll)
                Divider()
                Text(String(localized: "general.file_extensions.show_only", defaultValue: "Show only", comment: "Show only specific file extensions option"))
                    .tag(SettingsData.FileExtensionsVisibility.showOnly)
                Text(String(localized: "general.file_extensions.hide_only", defaultValue: "Hide only", comment: "Hide only specific file extensions option"))
                    .tag(SettingsData.FileExtensionsVisibility.hideOnly)
            }
            if case .showOnly = settings.fileExtensionsVisibility {
                TextField("", text: $settings.shownFileExtensions.string, axis: .vertical)
                    .labelsHidden()
                    .lineLimit(1...3)
            }
            if case .hideOnly = settings.fileExtensionsVisibility {
                TextField("", text: $settings.hiddenFileExtensions.string, axis: .vertical)
                    .labelsHidden()
                    .lineLimit(1...3)
            }
        }
    }

    var fileIconStyle: some View {
        Picker(String(localized: "general.file_icon_style", defaultValue: "File Icon Style", comment: "File Icon Style picker label"), selection: $settings.fileIconStyle) {
            Text(String(localized: "general.file_icon_style.color", defaultValue: "Color", comment: "Color file icon style option"))
                .tag(SettingsData.FileIconStyle.color)
            Text(String(localized: "general.file_icon_style.monochrome", defaultValue: "Monochrome", comment: "Monochrome file icon style option"))
                .tag(SettingsData.FileIconStyle.monochrome)
        }
        .pickerStyle(.radioGroup)
    }

    var navigatorTabBarPosition: some View {
        Picker(String(localized: "general.navigator_tab_bar_position", defaultValue: "Navigator Tab Bar Position", comment: "Navigator Tab Bar Position picker label"), selection: $settings.navigatorTabBarPosition) {
            Text(String(localized: "general.tab_bar_position.top", defaultValue: "Top", comment: "Top position option"))
                .tag(SettingsData.SidebarTabBarPosition.top)
            Text(String(localized: "general.tab_bar_position.side", defaultValue: "Side", comment: "Side position option"))
                .tag(SettingsData.SidebarTabBarPosition.side)
        }
        .pickerStyle(.radioGroup)
    }

    var inspectorTabBarPosition: some View {
        Picker(String(localized: "general.inspector_tab_bar_position", defaultValue: "Inspector Tab Bar Position", comment: "Inspector Tab Bar Position picker label"), selection: $settings.inspectorTabBarPosition) {
            Text(String(localized: "general.tab_bar_position.top", defaultValue: "Top", comment: "Top position option"))
                .tag(SettingsData.SidebarTabBarPosition.top)
            Text(String(localized: "general.tab_bar_position.side", defaultValue: "Side", comment: "Side position option"))
                .tag(SettingsData.SidebarTabBarPosition.side)
        }
        .pickerStyle(.radioGroup)
    }

    var reopenBehavior: some View {
        Picker(String(localized: "general.reopen_behavior", defaultValue: "Reopen Behavior", comment: "Reopen Behavior picker label"), selection: $settings.reopenBehavior) {
            Text(String(localized: "general.reopen_behavior.welcome_screen", defaultValue: "Welcome Screen", comment: "Welcome Screen reopen option"))
                .tag(SettingsData.ReopenBehavior.welcome)
            Divider()
            Text(String(localized: "general.reopen_behavior.open_panel", defaultValue: "Open Panel", comment: "Open Panel reopen option"))
                .tag(SettingsData.ReopenBehavior.openPanel)
            Text(String(localized: "general.reopen_behavior.new_document", defaultValue: "New Document", comment: "New Document reopen option"))
                .tag(SettingsData.ReopenBehavior.newDocument)
        }
    }

    var afterWindowsCloseBehaviour: some View {
        Picker(
            String(localized: "general.after_last_window_closed", defaultValue: "After the last window is closed", comment: "After last window closed picker label"),
            selection: $settings.reopenWindowAfterClose
        ) {
            Text(String(localized: "general.after_last_window_closed.do_nothing", defaultValue: "Do nothing", comment: "Do nothing option"))
                .tag(SettingsData.ReopenWindowBehavior.doNothing)
            Divider()
            Text(String(localized: "general.after_last_window_closed.show_welcome", defaultValue: "Show Welcome Window", comment: "Show Welcome Window option"))
                .tag(SettingsData.ReopenWindowBehavior.showWelcomeWindow)
            Text(String(localized: "general.after_last_window_closed.quit", defaultValue: "Quit", comment: "Quit option"))
                .tag(SettingsData.ReopenWindowBehavior.quit)
        }
    }

    var projectNavigatorSize: some View {
        Picker(String(localized: "general.project_navigator_size", defaultValue: "Project Navigator Size", comment: "Project Navigator Size picker label"), selection: $settings.projectNavigatorSize) {
            Text(String(localized: "general.size.small", defaultValue: "Small", comment: "Small size option"))
                .tag(SettingsData.ProjectNavigatorSize.small)
            Text(String(localized: "general.size.medium", defaultValue: "Medium", comment: "Medium size option"))
                .tag(SettingsData.ProjectNavigatorSize.medium)
            Text(String(localized: "general.size.large", defaultValue: "Large", comment: "Large size option"))
                .tag(SettingsData.ProjectNavigatorSize.large)
        }
    }

    var findNavigatorDetail: some View {
        Picker(String(localized: "general.find_navigator_detail", defaultValue: "Find Navigator Detail", comment: "Find Navigator Detail picker label"), selection: $settings.findNavigatorDetail) {
            ForEach(SettingsData.NavigatorDetail.allCases, id: \.self) { tag in
                Text(tag.label).tag(tag)
            }
        }
    }

    // TODO: Implement reflecting Issue Navigator Detail preference and remove disabled modifier
    var issueNavigatorDetail: some View {
        Picker(String(localized: "general.issue_navigator_detail", defaultValue: "Issue Navigator Detail", comment: "Issue Navigator Detail picker label"), selection: $settings.issueNavigatorDetail) {
            ForEach(SettingsData.NavigatorDetail.allCases, id: \.self) { tag in
                Text(tag.label).tag(tag)
            }
        }
        .disabled(true)
    }

    // TODO: Implement reset for Don't Ask Me warnings Button and remove disabled modifier
    var dialogWarnings: some View {
        LabeledContent(String(localized: "general.dialog_warnings", defaultValue: "Dialog Warnings", comment: "Dialog Warnings label")) {
            Button(action: {
            }, label: {
                Text(String(localized: "general.reset_warnings", defaultValue: "Reset \"Don't Ask Me\" Warnings", comment: "Reset warnings button label"))
            })
            .buttonStyle(.bordered)
        }
        .disabled(true)
    }

    var shellCommand: some View {
        LabeledContent(String(localized: "general.shell_command", defaultValue: "'codeedit' Shell Command", comment: "Shell command label")) {
            Button(action: installShellCommand, label: {
                Text(String(localized: "general.install", defaultValue: "Install", comment: "Install button label"))
            })
            .disabled(true)
            .buttonStyle(.bordered)
        }
    }

    func installShellCommand() {
        do {
            let url = Bundle.main.url(forResource: String(localized: "general.shell_resource_name", defaultValue: "codeedit", comment: "Shell command resource name"), withExtension: nil, subdirectory: String(localized: "general.resources_directory", defaultValue: "Resources", comment: "Resources directory name"))
            let destination = String(localized: "general.shell_destination_path", defaultValue: "/usr/local/bin/codeedit", comment: "Shell command destination path")

            if FileManager.default.fileExists(atPath: destination) {
                try FileManager.default.removeItem(atPath: destination)
            }

            guard let shellUrl = url?.path else {
                print("Failed to get URL to shell command")
                return
            }

            NSWorkspace.shared.requestAuthorization(to: .createSymbolicLink) { auth, error in
                guard let auth, error == nil else {
                    fallbackShellInstallation(commandPath: shellUrl, destinationPath: destination)
                    return
                }

                do {
                    try FileManager(authorization: auth).createSymbolicLink(
                        atPath: destination, withDestinationPath: shellUrl
                    )
                } catch {
                    fallbackShellInstallation(commandPath: shellUrl, destinationPath: destination)
                }
            }
        } catch {
            print(error)
        }
    }

    var updateChecker: some View {
        Section {
            LabeledContent {
                Button(String(localized: "general.check_now", defaultValue: "Check Now", comment: "Check Now button label")) {
                    updater.checkForUpdates()
                }
            } label: {
                Text(String(localized: "general.check_for_updates", defaultValue: "Check for updates", comment: "Check for updates label"))
                Text(String(format: String(localized: "general.last_checked", defaultValue: "Last checked: %@", comment: "Last checked timestamp"), lastUpdatedString))

            }
        }
    }

    var autoUpdateToggle: some View {
        Toggle(String(localized: "general.auto_check_updates", defaultValue: "Automatically check for app updates", comment: "Automatically check for updates toggle"), isOn: $updater.automaticallyChecksForUpdates)
    }

    var prereleaseToggle: some View {
        Toggle(String(localized: "general.include_prerelease", defaultValue: "Include pre-release versions", comment: "Include pre-release versions toggle"), isOn: $updater.includePrereleaseVersions)
    }

    var autoSave: some View {
        Toggle(String(localized: "general.auto_save", defaultValue: "Automatically save changes to disk", comment: "Automatically save changes toggle"), isOn: $settings.isAutoSaveOn)
    }

    // MARK: - Preference Views

    private var lastUpdatedString: String {
        if let lastUpdatedDate = updater.lastUpdateCheckDate {
            return Self.formatter.string(from: lastUpdatedDate)
        } else {
            return String(localized: "general.never", defaultValue: "Never", comment: "Never checked for updates")
        }
    }

    private static func configure<Subject>(_ subject: Subject, configuration: (inout Subject) -> Void) -> Subject {
        var copy = subject
        configuration(&copy)
        return copy
    }

    func fallbackShellInstallation(commandPath: String, destinationPath: String) {
        let cmd = [
            String(localized: "general.osascript_command", defaultValue: "osascript", comment: "osascript command"),
            String(localized: "general.osascript_flag", defaultValue: "-e", comment: "osascript -e flag"),
            String(format: String(localized: "general.shell_script_template", defaultValue: "\"do shell script \\\"mkdir -p /usr/local/bin && ln -sf '%@' '%@'\\\"\"", comment: "Shell script template for symlink creation"), commandPath, destinationPath),
            String(localized: "general.admin_privileges", defaultValue: "with administrator privileges", comment: "Administrator privileges text")
        ]

        let cmdStr = cmd.joined(separator: " ")

        let task = Process()
        let pipe = Pipe()

        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = [String(localized: "general.shell_flag_c", defaultValue: "-c", comment: "Shell -c flag"), cmdStr]
        task.executableURL = URL(fileURLWithPath: String(localized: "general.zsh_path", defaultValue: "/bin/zsh", comment: "zsh shell path"))
        task.standardInput = nil

        do {
            try task.run()
        } catch {
            print(error)
        }
    }

    var openInCodeEditToggle: some View {
        Toggle(String(localized: "general.open_with_codeedit", defaultValue: "Show \"Open With CodeEdit\" option in Finder", comment: "Open With CodeEdit toggle"), isOn: $openInCodeEdit)
            .onChange(of: openInCodeEdit) { _, newValue in
                guard let defaults = UserDefaults.init(
                    suiteName: String(localized: "general.shared_defaults_suite", defaultValue: "app.codeedit.CodeEdit.shared", comment: "Shared user defaults suite name")
                ) else {
                    print("Failed to get/init shared defaults")
                    return
                }

                defaults.set(newValue, forKey: String(localized: "general.open_in_ce_key", defaultValue: "enableOpenInCE", comment: "User defaults key for open in CodeEdit"))
            }
    }

    var revealFileOnFocusChangeToggle: some View {
        Toggle(String(localized: "general.auto_reveal_in_navigator", defaultValue: "Automatically reveal in project navigator", comment: "Auto reveal in project navigator toggle"), isOn: $settings.revealFileOnFocusChange)
    }

    private static let formatter = configure(DateFormatter()) {
        $0.dateStyle = .medium
        $0.timeStyle = .medium
    }
}
