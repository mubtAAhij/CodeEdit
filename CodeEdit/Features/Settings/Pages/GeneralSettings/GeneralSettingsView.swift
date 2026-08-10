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
            suiteName: "app.codeedit.CodeEdit.shared"
        ) else {
            print("Failed to get/init shared defaults")
            return
        }

        self.openInCodeEdit = defaults.bool(forKey: "enableOpenInCE")
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
        Picker(String(localized: "settings.general.appearance", defaultValue: "Appearance", comment: "Label for appearance setting section"), selection: $settings.appAppearance) {
            Text(String(localized: "settings.general.appearance.system", defaultValue: "System", comment: "Appearance option label for system setting"))
                .tag(SettingsData.Appearances.system)
            Divider()
            Text(String(localized: "settings.general.appearance.light", defaultValue: "Light", comment: "Appearance option label for light mode"))
                .tag(SettingsData.Appearances.light)
            Text(String(localized: "settings.general.appearance.dark", defaultValue: "Dark", comment: "Appearance option label for dark mode"))
                .tag(SettingsData.Appearances.dark)
        }
        .onChange(of: settings.appAppearance) { _, tag in
            tag.applyAppearance()
        }
    }

    // TODO: Implement reflecting Show Issues preference and remove disabled modifier
    var showIssues: some View {
        Picker(String(localized: "settings.general.show_issues", defaultValue: "Show Issues", comment: "Label for show issues setting"), selection: $settings.showIssues) {
            Text(String(localized: "settings.general.show_issues.inline", defaultValue: "Show Inline", comment: "Option label for showing issues inline"))
                .tag(SettingsData.Issues.inline)
            Text(String(localized: "settings.general.show_issues.minimized", defaultValue: "Show Minimized", comment: "Option label for showing issues minimized"))
                .tag(SettingsData.Issues.minimized)
        }
    }

    var showLiveIssues: some View {
        Toggle(String(localized: "settings.general.show_live_issues", defaultValue: "Show Live Issues", comment: "Toggle label for showing live issues"), isOn: $settings.showLiveIssues)
    }

    var showEditorJumpBar: some View {
        Toggle(String(localized: "settings.general.show_jump_bar", defaultValue: "Show Jump Bar", comment: "Toggle label for showing jump bar"), isOn: $settings.showEditorJumpBar)
    }

    var dimEditorsWithoutFocus: some View {
        Toggle(String(localized: "settings.general.dim_editors_without_focus", defaultValue: "Dim editors without focus", comment: "Toggle label for dimming editors that are not focused"), isOn: $settings.dimEditorsWithoutFocus)
    }

    var fileExtensions: some View {
        Group {
            Picker(String(localized: "settings.general.file_extensions", defaultValue: "File Extensions", comment: "Section title for file extension display settings"), selection: $settings.fileExtensionsVisibility) {
                Text(String(localized: "settings.general.file_extensions.hide_all", defaultValue: "Hide all", comment: "Option to hide all file extensions"))
                    .tag(SettingsData.FileExtensionsVisibility.hideAll)
                Text(String(localized: "settings.general.file_extensions.show_all", defaultValue: "Show all", comment: "Option to show all file extensions"))
                    .tag(SettingsData.FileExtensionsVisibility.showAll)
                Divider()
                Text(String(localized: "settings.general.file_extensions.show_only", defaultValue: "Show only", comment: "Option to show only selected file extensions"))
                    .tag(SettingsData.FileExtensionsVisibility.showOnly)
                Text(String(localized: "settings.general.file_extensions.hide_only", defaultValue: "Hide only", comment: "Option to hide only selected file extensions"))
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
        Picker(String(localized: "settings.general.file_icon_style", defaultValue: "File Icon Style", comment: "Section title for file icon style setting"), selection: $settings.fileIconStyle) {
            Text(String(localized: "settings.general.file_icon_style.color", defaultValue: "Color", comment: "Option label for colored file icons"))
                .tag(SettingsData.FileIconStyle.color)
            Text(String(localized: "settings.general.file_icon_style.monochrome", defaultValue: "Monochrome", comment: "Option label for monochrome file icons"))
                .tag(SettingsData.FileIconStyle.monochrome)
        }
        .pickerStyle(.radioGroup)
    }

    var navigatorTabBarPosition: some View {
        Picker(String(localized: "settings.general.navigator_tab_bar_position", defaultValue: "Navigator Tab Bar Position", comment: "Section title for navigator tab bar position setting"), selection: $settings.navigatorTabBarPosition) {
            Text(String(localized: "settings.general.navigator_tab_bar_position.top", defaultValue: "Top", comment: "Option label for top navigator tab bar position"))
                .tag(SettingsData.SidebarTabBarPosition.top)
            Text(String(localized: "settings.general.navigator_tab_bar_position.side", defaultValue: "Side", comment: "Option label for side navigator tab bar position"))
                .tag(SettingsData.SidebarTabBarPosition.side)
        }
        .pickerStyle(.radioGroup)
    }

    var inspectorTabBarPosition: some View {
        Picker(String(localized: "settings.general.inspector_tab_bar_position", defaultValue: "Inspector Tab Bar Position", comment: "Section title for inspector tab bar position setting"), selection: $settings.inspectorTabBarPosition) {
            Text(String(localized: "settings.general.inspector_tab_bar_position.top", defaultValue: "Top", comment: "Option label for top inspector tab bar position"))
                .tag(SettingsData.SidebarTabBarPosition.top)
            Text(String(localized: "settings.general.inspector_tab_bar_position.side", defaultValue: "Side", comment: "Option label for side inspector tab bar position"))
                .tag(SettingsData.SidebarTabBarPosition.side)
        }
        .pickerStyle(.radioGroup)
    }

    var reopenBehavior: some View {
        Picker(String(localized: "settings.general.reopen_behavior", defaultValue: "Reopen Behavior", comment: "Section title for reopen behavior setting"), selection: $settings.reopenBehavior) {
            Text(String(localized: "settings.general.reopen_behavior.welcome_screen", defaultValue: "Welcome Screen", comment: "Option label for reopening to welcome screen"))
                .tag(SettingsData.ReopenBehavior.welcome)
            Divider()
            Text(String(localized: "settings.general.reopen_behavior.open_panel", defaultValue: "Open Panel", comment: "Option label for reopening to open panel"))
                .tag(SettingsData.ReopenBehavior.openPanel)
            Text(String(localized: "settings.general.reopen_behavior.new_document", defaultValue: "New Document", comment: "Option label for reopening to new document"))
                .tag(SettingsData.ReopenBehavior.newDocument)
        }
    }

    var afterWindowsCloseBehaviour: some View {
        Picker(
            String(localized: "settings.general.after_last_window_closed", defaultValue: "After the last window is closed", comment: "Section title for behavior after closing the last window"),
            selection: $settings.reopenWindowAfterClose
        ) {
            Text(String(localized: "settings.general.after_last_window_closed.do_nothing", defaultValue: "Do nothing", comment: "Option label to do nothing after closing the last window"))
                .tag(SettingsData.ReopenWindowBehavior.doNothing)
            Divider()
            Text(String(localized: "settings.general.after_last_window_closed.show_welcome_window", defaultValue: "Show Welcome Window", comment: "Option label to show welcome window after closing last window"))
                .tag(SettingsData.ReopenWindowBehavior.showWelcomeWindow)
            Text(String(localized: "settings.general.after_last_window_closed.quit", defaultValue: "Quit", comment: "Option label to quit app after closing last window"))
                .tag(SettingsData.ReopenWindowBehavior.quit)
        }
    }

    var projectNavigatorSize: some View {
        Picker(String(localized: "settings.general.project_navigator_size", defaultValue: "Project Navigator Size", comment: "Section title for project navigator size setting"), selection: $settings.projectNavigatorSize) {
            Text(String(localized: "settings.general.project_navigator_size.small", defaultValue: "Small", comment: "Option label for small project navigator size"))
                .tag(SettingsData.ProjectNavigatorSize.small)
            Text(String(localized: "settings.general.project_navigator_size.medium", defaultValue: "Medium", comment: "Option label for medium project navigator size"))
                .tag(SettingsData.ProjectNavigatorSize.medium)
            Text(String(localized: "settings.general.project_navigator_size.large", defaultValue: "Large", comment: "Option label for large project navigator size"))
                .tag(SettingsData.ProjectNavigatorSize.large)
        }
    }

    var findNavigatorDetail: some View {
        Picker(String(localized: "settings.general.find_navigator_detail", defaultValue: "Find Navigator Detail", comment: "Section title for find navigator detail visibility setting"), selection: $settings.findNavigatorDetail) {
            ForEach(SettingsData.NavigatorDetail.allCases, id: \.self) { tag in
                Text(tag.label).tag(tag)
            }
        }
    }

    // TODO: Implement reflecting Issue Navigator Detail preference and remove disabled modifier
    var issueNavigatorDetail: some View {
        Picker(String(localized: "settings.general.issue_navigator_detail", defaultValue: "Issue Navigator Detail", comment: "Section title for issue navigator detail visibility setting"), selection: $settings.issueNavigatorDetail) {
            ForEach(SettingsData.NavigatorDetail.allCases, id: \.self) { tag in
                Text(tag.label).tag(tag)
            }
        }
        .disabled(true)
    }

    // TODO: Implement reset for Don't Ask Me warnings Button and remove disabled modifier
    var dialogWarnings: some View {
        LabeledContent(String(localized: "settings.general.dialog_warnings", defaultValue: "Dialog Warnings", comment: "Section title for dialog warning settings")) {
            Button(action: {
            }, label: {
                Text("Reset \"Don't Ask Me\" Warnings")
            })
            .buttonStyle(.bordered)
        }
        .disabled(true)
    }

    var shellCommand: some View {
        LabeledContent(String(localized: "settings.general.shell_command.title", defaultValue: "'codeedit' Shell Command", comment: "Section title for installing the codeedit shell command")) {
            Button(action: installShellCommand, label: {
                Text(String(localized: "settings.general.shell_command.install", defaultValue: "Install", comment: "Button title to install shell command"))
            })
            .disabled(true)
            .buttonStyle(.bordered)
        }
    }

    func installShellCommand() {
        do {
            let url = Bundle.main.url(forResource: "codeedit", withExtension: nil, subdirectory: "Resources")
            let destination = "/usr/local/bin/codeedit"

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
                Button(String(localized: "settings.general.updates.check_now", defaultValue: "Check Now", comment: "Button title to manually check for updates")) {
                    updater.checkForUpdates()
                }
            } label: {
                Text(String(localized: "settings.general.updates.check_for_updates", defaultValue: "Check for updates", comment: "Section title for update checking options"))
                Text("Last checked: \(lastUpdatedString)")

            }
        }
    }

    var autoUpdateToggle: some View {
        Toggle(String(localized: "settings.general.updates.automatically_check", defaultValue: "Automatically check for app updates", comment: "Toggle label for automatically checking app updates"), isOn: $updater.automaticallyChecksForUpdates)
    }

    var prereleaseToggle: some View {
        Toggle(String(localized: "settings.general.updates.include_prerelease", defaultValue: "Include pre-release versions", comment: "Toggle label for including pre-release app versions in update checks"), isOn: $updater.includePrereleaseVersions)
    }

    var autoSave: some View {
        Toggle(String(localized: "settings.general.auto_save_changes_to_disk", defaultValue: "Automatically save changes to disk", comment: "Toggle label for automatically saving changes to disk"), isOn: $settings.isAutoSaveOn)
    }

    // MARK: - Preference Views

    private var lastUpdatedString: String {
        if let lastUpdatedDate = updater.lastUpdateCheckDate {
            return Self.formatter.string(from: lastUpdatedDate)
        } else {
            return String(localized: "general_settings.update_checker.never", defaultValue: "Never", comment: "Option label indicating updates are never checked automatically")
        }
    }

    private static func configure<Subject>(_ subject: Subject, configuration: (inout Subject) -> Void) -> Subject {
        var copy = subject
        configuration(&copy)
        return copy
    }

    func fallbackShellInstallation(commandPath: String, destinationPath: String) {
        let cmd = [
            "osascript",
            "-e",
            "\"do shell script \\\"mkdir -p /usr/local/bin && ln -sf \'\(commandPath)\' \'\(destinationPath)\'\\\"\"",
            "with administrator privileges"
        ]

        let cmdStr = cmd.joined(separator: " ")

        let task = Process()
        let pipe = Pipe()

        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", cmdStr]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        task.standardInput = nil

        do {
            try task.run()
        } catch {
            print(error)
        }
    }

    var openInCodeEditToggle: some View {
        Toggle(String(localized: "settings.general.finder.show_open_with_codeedit", defaultValue: "Show “Open With CodeEdit” option in Finder", comment: "Toggle label for showing Open With CodeEdit Finder integration"), isOn: $openInCodeEdit)
            .onChange(of: openInCodeEdit) { _, newValue in
                guard let defaults = UserDefaults.init(
                    suiteName: "app.codeedit.CodeEdit.shared"
                ) else {
                    print("Failed to get/init shared defaults")
                    return
                }

                defaults.set(newValue, forKey: "enableOpenInCE")
            }
    }

    var revealFileOnFocusChangeToggle: some View {
        Toggle("Automatically reveal in project navigator", isOn: $settings.revealFileOnFocusChange)
    }

    private static let formatter = configure(DateFormatter()) {
        $0.dateStyle = .medium
        $0.timeStyle = .medium
    }
}
