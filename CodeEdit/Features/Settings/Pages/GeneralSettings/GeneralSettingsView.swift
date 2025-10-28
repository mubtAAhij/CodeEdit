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
        Picker("settings.general.appearance", comment: "Appearance picker label", selection: $settings.appAppearance) {
            Text("settings.general.appearance.system", comment: "System appearance option")
                .tag(SettingsData.Appearances.system)
            Divider()
            Text("settings.general.appearance.light", comment: "Light appearance option")
                .tag(SettingsData.Appearances.light)
            Text("settings.general.appearance.dark", comment: "Dark appearance option")
                .tag(SettingsData.Appearances.dark)
        }
        .onChange(of: settings.appAppearance) { tag in
            tag.applyAppearance()
        }
    }

    // TODO: Implement reflecting Show Issues preference and remove disabled modifier
    var showIssues: some View {
        Picker("settings.general.show_issues", comment: "Show Issues picker label", selection: $settings.showIssues) {
            Text("settings.general.show_issues.inline", comment: "Show issues inline option")
                .tag(SettingsData.Issues.inline)
            Text("settings.general.show_issues.minimized", comment: "Show issues minimized option")
                .tag(SettingsData.Issues.minimized)
        }
    }

    var showLiveIssues: some View {
        Toggle("settings.general.show_live_issues", comment: "Toggle for showing live issues", isOn: $settings.showLiveIssues)
    }

    var showEditorJumpBar: some View {
        Toggle("settings.general.show_jump_bar", comment: "Toggle for showing jump bar", isOn: $settings.showEditorJumpBar)
    }

    var dimEditorsWithoutFocus: some View {
        Toggle("settings.general.dim_editors_without_focus", comment: "Toggle for dimming editors without focus", isOn: $settings.dimEditorsWithoutFocus)
    }

    var fileExtensions: some View {
        Group {
            Picker("settings.general.file_extensions", comment: "File Extensions picker label", selection: $settings.fileExtensionsVisibility) {
                Text("settings.general.file_extensions.hide_all", comment: "Hide all file extensions option")
                    .tag(SettingsData.FileExtensionsVisibility.hideAll)
                Text("settings.general.file_extensions.show_all", comment: "Show all file extensions option")
                    .tag(SettingsData.FileExtensionsVisibility.showAll)
                Divider()
                Text("settings.general.file_extensions.show_only", comment: "Show only specific file extensions option")
                    .tag(SettingsData.FileExtensionsVisibility.showOnly)
                Text("settings.general.file_extensions.hide_only", comment: "Hide only specific file extensions option")
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
        Picker("settings.general.file_icon_style", comment: "File Icon Style picker label", selection: $settings.fileIconStyle) {
            Text("settings.general.file_icon_style.color", comment: "Color file icon style option")
                .tag(SettingsData.FileIconStyle.color)
            Text("settings.general.file_icon_style.monochrome", comment: "Monochrome file icon style option")
                .tag(SettingsData.FileIconStyle.monochrome)
        }
        .pickerStyle(.radioGroup)
    }

    var navigatorTabBarPosition: some View {
        Picker("settings.general.navigator_tab_bar_position", comment: "Navigator Tab Bar Position picker label", selection: $settings.navigatorTabBarPosition) {
            Text("settings.general.navigator_tab_bar_position.top", comment: "Top position option")
                .tag(SettingsData.SidebarTabBarPosition.top)
            Text("settings.general.navigator_tab_bar_position.side", comment: "Side position option")
                .tag(SettingsData.SidebarTabBarPosition.side)
        }
        .pickerStyle(.radioGroup)
    }

    var inspectorTabBarPosition: some View {
        Picker("settings.general.inspector_tab_bar_position", comment: "Inspector Tab Bar Position picker label", selection: $settings.inspectorTabBarPosition) {
            Text("settings.general.inspector_tab_bar_position.top", comment: "Top position option")
                .tag(SettingsData.SidebarTabBarPosition.top)
            Text("settings.general.inspector_tab_bar_position.side", comment: "Side position option")
                .tag(SettingsData.SidebarTabBarPosition.side)
        }
        .pickerStyle(.radioGroup)
    }

    var reopenBehavior: some View {
        Picker("settings.general.reopen_behavior", comment: "Reopen Behavior picker label", selection: $settings.reopenBehavior) {
            Text("settings.general.reopen_behavior.welcome_screen", comment: "Welcome Screen option")
                .tag(SettingsData.ReopenBehavior.welcome)
            Divider()
            Text("settings.general.reopen_behavior.open_panel", comment: "Open Panel option")
                .tag(SettingsData.ReopenBehavior.openPanel)
            Text("settings.general.reopen_behavior.new_document", comment: "New Document option")
                .tag(SettingsData.ReopenBehavior.newDocument)
        }
    }

    var afterWindowsCloseBehaviour: some View {
        Picker(
            "settings.general.after_last_window_closed",
            comment: "After the last window is closed picker label",
            selection: $settings.reopenWindowAfterClose
        ) {
            Text("settings.general.after_last_window_closed.do_nothing", comment: "Do nothing option")
                .tag(SettingsData.ReopenWindowBehavior.doNothing)
            Divider()
            Text("settings.general.after_last_window_closed.show_welcome_window", comment: "Show Welcome Window option")
                .tag(SettingsData.ReopenWindowBehavior.showWelcomeWindow)
            Text("settings.general.after_last_window_closed.quit", comment: "Quit option")
                .tag(SettingsData.ReopenWindowBehavior.quit)
        }
    }

    var projectNavigatorSize: some View {
        Picker("settings.general.project_navigator_size", comment: "Project Navigator Size picker label", selection: $settings.projectNavigatorSize) {
            Text("settings.general.project_navigator_size.small", comment: "Small size option")
                .tag(SettingsData.ProjectNavigatorSize.small)
            Text("settings.general.project_navigator_size.medium", comment: "Medium size option")
                .tag(SettingsData.ProjectNavigatorSize.medium)
            Text("settings.general.project_navigator_size.large", comment: "Large size option")
                .tag(SettingsData.ProjectNavigatorSize.large)
        }
    }

    var findNavigatorDetail: some View {
        Picker("settings.general.find_navigator_detail", comment: "Find Navigator Detail picker label", selection: $settings.findNavigatorDetail) {
            ForEach(SettingsData.NavigatorDetail.allCases, id: \.self) { tag in
                Text(tag.label).tag(tag)
            }
        }
    }

    // TODO: Implement reflecting Issue Navigator Detail preference and remove disabled modifier
    var issueNavigatorDetail: some View {
        Picker("settings.general.issue_navigator_detail", comment: "Issue Navigator Detail picker label", selection: $settings.issueNavigatorDetail) {
            ForEach(SettingsData.NavigatorDetail.allCases, id: \.self) { tag in
                Text(tag.label).tag(tag)
            }
        }
        .disabled(true)
    }

    // TODO: Implement reset for Don't Ask Me warnings Button and remove disabled modifier
    var dialogWarnings: some View {
        LabeledContent("settings.general.dialog_warnings", comment: "Dialog Warnings label") {
            Button(action: {
            }, label: {
                Text("settings.general.dialog_warnings.reset_button", comment: "Reset Don't Ask Me Warnings button")
            })
            .buttonStyle(.bordered)
        }
        .disabled(true)
    }

    var shellCommand: some View {
        LabeledContent("settings.general.shell_command", comment: "Shell command label") {
            Button(action: installShellCommand, label: {
                Text("settings.general.shell_command.install", comment: "Install button")
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
                Button("settings.general.updates.check_now", comment: "Check now button") {
                    updater.checkForUpdates()
                }
            } label: {
                Text("settings.general.updates.check_for_updates", comment: "Check for updates label")
                Text("settings.general.updates.last_checked \\(lastUpdatedString)", comment: "Last checked timestamp")

            }
        }
    }

    var autoUpdateToggle: some View {
        Toggle("settings.general.updates.auto_check", comment: "Automatically check for updates toggle", isOn: $updater.automaticallyChecksForUpdates)
    }

    var prereleaseToggle: some View {
        Toggle("settings.general.updates.include_prerelease", comment: "Include pre-release versions toggle", isOn: $updater.includePrereleaseVersions)
    }

    var autoSave: some View {
        Toggle("settings.general.auto_save", comment: "Auto save toggle", isOn: $settings.isAutoSaveOn)
    }

    // MARK: - Preference Views

    private var lastUpdatedString: String {
        if let lastUpdatedDate = updater.lastUpdateCheckDate {
            return Self.formatter.string(from: lastUpdatedDate)
        } else {
            return String(localized: "settings.general.updates.never", comment: "Never checked label")
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
        Toggle("settings.general.open_with_codeedit", comment: "Show Open With CodeEdit in Finder toggle", isOn: $openInCodeEdit)
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
        Toggle("settings.general.auto_reveal", comment: "Auto reveal in navigator toggle", isOn: $settings.revealFileOnFocusChange)
    }

    private static let formatter = configure(DateFormatter()) {
        $0.dateStyle = .medium
        $0.timeStyle = .medium
    }
}
