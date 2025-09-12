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
        Picker("Appearance", selection: $settings.appAppearance) {
            Text("System")
                .tag(SettingsData.Appearances.system)
            Divider()
            Text("Light")
                .tag(SettingsData.Appearances.light)
            Text("Dark")
                .tag(SettingsData.Appearances.dark)
        }
        .onChange(of: settings.appAppearance) { tag in
            tag.applyAppearance()
        }
    }

    // TODO: Implement reflecting Show Issues preference and remove disabled modifier
    var showIssues: some View {
        Picker("String(localized: "show_issues", comment: "Label for show issues preference")", selection: $settings.showIssues) {
            Text("String(localized: "show_inline", comment: "Option to show issues inline")")
                .tag(SettingsData.Issues.inline)
            Text("String(localized: "show_minimized", comment: "Option to show issues in minimized form")")
                .tag(SettingsData.Issues.minimized)
        }
    }

    var showLiveIssues: some View {
        Toggle("String(localized: "show_live_issues", comment: "Toggle to show live issues while typing")", isOn: $settings.showLiveIssues)
    }

    var showEditorJumpBar: some View {
        Toggle("String(localized: "show_jump_bar", comment: "Toggle to show the editor jump bar")", isOn: $settings.showEditorJumpBar)
    }

    var dimEditorsWithoutFocus: some View {
        Toggle("String(localized: "dim_editors_without_focus", comment: "Toggle to dim editors that don't have focus")", isOn: $settings.dimEditorsWithoutFocus)
    }

    var fileExtensions: some View {
        Group {
            Picker("String(localized: "file_extensions", comment: "Label for file extensions preference")", selection: $settings.fileExtensionsVisibility) {
                Text("String(localized: "hide_all", comment: "Option to hide all file extensions")")
                    .tag(SettingsData.FileExtensionsVisibility.hideAll)
                Text("String(localized: "show_all", comment: "Option to show all file extensions")")
                    .tag(SettingsData.FileExtensionsVisibility.showAll)
                Divider()
                Text(String(localized: "show_only", comment: "Option to show only specific file extensions"))
                    .tag(SettingsData.FileExtensionsVisibility.showOnly)
                Text(String(localized: "hide_only", comment: "Option to hide only specific file extensions"))
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
        Picker("File Icon Style", selection: $settings.fileIconStyle) {
            Text("Color")
                .tag(SettingsData.FileIconStyle.color)
            Text("Monochrome")
                .tag(SettingsData.FileIconStyle.monochrome)
        }
        .pickerStyle(.radioGroup)
    }

    var navigatorTabBarPosition: some View {
        Picker(String(localized: "navigator_tab_bar_position", comment: "Label for navigator tab bar position setting"), selection: $settings.navigatorTabBarPosition) {
            Text(String(localized: "top", comment: "Top position option"))
                .tag(SettingsData.SidebarTabBarPosition.top)
            Text(String(localized: "side", comment: "Side position option"))
                .tag(SettingsData.SidebarTabBarPosition.side)
        }
        .pickerStyle(.radioGroup)
    }

    var inspectorTabBarPosition: some View {
        Picker(String(localized: "inspector_tab_bar_position", comment: "Label for inspector tab bar position setting"), selection: $settings.inspectorTabBarPosition) {
            Text(String(localized: "top", comment: "Top position option"))
                .tag(SettingsData.SidebarTabBarPosition.top)
            Text(String(localized: "side", comment: "Side position option"))
                .tag(SettingsData.SidebarTabBarPosition.side)
        }
        .pickerStyle(.radioGroup)
    }

    var reopenBehavior: some View {
        Picker("Reopen Behavior", selection: $settings.reopenBehavior) {
            Text("Welcome Screen")
                .tag(SettingsData.ReopenBehavior.welcome)
            Divider()
            Text("Open Panel")
                .tag(SettingsData.ReopenBehavior.openPanel)
            Text("New Document")
                .tag(SettingsData.ReopenBehavior.newDocument)
        }
    }

    var afterWindowsCloseBehaviour: some View {
        Picker(
            String(localized: "after_last_window_closed", comment: "Label for behavior after closing last window"),
            selection: $settings.reopenWindowAfterClose
        ) {
            Text(String(localized: "do_nothing", comment: "Option to do nothing after closing last window"))
                .tag(SettingsData.ReopenWindowBehavior.doNothing)
            Divider()
            Text(String(localized: "show_welcome_window", comment: "Option to show welcome window after closing last window"))
                .tag(SettingsData.ReopenWindowBehavior.showWelcomeWindow)
            Text(String(localized: "quit", comment: "Option to quit application after closing last window"))
                .tag(SettingsData.ReopenWindowBehavior.quit)
        }
    }

    var projectNavigatorSize: some View {
        Picker(String(localized: "project_navigator_size", comment: "Label for project navigator size setting"), selection: $settings.projectNavigatorSize) {
            Text(String(localized: "small", comment: "Small size option"))
                .tag(SettingsData.ProjectNavigatorSize.small)
            Text(String(localized: "medium", comment: "Medium size option"))
                .tag(SettingsData.ProjectNavigatorSize.medium)
            Text(String(localized: "large", comment: "Large size option"))
                .tag(SettingsData.ProjectNavigatorSize.large)
        }
    }

    var findNavigatorDetail: some View {
        Picker(String(localized: "find_navigator_detail", comment: "Label for find navigator detail setting"), selection: $settings.findNavigatorDetail) {
            ForEach(SettingsData.NavigatorDetail.allCases, id: \.self) { tag in
                Text(tag.label).tag(tag)
            }
        }
    }

    // TODO: Implement reflecting Issue Navigator Detail preference and remove disabled modifier
    var issueNavigatorDetail: some View {
        Picker(String(localized: "issue_navigator_detail", comment: "Label for issue navigator detail setting"), selection: $settings.issueNavigatorDetail) {
            ForEach(SettingsData.NavigatorDetail.allCases, id: \.self) { tag in
                Text(tag.label).tag(tag)
            }
        }
        .disabled(true)
    }

    // TODO: Implement reset for Don't Ask Me warnings Button and remove disabled modifier
    var dialogWarnings: some View {
        LabeledContent(String(localized: "dialog_warnings", comment: "Label for dialog warnings section")) {
            Button(action: {
            }, label: {
                Text(String(localized: "reset_dont_ask_warnings", comment: "Button to reset don't ask me warnings"))
            })
            .buttonStyle(.bordered)
        }
        .disabled(true)
    }

    var shellCommand: some View {
        LabeledContent("String(localized: "codeedit_shell_command", comment: "Label for the codeedit shell command installation section")") {
            Button(action: installShellCommand, label: {
                Text("String(localized: "install", comment: "Button text to install the shell command")")
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
                Button("String(localized: "check_now", comment: "Button text to check for updates immediately")") {
                    updater.checkForUpdates()
                }
            } label: {
                Text("String(localized: "check_for_updates", comment: "Label for the update checking section")")
                Text("String(localized: "last_checked", comment: "Text showing when updates were last checked").replacingOccurrences(of: "%@", with: lastUpdatedString)")

            }
        }
    }

    var autoUpdateToggle: some View {
        Toggle("String(localized: "automatically_check_for_app_updates", comment: "Toggle label for automatic update checking")", isOn: $updater.automaticallyChecksForUpdates)
    }

    var prereleaseToggle: some View {
        Toggle("String(localized: "include_prerelease_versions", comment: "Toggle label for including pre-release versions in updates")", isOn: $updater.includePrereleaseVersions)
    }

    var autoSave: some View {
        Toggle("String(localized: "automatically_save_changes_to_disk", comment: "Toggle label for auto-save functionality")", isOn: $settings.isAutoSaveOn)
    }

    // MARK: - Preference Views

    private var lastUpdatedString: String {
        if let lastUpdatedDate = updater.lastUpdateCheckDate {
            return Self.formatter.string(from: lastUpdatedDate)
        } else {
            return "String(localized: "never", comment: "Text indicating something never happened")"
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
        Toggle("String(localized: "automatically_reveal_in_project_navigator", comment: "Toggle label for automatically revealing files in project navigator")", isOn: $settings.revealFileOnFocusChange)
    }

    private static let formatter = configure(DateFormatter()) {
        $0.dateStyle = .medium
        $0.timeStyle = .medium
    }
}
