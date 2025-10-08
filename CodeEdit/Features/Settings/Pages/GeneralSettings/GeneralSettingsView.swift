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
        Picker(String(localized: "general_settings.appearance", comment: "Appearance setting label"), selection: $settings.appAppearance) {
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
        Picker(String(localized: "general_settings.show_issues", comment: "Show issues setting label"), selection: $settings.showIssues) {
            Text(String(localized: "general_settings.show_inline", comment: "Show inline issues option"))
                .tag(SettingsData.Issues.inline)
            Text(String(localized: "general_settings.show_minimized", comment: "Show minimized issues option"))
                .tag(SettingsData.Issues.minimized)
        }
    }

    var showLiveIssues: some View {
        Toggle(String(localized: "general_settings.show_live_issues", comment: "Show live issues setting"), isOn: $settings.showLiveIssues)
    }

    var showEditorJumpBar: some View {
        Toggle(String(localized: "general_settings.show_jump_bar", comment: "Show jump bar setting"), isOn: $settings.showEditorJumpBar)
    }

    var dimEditorsWithoutFocus: some View {
        Toggle(String(localized: "general_settings.dim_unfocused_editors", comment: "Dim editors without focus setting"), isOn: $settings.dimEditorsWithoutFocus)
    }

    var fileExtensions: some View {
        Group {
            Picker(String(localized: "general_settings.file_extensions", comment: "File extensions setting label"), selection: $settings.fileExtensionsVisibility) {
                Text(String(localized: "general_settings.hide_all", comment: "Hide all file extensions option"))
                    .tag(SettingsData.FileExtensionsVisibility.hideAll)
                Text(String(localized: "general_settings.show_all", comment: "Show all file extensions option"))
                    .tag(SettingsData.FileExtensionsVisibility.showAll)
                Divider()
                Text(String(localized: "general_settings.show_only", comment: "Show only specific extensions option"))
                    .tag(SettingsData.FileExtensionsVisibility.showOnly)
                Text(String(localized: "general_settings.hide_only", comment: "Hide only specific extensions option"))
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
        Picker(String(localized: "general_settings.file_icon_style", comment: "File icon style setting label"), selection: $settings.fileIconStyle) {
            Text(String(localized: "general_settings.color", comment: "Color icon style option"))
                .tag(SettingsData.FileIconStyle.color)
            Text(String(localized: "general_settings.monochrome", comment: "Monochrome icon style option"))
                .tag(SettingsData.FileIconStyle.monochrome)
        }
        .pickerStyle(.radioGroup)
    }

    var navigatorTabBarPosition: some View {
        Picker(String(localized: "general_settings.navigator_tab_bar_position", comment: "Navigator tab bar position setting label"), selection: $settings.navigatorTabBarPosition) {
            Text(String(localized: "general_settings.top", comment: "Top position option"))
                .tag(SettingsData.SidebarTabBarPosition.top)
            Text(String(localized: "general_settings.tab_bar_position.side", comment: "Option for side position of tab bar"))
                .tag(SettingsData.SidebarTabBarPosition.side)
        }
        .pickerStyle(.radioGroup)
    }

    var inspectorTabBarPosition: some View {
        Picker(String(localized: "general_settings.inspector_tab_bar_position.title", comment: "Label for inspector tab bar position setting"), selection: $settings.inspectorTabBarPosition) {
            Text("Top")
                .tag(SettingsData.SidebarTabBarPosition.top)
            Text("Side")
                .tag(SettingsData.SidebarTabBarPosition.side)
        }
        .pickerStyle(.radioGroup)
    }

    var reopenBehavior: some View {
        Picker(String(localized: "general_settings.reopen_behavior.title", comment: "Label for reopen behavior setting"), selection: $settings.reopenBehavior) {
            Text(String(localized: "general_settings.reopen_behavior.welcome_screen", comment: "Option to show welcome screen on reopen"))
                .tag(SettingsData.ReopenBehavior.welcome)
            Divider()
            Text(String(localized: "general_settings.reopen_behavior.open_panel", comment: "Option to show open panel on reopen"))
                .tag(SettingsData.ReopenBehavior.openPanel)
            Text(String(localized: "general_settings.reopen_behavior.new_document", comment: "Option to create new document on reopen"))
                .tag(SettingsData.ReopenBehavior.newDocument)
        }
    }

    var afterWindowsCloseBehaviour: some View {
        Picker(
            String(localized: "general_settings.after_last_window_closed.title", comment: "Label for behavior after last window is closed"),
            selection: $settings.reopenWindowAfterClose
        ) {
            Text(String(localized: "general_settings.after_last_window_closed.do_nothing", comment: "Option to do nothing after last window closed"))
                .tag(SettingsData.ReopenWindowBehavior.doNothing)
            Divider()
            Text(String(localized: "general_settings.after_last_window_closed.show_welcome", comment: "Option to show welcome window after last window closed"))
                .tag(SettingsData.ReopenWindowBehavior.showWelcomeWindow)
            Text(String(localized: "general_settings.after_last_window_closed.quit", comment: "Option to quit after last window closed"))
                .tag(SettingsData.ReopenWindowBehavior.quit)
        }
    }

    var projectNavigatorSize: some View {
        Picker(String(localized: "general_settings.project_navigator_size.title", comment: "Label for project navigator size setting"), selection: $settings.projectNavigatorSize) {
            Text(String(localized: "general_settings.size.small", comment: "Small size option"))
                .tag(SettingsData.ProjectNavigatorSize.small)
            Text(String(localized: "general_settings.size.medium", comment: "Medium size option"))
                .tag(SettingsData.ProjectNavigatorSize.medium)
            Text(String(localized: "general_settings.size.large", comment: "Large size option"))
                .tag(SettingsData.ProjectNavigatorSize.large)
        }
    }

    var findNavigatorDetail: some View {
        Picker(String(localized: "general_settings.find_navigator_detail.title", comment: "Label for find navigator detail setting"), selection: $settings.findNavigatorDetail) {
            ForEach(SettingsData.NavigatorDetail.allCases, id: \.self) { tag in
                Text(tag.label).tag(tag)
            }
        }
    }

    // TODO: Implement reflecting Issue Navigator Detail preference and remove disabled modifier
    var issueNavigatorDetail: some View {
        Picker(String(localized: "general_settings.issue_navigator_detail.title", comment: "Label for issue navigator detail setting"), selection: $settings.issueNavigatorDetail) {
            ForEach(SettingsData.NavigatorDetail.allCases, id: \.self) { tag in
                Text(tag.label).tag(tag)
            }
        }
        .disabled(true)
    }

    // TODO: Implement reset for Don't Ask Me warnings Button and remove disabled modifier
    var dialogWarnings: some View {
        LabeledContent(String(localized: "general_settings.dialog_warnings.title", comment: "Label for dialog warnings setting")) {
            Button(action: {
            }, label: {
                Text(String(localized: "general_settings.dialog_warnings.reset_button", comment: "Button to reset dialog warnings"))
            })
            .buttonStyle(.bordered)
        }
        .disabled(true)
    }

    var shellCommand: some View {
        LabeledContent(String(localized: "general.settings.shell_command", comment: "Label for codeedit shell command installation section")) {
            Button(action: installShellCommand, label: {
                Text(String(localized: "general.settings.install", comment: "Button text for installing shell command"))
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
                Button(String(localized: "general.settings.check_now", comment: "Button text for checking for updates")) {
                    updater.checkForUpdates()
                }
            } label: {
                Text(String(localized: "general.settings.check_for_updates", comment: "Label for update checking section"))
                Text("Last checked: \(lastUpdatedString)")

            }
        }
    }

    var autoUpdateToggle: some View {
        Toggle(String(localized: "general.settings.auto_check_updates", comment: "Toggle for automatically checking for app updates"), isOn: $updater.automaticallyChecksForUpdates)
    }

    var prereleaseToggle: some View {
        Toggle(String(localized: "general.settings.include_prereleases", comment: "Toggle for including pre-release versions in updates"), isOn: $updater.includePrereleaseVersions)
    }

    var autoSave: some View {
        Toggle(String(localized: "general.settings.auto_save", comment: "Toggle for automatically saving changes to disk"), isOn: $settings.isAutoSaveOn)
    }

    // MARK: - Preference Views

    private var lastUpdatedString: String {
        if let lastUpdatedDate = updater.lastUpdateCheckDate {
            return Self.formatter.string(from: lastUpdatedDate)
        } else {
            return String(localized: "general.settings.never", comment: "Text shown when updates have never been checked")
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
        Toggle(String(localized: "general.settings.auto_reveal_navigator", comment: "Toggle for automatically revealing files in project navigator"), isOn: $settings.revealFileOnFocusChange)
    }

    private static let formatter = configure(DateFormatter()) {
        $0.dateStyle = .medium
        $0.timeStyle = .medium
    }
}
