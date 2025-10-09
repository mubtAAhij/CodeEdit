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
        Picker(String(localized: "general_settings.appearance", comment: "Label for appearance settings section"), selection: $settings.appAppearance) {
            Text(String(localized: "general_settings.system", comment: "System appearance option"))
                .tag(SettingsData.Appearances.system)
            Divider()
            Text(String(localized: "general_settings.light", comment: "Light appearance option"))
                .tag(SettingsData.Appearances.light)
            Text(String(localized: "general_settings.dark", comment: "Dark appearance option"))
                .tag(SettingsData.Appearances.dark)
        }
        .onChange(of: settings.appAppearance) { tag in
            tag.applyAppearance()
        }
    }

    // TODO: Implement reflecting Show Issues preference and remove disabled modifier
    var showIssues: some View {
        Picker(String(localized: "general_settings.show_issues", comment: "Show issues setting option"), selection: $settings.showIssues) {
            Text(String(localized: "general_settings.show_inline", comment: "Show inline issues setting option"))
                .tag(SettingsData.Issues.inline)
            Text(String(localized: "general_settings.show_minimized", comment: "Show minimized issues setting option"))
                .tag(SettingsData.Issues.minimized)
        }
    }

    var showLiveIssues: some View {
        Toggle(String(localized: "general_settings.show_live_issues", comment: "Show live issues setting toggle"), isOn: $settings.showLiveIssues)
    }

    var showEditorJumpBar: some View {
        Toggle(String(localized: "general_settings.show_jump_bar", comment: "Show jump bar setting toggle"), isOn: $settings.showEditorJumpBar)
    }

    var dimEditorsWithoutFocus: some View {
        Toggle(String(localized: "general_settings.dim_unfocused_editors", comment: "Setting to dim editors without focus"), isOn: $settings.dimEditorsWithoutFocus)
    }

    var fileExtensions: some View {
        Group {
            Picker(String(localized: "general_settings.file_extensions", comment: "File extensions setting section"), selection: $settings.fileExtensionsVisibility) {
                Text(String(localized: "general_settings.hide_all", comment: "Hide all file extensions option"))
                    .tag(SettingsData.FileExtensionsVisibility.hideAll)
                Text(String(localized: "general_settings.show_all", comment: "Show all file extensions option"))
                    .tag(SettingsData.FileExtensionsVisibility.showAll)
                Divider()
                Text(String(localized: "general_settings.show_only", comment: "Show only specific file extensions option"))
                    .tag(SettingsData.FileExtensionsVisibility.showOnly)
                Text(String(localized: "general_settings.hide_only", comment: "Hide only specific file extensions option"))
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
        Picker(String(localized: "general_settings.file_icon_style", comment: "File icon style setting section"), selection: $settings.fileIconStyle) {
            Text(String(localized: "general_settings.color", comment: "Color file icon style option"))
                .tag(SettingsData.FileIconStyle.color)
            Text(String(localized: "general_settings.monochrome", comment: "Monochrome file icon style option"))
                .tag(SettingsData.FileIconStyle.monochrome)
        }
        .pickerStyle(.radioGroup)
    }

    var navigatorTabBarPosition: some View {
        Picker(String(localized: "general_settings.navigator_tab_bar_position", comment: "Navigator tab bar position setting section"), selection: $settings.navigatorTabBarPosition) {
            Text(String(localized: "general_settings.top", comment: "Top position option for navigator tab bar"))
                .tag(SettingsData.SidebarTabBarPosition.top)
            Text(String(localized: "general_settings.side", comment: "Side option for UI positioning"))
                .tag(SettingsData.SidebarTabBarPosition.side)
        }
        .pickerStyle(.radioGroup)
    }

    var inspectorTabBarPosition: some View {
        Picker(String(localized: "general_settings.inspector_tab_bar_position", comment: "Setting label for inspector tab bar position"), selection: $settings.inspectorTabBarPosition) {
            Text(String(localized: "general_settings.top", comment: "Top option for UI positioning"))
                .tag(SettingsData.SidebarTabBarPosition.top)
            Text("Side")
                .tag(SettingsData.SidebarTabBarPosition.side)
        }
        .pickerStyle(.radioGroup)
    }

    var reopenBehavior: some View {
        Picker(String(localized: "general_settings.reopen_behavior", comment: "Setting label for application reopen behavior"), selection: $settings.reopenBehavior) {
            Text(String(localized: "general_settings.welcome_screen", comment: "Welcome screen option for reopen behavior"))
                .tag(SettingsData.ReopenBehavior.welcome)
            Divider()
            Text(String(localized: "general_settings.open_panel", comment: "Open panel option for reopen behavior"))
                .tag(SettingsData.ReopenBehavior.openPanel)
            Text(String(localized: "general_settings.new_document", comment: "New document option for reopen behavior"))
                .tag(SettingsData.ReopenBehavior.newDocument)
        }
    }

    var afterWindowsCloseBehaviour: some View {
        Picker(
            String(localized: "general_settings.after_last_window_closed", comment: "Setting label for behavior after last window is closed"),
            selection: $settings.reopenWindowAfterClose
        ) {
            Text(String(localized: "general_settings.do_nothing", comment: "Do nothing option for window close behavior"))
                .tag(SettingsData.ReopenWindowBehavior.doNothing)
            Divider()
            Text(String(localized: "general_settings.show_welcome_window", comment: "Show welcome window option for window close behavior"))
                .tag(SettingsData.ReopenWindowBehavior.showWelcomeWindow)
            Text(String(localized: "general_settings.quit", comment: "Quit option for window close behavior"))
                .tag(SettingsData.ReopenWindowBehavior.quit)
        }
    }

    var projectNavigatorSize: some View {
        Picker(String(localized: "general_settings.project_navigator_size", comment: "Setting label for project navigator size"), selection: $settings.projectNavigatorSize) {
            Text(String(localized: "general_settings.small", comment: "Small size option"))
                .tag(SettingsData.ProjectNavigatorSize.small)
            Text(String(localized: "general_settings.medium", comment: "Medium size option"))
                .tag(SettingsData.ProjectNavigatorSize.medium)
            Text(String(localized: "general_settings.large", comment: "Large size option"))
                .tag(SettingsData.ProjectNavigatorSize.large)
        }
    }

    var findNavigatorDetail: some View {
        Picker(String(localized: "general_settings.find_navigator_detail", comment: "Setting label for find navigator detail"), selection: $settings.findNavigatorDetail) {
            ForEach(SettingsData.NavigatorDetail.allCases, id: \.self) { tag in
                Text(tag.label).tag(tag)
            }
        }
    }

    // TODO: Implement reflecting Issue Navigator Detail preference and remove disabled modifier
    var issueNavigatorDetail: some View {
        Picker(String(localized: "general_settings.issue_navigator_detail", comment: "Setting label for issue navigator detail"), selection: $settings.issueNavigatorDetail) {
            ForEach(SettingsData.NavigatorDetail.allCases, id: \.self) { tag in
                Text(tag.label).tag(tag)
            }
        }
        .disabled(true)
    }

    // TODO: Implement reset for Don't Ask Me warnings Button and remove disabled modifier
    var dialogWarnings: some View {
        LabeledContent(String(localized: "general_settings.dialog_warnings", comment: "Setting label for dialog warnings")) {
            Button(action: {
            }, label: {
                Text("Reset \"Don't Ask Me\" Warnings")
            })
            .buttonStyle(.bordered)
        }
        .disabled(true)
    }

    var shellCommand: some View {
        LabeledContent(String(localized: "general.shell_command", comment: "Label for shell command section")) {
            Button(action: installShellCommand, label: {
                Text(String(localized: "general.install", comment: "Install button text"))
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
                Button(String(localized: "general.check_now", comment: "Check for updates now button")) {
                    updater.checkForUpdates()
                }
            } label: {
                Text(String(localized: "general.check_for_updates", comment: "Check for updates section title"))
                Text("Last checked: \(lastUpdatedString)")

            }
        }
    }

    var autoUpdateToggle: some View {
        Toggle(String(localized: "general.auto_check_updates", comment: "Automatically check for updates option"), isOn: $updater.automaticallyChecksForUpdates)
    }

    var prereleaseToggle: some View {
        Toggle(String(localized: "general.include_prerelease", comment: "Include pre-release versions option"), isOn: $updater.includePrereleaseVersions)
    }

    var autoSave: some View {
        Toggle(String(localized: "general.auto_save", comment: "Automatically save changes option"), isOn: $settings.isAutoSaveOn)
    }

    // MARK: - Preference Views

    private var lastUpdatedString: String {
        if let lastUpdatedDate = updater.lastUpdateCheckDate {
            return Self.formatter.string(from: lastUpdatedDate)
        } else {
            return String(localized: "general.never", comment: "Never option")
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
        Toggle("Show “Open With CodeEdit” option in Finder", isOn: $openInCodeEdit)
            .onChange(of: openInCodeEdit) { newValue in
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
        Toggle(String(localized: "general.auto_reveal", comment: "Automatically reveal in project navigator option"), isOn: $settings.revealFileOnFocusChange)
    }

    private static let formatter = configure(DateFormatter()) {
        $0.dateStyle = .medium
        $0.timeStyle = .medium
    }
}
