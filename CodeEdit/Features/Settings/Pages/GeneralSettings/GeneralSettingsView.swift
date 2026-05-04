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
        Picker(String(localized: "settings.general.appearance", defaultValue: "Appearance", comment: "Label for appearance setting"), selection: $settings.appAppearance) {
            Text(String(localized: "settings.general.appearance.system", defaultValue: "System", comment: "Appearance option to use system setting"))
                .tag(SettingsData.Appearances.system)
            Divider()
            Text(String(localized: "settings.general.appearance.light", defaultValue: "Light", comment: "Light appearance mode"))
                .tag(SettingsData.Appearances.light)
            Text(String(localized: "settings.general.appearance.dark", defaultValue: "Dark", comment: "Dark appearance mode"))
                .tag(SettingsData.Appearances.dark)
        }
        .onChange(of: settings.appAppearance) { _, tag in
            tag.applyAppearance()
        }
    }

    // TODO: Implement reflecting Show Issues preference and remove disabled modifier
    var showIssues: some View {
        Picker(String(localized: "settings.general.show-issues", defaultValue: "Show Issues", comment: "Label for show issues setting"), selection: $settings.showIssues) {
            Text(String(localized: "settings.general.show-issues.inline", defaultValue: "Show Inline", comment: "Option to show issues inline"))
                .tag(SettingsData.Issues.inline)
            Text(String(localized: "settings.general.show-issues.minimized", defaultValue: "Show Minimized", comment: "Option to show issues minimized"))
                .tag(SettingsData.Issues.minimized)
        }
    }

    var showLiveIssues: some View {
        Toggle(String(localized: "settings.general.show-live-issues", defaultValue: "Show Live Issues", comment: "Toggle to show live issues in the editor"), isOn: $settings.showLiveIssues)
    }

    var showEditorJumpBar: some View {
        Toggle(String(localized: "settings.general.show-jump-bar", defaultValue: "Show Jump Bar", comment: "Toggle to show the jump bar"), isOn: $settings.showEditorJumpBar)
    }

    var dimEditorsWithoutFocus: some View {
        Toggle(String(localized: "settings.general.dim-unfocused-editors", defaultValue: "Dim editors without focus", comment: "Toggle to dim editors that don't have focus"), isOn: $settings.dimEditorsWithoutFocus)
    }

    var fileExtensions: some View {
        Group {
            Picker(String(localized: "settings.general.file-extensions", defaultValue: "File Extensions", comment: "Label for file extensions visibility setting"), selection: $settings.fileExtensionsVisibility) {
                Text(String(localized: "settings.general.file-extensions.hide-all", defaultValue: "Hide all", comment: "Option to hide all file extensions"))
                    .tag(SettingsData.FileExtensionsVisibility.hideAll)
                Text(String(localized: "settings.general.file-extensions.show-all", defaultValue: "Show all", comment: "Option to show all file extensions"))
                    .tag(SettingsData.FileExtensionsVisibility.showAll)
                Divider()
                Text(String(localized: "settings.general.file-extensions.show-only", defaultValue: "Show only", comment: "Option to show only selected file extensions"))
                    .tag(SettingsData.FileExtensionsVisibility.showOnly)
                Text(String(localized: "settings.general.file-extensions.hide-only", defaultValue: "Hide only", comment: "Option to hide only selected file extensions"))
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
        Picker(String(localized: "settings.general.file-icon-style", defaultValue: "File Icon Style", comment: "Label for file icon style setting"), selection: $settings.fileIconStyle) {
            Text(String(localized: "settings.general.file-icon-style.color", defaultValue: "Color", comment: "Option for colored file icons"))
                .tag(SettingsData.FileIconStyle.color)
            Text(String(localized: "settings.general.file-icon-style.monochrome", defaultValue: "Monochrome", comment: "Option for monochrome file icons"))
                .tag(SettingsData.FileIconStyle.monochrome)
        }
        .pickerStyle(.radioGroup)
    }

    var navigatorTabBarPosition: some View {
        Picker(String(localized: "settings.general.navigator-tab-bar-position", defaultValue: "Navigator Tab Bar Position", comment: "Label for navigator tab bar position setting"), selection: $settings.navigatorTabBarPosition) {
            Text(String(localized: "settings.general.tab-bar-position.top", defaultValue: "Top", comment: "Option for tab bar at top"))
                .tag(SettingsData.SidebarTabBarPosition.top)
            Text(String(localized: "settings.general.tab-bar-position.side", defaultValue: "Side", comment: "Option for tab bar at side"))
                .tag(SettingsData.SidebarTabBarPosition.side)
        }
        .pickerStyle(.radioGroup)
    }

    var inspectorTabBarPosition: some View {
        Picker(String(localized: "settings.general.inspector-tab-bar-position", defaultValue: "Inspector Tab Bar Position", comment: "Label for inspector tab bar position setting"), selection: $settings.inspectorTabBarPosition) {
            Text(String(localized: "settings.general.tab-bar-position.top", defaultValue: "Top", comment: "Option for tab bar at top"))
                .tag(SettingsData.SidebarTabBarPosition.top)
            Text(String(localized: "settings.general.tab-bar-position.side", defaultValue: "Side", comment: "Option for tab bar at side"))
                .tag(SettingsData.SidebarTabBarPosition.side)
        }
        .pickerStyle(.radioGroup)
    }

    var reopenBehavior: some View {
        Picker(String(localized: "settings.general.reopen-behavior", defaultValue: "Reopen Behavior", comment: "Label for reopen behavior setting"), selection: $settings.reopenBehavior) {
            Text(String(localized: "settings.general.reopen-behavior.welcome-screen", defaultValue: "Welcome Screen", comment: "Option to show welcome screen on reopen"))
                .tag(SettingsData.ReopenBehavior.welcome)
            Divider()
            Text(String(localized: "settings.general.reopen-behavior.open-panel", defaultValue: "Open Panel", comment: "Option to show open panel on reopen"))
                .tag(SettingsData.ReopenBehavior.openPanel)
            Text(String(localized: "settings.general.reopen-behavior.new-document", defaultValue: "New Document", comment: "Option to create new document on reopen"))
                .tag(SettingsData.ReopenBehavior.newDocument)
        }
    }

    var afterWindowsCloseBehaviour: some View {
        Picker(
            String(localized: "settings.general.after-last-window-closed", defaultValue: "After the last window is closed", comment: "Label for behavior after last window closes"),
            selection: $settings.reopenWindowAfterClose
        ) {
            Text(String(localized: "settings.general.after-last-window-closed.do-nothing", defaultValue: "Do nothing", comment: "Option to do nothing after last window closes"))
                .tag(SettingsData.ReopenWindowBehavior.doNothing)
            Divider()
            Text(String(localized: "settings.general.after-last-window-closed.show-welcome", defaultValue: "Show Welcome Window", comment: "Option to show welcome window after last window closes"))
                .tag(SettingsData.ReopenWindowBehavior.showWelcomeWindow)
            Text(String(localized: "settings.general.after-last-window-closed.quit", defaultValue: "Quit", comment: "Option to quit app after last window closes"))
                .tag(SettingsData.ReopenWindowBehavior.quit)
        }
    }

    var projectNavigatorSize: some View {
        Picker(String(localized: "settings.general.project-navigator-size", defaultValue: "Project Navigator Size", comment: "Label for project navigator size setting"), selection: $settings.projectNavigatorSize) {
            Text(String(localized: "settings.general.project-navigator-size.small", defaultValue: "Small", comment: "Small size option for project navigator"))
                .tag(SettingsData.ProjectNavigatorSize.small)
            Text(String(localized: "settings.general.project-navigator-size.medium", defaultValue: "Medium", comment: "Medium size option for project navigator"))
                .tag(SettingsData.ProjectNavigatorSize.medium)
            Text(String(localized: "settings.general.project-navigator-size.large", defaultValue: "Large", comment: "Large size option for project navigator"))
                .tag(SettingsData.ProjectNavigatorSize.large)
        }
    }

    var findNavigatorDetail: some View {
        Picker(String(localized: "settings.general.find-navigator-detail", defaultValue: "Find Navigator Detail", comment: "Label for find navigator detail setting"), selection: $settings.findNavigatorDetail) {
            ForEach(SettingsData.NavigatorDetail.allCases, id: \.self) { tag in
                Text(tag.label).tag(tag)
            }
        }
    }

    // TODO: Implement reflecting Issue Navigator Detail preference and remove disabled modifier
    var issueNavigatorDetail: some View {
        Picker(String(localized: "settings.general.issue-navigator-detail", defaultValue: "Issue Navigator Detail", comment: "Label for issue navigator detail setting"), selection: $settings.issueNavigatorDetail) {
            ForEach(SettingsData.NavigatorDetail.allCases, id: \.self) { tag in
                Text(tag.label).tag(tag)
            }
        }
        .disabled(true)
    }

    // TODO: Implement reset for Don't Ask Me warnings Button and remove disabled modifier
    var dialogWarnings: some View {
        LabeledContent(String(localized: "settings.general.dialog-warnings", defaultValue: "Dialog Warnings", comment: "Label for dialog warnings setting")) {
            Button(action: {
            }, label: {
                Text(String(localized: "settings.general.dialog-warnings.reset", defaultValue: "Reset \"Don't Ask Me\" Warnings", comment: "Button to reset don't ask me warnings"))
            })
            .buttonStyle(.bordered)
        }
        .disabled(true)
    }

    var shellCommand: some View {
        LabeledContent(String(localized: "settings.general.shell-command", defaultValue: "'codeedit' Shell Command", comment: "Label for shell command installation setting")) {
            Button(action: installShellCommand, label: {
                Text(String(localized: "settings.general.shell-command.install", defaultValue: "Install", comment: "Button to install shell command"))
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
                Button(String(localized: "settings.general.updates.check-now", defaultValue: "Check Now", comment: "Button to check for updates now")) {
                    updater.checkForUpdates()
                }
            } label: {
                Text(String(localized: "settings.general.updates.check-for-updates", defaultValue: "Check for updates", comment: "Label for check for updates setting"))
                Text(String(format: String(localized: "settings.general.updates.last-checked", defaultValue: "Last checked: %@", comment: "Last update check time"), lastUpdatedString))

            }
        }
    }

    var autoUpdateToggle: some View {
        Toggle(String(localized: "settings.general.updates.auto-check", defaultValue: "Automatically check for app updates", comment: "Toggle to automatically check for app updates"), isOn: $updater.automaticallyChecksForUpdates)
    }

    var prereleaseToggle: some View {
        Toggle(String(localized: "settings.general.updates.include-prerelease", defaultValue: "Include pre-release versions", comment: "Toggle to include pre-release versions"), isOn: $updater.includePrereleaseVersions)
    }

    var autoSave: some View {
        Toggle(String(localized: "settings.general.auto-save", defaultValue: "Automatically save changes to disk", comment: "Toggle to automatically save changes"), isOn: $settings.isAutoSaveOn)
    }

    // MARK: - Preference Views

    private var lastUpdatedString: String {
        if let lastUpdatedDate = updater.lastUpdateCheckDate {
            return Self.formatter.string(from: lastUpdatedDate)
        } else {
            return String(localized: "settings.general.updates.never", defaultValue: "Never", comment: "Indicates updates have never been checked")
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
        Toggle(String(localized: "settings.general.open-with-codeedit", defaultValue: "Show \"Open With CodeEdit\" option in Finder", comment: "Toggle to show Open With CodeEdit in Finder context menu"), isOn: $openInCodeEdit)
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
        Toggle(String(localized: "settings.general.auto-reveal-in-navigator", defaultValue: "Automatically reveal in project navigator", comment: "Toggle to automatically reveal files in project navigator"), isOn: $settings.revealFileOnFocusChange)
    }

    private static let formatter = configure(DateFormatter()) {
        $0.dateStyle = .medium
        $0.timeStyle = .medium
    }
}
