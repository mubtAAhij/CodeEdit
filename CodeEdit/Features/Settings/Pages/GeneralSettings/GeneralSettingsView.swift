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
        Picker(String(localized: "settings.general.appearance.title", defaultValue: "Appearance", comment: "Section title for appearance settings."), selection: $settings.appAppearance) {
            Text(String(localized: "settings.general.appearance.option.system", defaultValue: "System", comment: "Appearance option label for using system setting."))
                .tag(SettingsData.Appearances.system)
            Divider()
            Text(String(localized: "settings.general.appearance.option.light", defaultValue: "Light", comment: "Appearance option label for light mode."))
                .tag(SettingsData.Appearances.light)
            Text(String(localized: "settings.general.appearance.option.dark", defaultValue: "Dark", comment: "Appearance option label for dark mode."))
                .tag(SettingsData.Appearances.dark)
        }
        .onChange(of: settings.appAppearance) { _, tag in
            tag.applyAppearance()
        }
    }

    // TODO: Implement reflecting Show Issues preference and remove disabled modifier
    var showIssues: some View {
        Picker(String(localized: "settings.general.issues.show-issues", defaultValue: "Show Issues", comment: "Setting label for issue display behavior."), selection: $settings.showIssues) {
            Text(String(localized: "settings.general.issues.show-inline", defaultValue: "Show Inline", comment: "Issue display option to show issues inline."))
                .tag(SettingsData.Issues.inline)
            Text(String(localized: "settings.general.issues.show-minimized", defaultValue: "Show Minimized", comment: "Issue display option to show minimized issues."))
                .tag(SettingsData.Issues.minimized)
        }
    }

    var showLiveIssues: some View {
        Toggle(String(localized: "settings.general.show-live-issues", defaultValue: "Show Live Issues", comment: "General settings toggle label for showing live issues"), isOn: $settings.showLiveIssues)
    }

    var showEditorJumpBar: some View {
        Toggle(String(localized: "settings.general.show-jump-bar", defaultValue: "Show Jump Bar", comment: "Toggle label for showing jump bar."), isOn: $settings.showEditorJumpBar)
    }

    var dimEditorsWithoutFocus: some View {
        Toggle(String(localized: "settings.general.dim-editors-without-focus", defaultValue: "Dim editors without focus", comment: "Toggle label for dimming unfocused editors."), isOn: $settings.dimEditorsWithoutFocus)
    }

    var fileExtensions: some View {
        Group {
            Picker(String(localized: "settings.general.file-extensions.title", defaultValue: "File Extensions", comment: "Section title for file extension display settings."), selection: $settings.fileExtensionsVisibility) {
                Text(String(localized: "settings.general.file-extensions.option.hide-all", defaultValue: "Hide all", comment: "File extension display option to hide all extensions."))
                    .tag(SettingsData.FileExtensionsVisibility.hideAll)
                Text(String(localized: "settings.general.file-extensions.option.show-all", defaultValue: "Show all", comment: "File extension display option to show all extensions."))
                    .tag(SettingsData.FileExtensionsVisibility.showAll)
                Divider()
                Text(String(localized: "settings.general.file-extensions.option.show-only", defaultValue: "Show only", comment: "File extension display option to show only selected extensions."))
                    .tag(SettingsData.FileExtensionsVisibility.showOnly)
                Text(String(localized: "settings.general.file-extensions.option.hide-only", defaultValue: "Hide only", comment: "File extension display option to hide only selected extensions."))
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
        Picker(String(localized: "settings.general.file-icon-style.title", defaultValue: "File Icon Style", comment: "Section title for file icon style settings."), selection: $settings.fileIconStyle) {
            Text(String(localized: "settings.general.file-icon-style.option.color", defaultValue: "Color", comment: "File icon style option for colored icons."))
                .tag(SettingsData.FileIconStyle.color)
            Text(String(localized: "settings.general.file-icon-style.option.monochrome", defaultValue: "Monochrome", comment: "File icon style option for monochrome icons."))
                .tag(SettingsData.FileIconStyle.monochrome)
        }
        .pickerStyle(.radioGroup)
    }

    var navigatorTabBarPosition: some View {
        Picker(String(localized: "settings.general.navigator-tab-bar-position.title", defaultValue: "Navigator Tab Bar Position", comment: "Section title for navigator tab bar position setting."), selection: $settings.navigatorTabBarPosition) {
            Text(String(localized: "settings.general.navigator-tab-bar-position.option.top", defaultValue: "Top", comment: "Navigator tab bar position option for top placement."))
                .tag(SettingsData.SidebarTabBarPosition.top)
            Text(String(localized: "settings.general.navigator-tab-bar-position.option.side", defaultValue: "Side", comment: "Navigator tab bar position option for side placement."))
                .tag(SettingsData.SidebarTabBarPosition.side)
        }
        .pickerStyle(.radioGroup)
    }

    var inspectorTabBarPosition: some View {
        Picker(String(localized: "settings.general.inspector-tab-bar-position.title", defaultValue: "Inspector Tab Bar Position", comment: "Section title for inspector tab bar position setting."), selection: $settings.inspectorTabBarPosition) {
            Text(String(localized: "settings.general.inspector-tab-bar-position.option.top", defaultValue: "Top", comment: "Inspector tab bar position option for top placement."))
                .tag(SettingsData.SidebarTabBarPosition.top)
            Text(String(localized: "settings.general.inspector-tab-bar-position.option.side", defaultValue: "Side", comment: "Inspector tab bar position option for side placement."))
                .tag(SettingsData.SidebarTabBarPosition.side)
        }
        .pickerStyle(.radioGroup)
    }

    var reopenBehavior: some View {
        Picker(String(localized: "settings.general.reopen-behavior.title", defaultValue: "Reopen Behavior", comment: "Section title for reopen behavior setting."), selection: $settings.reopenBehavior) {
            Text(String(localized: "settings.general.reopen-behavior.option.welcome-screen", defaultValue: "Welcome Screen", comment: "Reopen behavior option for showing welcome screen."))
                .tag(SettingsData.ReopenBehavior.welcome)
            Divider()
            Text(String(localized: "settings.general.reopen-behavior.option.open-panel", defaultValue: "Open Panel", comment: "Reopen behavior option for showing open panel."))
                .tag(SettingsData.ReopenBehavior.openPanel)
            Text(String(localized: "settings.general.reopen-behavior.option.new-document", defaultValue: "New Document", comment: "Reopen behavior option for creating a new document."))
                .tag(SettingsData.ReopenBehavior.newDocument)
        }
    }

    var afterWindowsCloseBehaviour: some View {
        Picker(
            String(localized: "settings.general.after-last-window-closed.title", defaultValue: "After the last window is closed", comment: "Section title for app behavior after the last window is closed."),
            selection: $settings.reopenWindowAfterClose
        ) {
            Text(String(localized: "settings.general.after-last-window-closed.option.do-nothing", defaultValue: "Do nothing", comment: "Option for taking no action after the last window is closed."))
                .tag(SettingsData.ReopenWindowBehavior.doNothing)
            Divider()
            Text(String(localized: "settings.general.after-last-window-closed.option.show-welcome-window", defaultValue: "Show Welcome Window", comment: "Option for showing welcome window after last window is closed."))
                .tag(SettingsData.ReopenWindowBehavior.showWelcomeWindow)
            Text(String(localized: "settings.general.after-last-window-closed.option.quit", defaultValue: "Quit", comment: "Option for quitting app after the last window is closed."))
                .tag(SettingsData.ReopenWindowBehavior.quit)
        }
    }

    var projectNavigatorSize: some View {
        Picker(String(localized: "settings.general.project-navigator-size.title", defaultValue: "Project Navigator Size", comment: "Section title for project navigator size setting."), selection: $settings.projectNavigatorSize) {
            Text(String(localized: "settings.general.project-navigator-size.option.small", defaultValue: "Small", comment: "Project navigator size option for small."))
                .tag(SettingsData.ProjectNavigatorSize.small)
            Text(String(localized: "settings.general.project-navigator-size.option.medium", defaultValue: "Medium", comment: "Project navigator size option for medium."))
                .tag(SettingsData.ProjectNavigatorSize.medium)
            Text(String(localized: "settings.general.project-navigator-size.option.large", defaultValue: "Large", comment: "Project navigator size option for large."))
                .tag(SettingsData.ProjectNavigatorSize.large)
        }
    }

    var findNavigatorDetail: some View {
        Picker(String(localized: "settings.general.find-navigator-detail", defaultValue: "Find Navigator Detail", comment: "Toggle label for showing find navigator detail."), selection: $settings.findNavigatorDetail) {
            ForEach(SettingsData.NavigatorDetail.allCases, id: \.self) { tag in
                Text(tag.label).tag(tag)
            }
        }
    }

    // TODO: Implement reflecting Issue Navigator Detail preference and remove disabled modifier
    var issueNavigatorDetail: some View {
        Picker(String(localized: "settings.general.issue-navigator-detail", defaultValue: "Issue Navigator Detail", comment: "Toggle label for showing issue navigator detail."), selection: $settings.issueNavigatorDetail) {
            ForEach(SettingsData.NavigatorDetail.allCases, id: \.self) { tag in
                Text(tag.label).tag(tag)
            }
        }
        .disabled(true)
    }

    // TODO: Implement reset for Don't Ask Me warnings Button and remove disabled modifier
    var dialogWarnings: some View {
        LabeledContent(String(localized: "settings.general.dialog-warnings.title", defaultValue: "Dialog Warnings", comment: "Section title for dialog warning settings.")) {
            Button(action: {
            }, label: {
                Text(String(localized: "settings.general.dialog-warnings.reset-dont-ask-me-warnings", defaultValue: "Reset \"Don't Ask Me\" Warnings", comment: "Button title for resetting suppressed dialog warnings."))
            })
            .buttonStyle(.bordered)
        }
        .disabled(true)
    }

    var shellCommand: some View {
        LabeledContent(String(localized: "settings.general.shell-command.title", defaultValue: "'codeedit' Shell Command", comment: "Section title for shell command integration settings.")) {
            Button(action: installShellCommand, label: {
                Text(String(localized: "settings.general.shell-command.install", defaultValue: "Install", comment: "Button title to install the codeedit shell command."))
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
                Button(String(localized: "settings.general.updates.check-now", defaultValue: "Check Now", comment: "Button title to immediately check for app updates.")) {
                    updater.checkForUpdates()
                }
            } label: {
                Text(String(localized: "settings.general.updates.check-for-updates", defaultValue: "Check for updates", comment: "Section title for update check settings."))
                Text(String(format: String(localized: "settings.general.updates.last-checked", defaultValue: "Last checked: %@", comment: "Label showing when updates were last checked."), "\(lastUpdatedString)"))

            }
        }
    }

    var autoUpdateToggle: some View {
        Toggle(String(localized: "settings.general.updates.automatically-check", defaultValue: "Automatically check for app updates", comment: "Toggle label for automatic app update checks."), isOn: $updater.automaticallyChecksForUpdates)
    }

    var prereleaseToggle: some View {
        Toggle(String(localized: "settings.general.updates.include-pre-release", defaultValue: "Include pre-release versions", comment: "Toggle label for including pre-release versions in update checks."), isOn: $updater.includePrereleaseVersions)
    }

    var autoSave: some View {
        Toggle(String(localized: "settings.general.auto-save.automatically-save-changes", defaultValue: "Automatically save changes to disk", comment: "Toggle label for automatically saving edits to disk."), isOn: $settings.isAutoSaveOn)
    }

    // MARK: - Preference Views

    private var lastUpdatedString: String {
        if let lastUpdatedDate = updater.lastUpdateCheckDate {
            return Self.formatter.string(from: lastUpdatedDate)
        } else {
            return String(localized: "settings.general.auto-save.interval.never", defaultValue: "Never", comment: "Auto-save interval option for never.")
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
        Toggle(String(localized: "settings.general.finder-integration.show-open-with-codeedit", defaultValue: "Show “Open With CodeEdit” option in Finder", comment: "Toggle label for showing Open With CodeEdit context menu option in Finder."), isOn: $openInCodeEdit)
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
        Toggle(String(localized: "settings.general.navigator.automatically-reveal-in-project-navigator", defaultValue: "Automatically reveal in project navigator", comment: "Toggle label for automatically revealing active file in project navigator."), isOn: $settings.revealFileOnFocusChange)
    }

    private static let formatter = configure(DateFormatter()) {
        $0.dateStyle = .medium
        $0.timeStyle = .medium
    }
}
