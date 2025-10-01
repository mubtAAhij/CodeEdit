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
        Picker(String(localized: "settings.general.appearance", comment: "Settings picker for app appearance"), selection: $settings.appAppearance) {
            Text(String(localized: "settings.general.appearance.system", comment: "System appearance option"))
                .tag(SettingsData.Appearances.system)
            Divider()
            Text(String(localized: "settings.general.appearance.light", comment: "Light appearance option"))
                .tag(SettingsData.Appearances.light)
            Text(String(localized: "settings.general.appearance.dark", comment: "Dark appearance option"))
                .tag(SettingsData.Appearances.dark)
        }
        .onChange(of: settings.appAppearance) { tag in
            tag.applyAppearance()
        }
    }

    // TODO: Implement reflecting Show Issues preference and remove disabled modifier
    var showIssues: some View {
        Picker(String(localized: "settings.general.show_issues", comment: "Settings picker for showing issues"), selection: $settings.showIssues) {
            Text(String(localized: "settings.general.show_issues.inline", comment: "Show issues inline option"))
                .tag(SettingsData.Issues.inline)
            Text(String(localized: "settings.general.show_issues.minimized", comment: "Show issues minimized option"))
                .tag(SettingsData.Issues.minimized)
        }
    }

    var showLiveIssues: some View {
        Toggle(String(localized: "settings.general.show_live_issues", comment: "Toggle to show live issues"), isOn: $settings.showLiveIssues)
    }

    var showEditorJumpBar: some View {
        Toggle(String(localized: "settings.general.show_jump_bar", comment: "Toggle to show jump bar"), isOn: $settings.showEditorJumpBar)
    }

    var dimEditorsWithoutFocus: some View {
        Toggle(String(localized: "settings.general.dim_editors_without_focus", comment: "Toggle to dim editors without focus"), isOn: $settings.dimEditorsWithoutFocus)
    }

    var fileExtensions: some View {
        Group {
            Picker(String(localized: "settings.general.file_extensions", comment: "Settings picker for file extensions visibility"), selection: $settings.fileExtensionsVisibility) {
                Text(String(localized: "settings.general.file_extensions.hide_all", comment: "Hide all file extensions option"))
                    .tag(SettingsData.FileExtensionsVisibility.hideAll)
                Text(String(localized: "settings.general.file_extensions.show_all", comment: "Show all file extensions option"))
                    .tag(SettingsData.FileExtensionsVisibility.showAll)
                Divider()
                Text(String(localized: "settings.general.file_extensions.show_only", comment: "Show only specific file extensions option"))
                    .tag(SettingsData.FileExtensionsVisibility.showOnly)
                Text(String(localized: "settings.general.file_extensions.hide_only", comment: "Hide only specific file extensions option"))
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
        Picker(String(localized: "settings.general.file_icon_style", comment: "Settings picker for file icon style"), selection: $settings.fileIconStyle) {
            Text(String(localized: "settings.file_icon_style.color", comment: "File icon style option: Color"))
                .tag(SettingsData.FileIconStyle.color)
            Text(String(localized: "settings.file_icon_style.monochrome", comment: "File icon style option: Monochrome"))
                .tag(SettingsData.FileIconStyle.monochrome)
        }
        .pickerStyle(.radioGroup)
    }

    var navigatorTabBarPosition: some View {
        Picker(String(localized: "settings.navigator_tab_bar_position.title", comment: "Settings picker title for navigator tab bar position"), selection: $settings.navigatorTabBarPosition) {
            Text(String(localized: "settings.position.top", comment: "Position option: Top"))
                .tag(SettingsData.SidebarTabBarPosition.top)
            Text(String(localized: "settings.position.side", comment: "Position option: Side"))
                .tag(SettingsData.SidebarTabBarPosition.side)
        }
        .pickerStyle(.radioGroup)
    }

    var inspectorTabBarPosition: some View {
        Picker(String(localized: "settings.inspector_tab_bar_position.title", comment: "Settings picker title for inspector tab bar position"), selection: $settings.inspectorTabBarPosition) {
            Text(String(localized: "settings.position.top", comment: "Position option: Top"))
                .tag(SettingsData.SidebarTabBarPosition.top)
            Text(String(localized: "settings.position.side", comment: "Position option: Side"))
                .tag(SettingsData.SidebarTabBarPosition.side)
        }
        .pickerStyle(.radioGroup)
    }

    var reopenBehavior: some View {
        Picker(String(localized: "settings.reopen_behavior.title", comment: "Settings picker title for reopen behavior"), selection: $settings.reopenBehavior) {
            Text(String(localized: "settings.reopen_behavior.welcome_screen", comment: "Reopen behavior option: Welcome Screen"))
                .tag(SettingsData.ReopenBehavior.welcome)
            Divider()
            Text(String(localized: "settings.reopen_behavior.open_panel", comment: "Reopen behavior option: Open Panel"))
                .tag(SettingsData.ReopenBehavior.openPanel)
            Text(String(localized: "settings.reopen_behavior.new_document", comment: "Reopen behavior option: New Document"))
                .tag(SettingsData.ReopenBehavior.newDocument)
        }
    }

    var afterWindowsCloseBehaviour: some View {
        Picker(
            String(localized: "settings.after_last_window_closed.title", comment: "Settings picker title for behavior after last window is closed"),
            selection: $settings.reopenWindowAfterClose
        ) {
            Text(String(localized: "settings.after_last_window_closed.do_nothing", comment: "Window close behavior option: Do nothing"))
                .tag(SettingsData.ReopenWindowBehavior.doNothing)
            Divider()
            Text(String(localized: "settings.after_last_window_closed.show_welcome_window", comment: "Window close behavior option: Show Welcome Window"))
                .tag(SettingsData.ReopenWindowBehavior.showWelcomeWindow)
            Text(String(localized: "settings.after_last_window_closed.quit", comment: "Window close behavior option: Quit"))
                .tag(SettingsData.ReopenWindowBehavior.quit)
        }
    }

    var projectNavigatorSize: some View {
        Picker(String(localized: "settings.project_navigator_size.title", comment: "Settings picker title for project navigator size"), selection: $settings.projectNavigatorSize) {
            Text(String(localized: "settings.size.small", comment: "Size option: Small"))
                .tag(SettingsData.ProjectNavigatorSize.small)
            Text(String(localized: "settings.size.medium", comment: "Size option: Medium"))
                .tag(SettingsData.ProjectNavigatorSize.medium)
            Text(String(localized: "settings.size.large", comment: "Size option: Large"))
                .tag(SettingsData.ProjectNavigatorSize.large)
        }
    }

    var findNavigatorDetail: some View {
        Picker(String(localized: "general_settings.find_navigator_detail", comment: "Label for find navigator detail setting"), selection: $settings.findNavigatorDetail) {
            ForEach(SettingsData.NavigatorDetail.allCases, id: \.self) { tag in
                Text(tag.label).tag(tag)
            }
        }
    }

    // TODO: Implement reflecting Issue Navigator Detail preference and remove disabled modifier
    var issueNavigatorDetail: some View {
        Picker(String(localized: "general_settings.issue_navigator_detail", comment: "Label for issue navigator detail setting"), selection: $settings.issueNavigatorDetail) {
            ForEach(SettingsData.NavigatorDetail.allCases, id: \.self) { tag in
                Text(tag.label).tag(tag)
            }
        }
        .disabled(true)
    }

    // TODO: Implement reset for Don't Ask Me warnings Button and remove disabled modifier
    var dialogWarnings: some View {
        LabeledContent(String(localized: "general_settings.dialog_warnings", comment: "Label for dialog warnings section")) {
            Button(action: {
            }, label: {
                Text("Reset \"Don't Ask Me\" Warnings")
            })
            .buttonStyle(.bordered)
        }
        .disabled(true)
    }

    var shellCommand: some View {
        LabeledContent(String(localized: "general_settings.shell_command", comment: "Label for codeedit shell command section")) {
            Button(action: installShellCommand, label: {
                Text(String(localized: "general_settings.install_button", comment: "Install button text"))
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
                Button(String(localized: "general_settings.check_now_button", comment: "Button to check for updates now")) {
                    updater.checkForUpdates()
                }
            } label: {
                Text(String(localized: "general_settings.check_for_updates", comment: "Label for check for updates section"))
                Text(String(localized: "general_settings.last_checked", arguments: [lastUpdatedString], comment: "Shows when updates were last checked"))

            }
        }
    }

    var autoUpdateToggle: some View {
        Toggle(String(localized: "general_settings.auto_check_updates", comment: "Toggle for automatic update checking"), isOn: $updater.automaticallyChecksForUpdates)
    }

    var prereleaseToggle: some View {
        Toggle(String(localized: "general_settings.include_prerelease", comment: "Toggle for including pre-release versions"), isOn: $updater.includePrereleaseVersions)
    }

    var autoSave: some View {
        Toggle(String(localized: "general_settings.auto_save", comment: "Toggle for automatic saving"), isOn: $settings.isAutoSaveOn)
    }

    // MARK: - Preference Views

    private var lastUpdatedString: String {
        if let lastUpdatedDate = updater.lastUpdateCheckDate {
            return Self.formatter.string(from: lastUpdatedDate)
        } else {
            return String(localized: "general_settings.never", comment: "Never option")
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
        Toggle(String(localized: "general_settings.auto_reveal_navigator", comment: "Toggle for automatically revealing files in project navigator"), isOn: $settings.revealFileOnFocusChange)
    }

    private static let formatter = configure(DateFormatter()) {
        $0.dateStyle = .medium
        $0.timeStyle = .medium
    }
}
