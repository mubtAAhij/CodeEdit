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
        Picker(String(localized: "settings.general.appearance", defaultValue: "Appearance", comment: "Appearance picker"), selection: $settings.appAppearance) {
            Text(String(localized: "settings.general.appearance.system", defaultValue: "System", comment: "System appearance"))
                .tag(SettingsData.Appearances.system)
            Divider()
            Text(String(localized: "settings.general.appearance.light", defaultValue: "Light", comment: "Light appearance"))
                .tag(SettingsData.Appearances.light)
            Text(String(localized: "settings.general.appearance.dark", defaultValue: "Dark", comment: "Dark appearance"))
                .tag(SettingsData.Appearances.dark)
        }
        .onChange(of: settings.appAppearance) { _, tag in
            tag.applyAppearance()
        }
    }

    // TODO: Implement reflecting Show Issues preference and remove disabled modifier
    var showIssues: some View {
        Picker(String(localized: "settings.general.show-issues", defaultValue: "Show Issues", comment: "Show issues picker"), selection: $settings.showIssues) {
            Text(String(localized: "settings.general.show-issues.inline", defaultValue: "Show Inline", comment: "Show inline issues"))
                .tag(SettingsData.Issues.inline)
            Text(String(localized: "settings.general.show-issues.minimized", defaultValue: "Show Minimized", comment: "Show minimized issues"))
                .tag(SettingsData.Issues.minimized)
        }
    }

    var showLiveIssues: some View {
        Toggle(String(localized: "settings.general.show-live-issues", defaultValue: "Show Live Issues", comment: "Show live issues toggle"), isOn: $settings.showLiveIssues)
    }

    var showEditorJumpBar: some View {
        Toggle(String(localized: "settings.general.show-jump-bar", defaultValue: "Show Jump Bar", comment: "Show jump bar toggle"), isOn: $settings.showEditorJumpBar)
    }

    var dimEditorsWithoutFocus: some View {
        Toggle(String(localized: "settings.general.dim-editors-without-focus", defaultValue: "Dim editors without focus", comment: "Dim editors without focus toggle"), isOn: $settings.dimEditorsWithoutFocus)
    }

    var fileExtensions: some View {
        Group {
            Picker(String(localized: "settings.general.file-extensions", defaultValue: "File Extensions", comment: "File extensions picker"), selection: $settings.fileExtensionsVisibility) {
                Text(String(localized: "settings.general.file-extensions.hide-all", defaultValue: "Hide all", comment: "Hide all file extensions"))
                    .tag(SettingsData.FileExtensionsVisibility.hideAll)
                Text(String(localized: "settings.general.file-extensions.show-all", defaultValue: "Show all", comment: "Show all file extensions"))
                    .tag(SettingsData.FileExtensionsVisibility.showAll)
                Divider()
                Text(String(localized: "settings.general.file-extensions.show-only", defaultValue: "Show only", comment: "Show only specific file extensions"))
                    .tag(SettingsData.FileExtensionsVisibility.showOnly)
                Text(String(localized: "settings.general.file-extensions.hide-only", defaultValue: "Hide only", comment: "Hide only specific file extensions"))
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
        Picker(String(localized: "settings.general.file-icon-style", defaultValue: "File Icon Style", comment: "File icon style picker"), selection: $settings.fileIconStyle) {
            Text(String(localized: "settings.general.file-icon-style.color", defaultValue: "Color", comment: "Color file icon style"))
                .tag(SettingsData.FileIconStyle.color)
            Text(String(localized: "settings.general.file-icon-style.monochrome", defaultValue: "Monochrome", comment: "Monochrome file icon style"))
                .tag(SettingsData.FileIconStyle.monochrome)
        }
        .pickerStyle(.radioGroup)
    }

    var navigatorTabBarPosition: some View {
        Picker(String(localized: "settings.general.navigator-tab-bar-position", defaultValue: "Navigator Tab Bar Position", comment: "Navigator tab bar position picker"), selection: $settings.navigatorTabBarPosition) {
            Text(String(localized: "settings.general.tab-bar-position.top", defaultValue: "Top", comment: "Top tab bar position"))
                .tag(SettingsData.SidebarTabBarPosition.top)
            Text(String(localized: "settings.general.tab-bar-position.side", defaultValue: "Side", comment: "Side tab bar position"))
                .tag(SettingsData.SidebarTabBarPosition.side)
        }
        .pickerStyle(.radioGroup)
    }

    var inspectorTabBarPosition: some View {
        Picker(String(localized: "settings.general.inspector-tab-bar-position", defaultValue: "Inspector Tab Bar Position", comment: "Inspector tab bar position picker"), selection: $settings.inspectorTabBarPosition) {
            Text(String(localized: "settings.general.tab-bar-position.top", defaultValue: "Top", comment: "Top tab bar position"))
                .tag(SettingsData.SidebarTabBarPosition.top)
            Text(String(localized: "settings.general.tab-bar-position.side", defaultValue: "Side", comment: "Side tab bar position"))
                .tag(SettingsData.SidebarTabBarPosition.side)
        }
        .pickerStyle(.radioGroup)
    }

    var reopenBehavior: some View {
        Picker(String(localized: "settings.general.reopen-behavior", defaultValue: "Reopen Behavior", comment: "Reopen behavior picker"), selection: $settings.reopenBehavior) {
            Text(String(localized: "settings.general.reopen-behavior.welcome-screen", defaultValue: "Welcome Screen", comment: "Welcome screen reopen option"))
                .tag(SettingsData.ReopenBehavior.welcome)
            Divider()
            Text(String(localized: "settings.general.reopen-behavior.open-panel", defaultValue: "Open Panel", comment: "Open panel reopen option"))
                .tag(SettingsData.ReopenBehavior.openPanel)
            Text(String(localized: "settings.general.reopen-behavior.new-document", defaultValue: "New Document", comment: "New document reopen option"))
                .tag(SettingsData.ReopenBehavior.newDocument)
        }
    }

    var afterWindowsCloseBehaviour: some View {
        Picker(
            String(localized: "settings.general.after-last-window-closed", defaultValue: "After the last window is closed", comment: "After last window closed picker"),
            selection: $settings.reopenWindowAfterClose
        ) {
            Text(String(localized: "settings.general.after-last-window-closed.do-nothing", defaultValue: "Do nothing", comment: "Do nothing option"))
                .tag(SettingsData.ReopenWindowBehavior.doNothing)
            Divider()
            Text(String(localized: "settings.general.after-last-window-closed.show-welcome-window", defaultValue: "Show Welcome Window", comment: "Show welcome window option"))
                .tag(SettingsData.ReopenWindowBehavior.showWelcomeWindow)
            Text(String(localized: "settings.general.after-last-window-closed.quit", defaultValue: "Quit", comment: "Quit option"))
                .tag(SettingsData.ReopenWindowBehavior.quit)
        }
    }

    var projectNavigatorSize: some View {
        Picker(String(localized: "settings.general.project-navigator-size", defaultValue: "Project Navigator Size", comment: "Project navigator size picker"), selection: $settings.projectNavigatorSize) {
            Text(String(localized: "settings.general.size.small", defaultValue: "Small", comment: "Small size option"))
                .tag(SettingsData.ProjectNavigatorSize.small)
            Text(String(localized: "settings.general.size.medium", defaultValue: "Medium", comment: "Medium size option"))
                .tag(SettingsData.ProjectNavigatorSize.medium)
            Text(String(localized: "settings.general.size.large", defaultValue: "Large", comment: "Large size option"))
                .tag(SettingsData.ProjectNavigatorSize.large)
        }
    }

    var findNavigatorDetail: some View {
        Picker(String(localized: "settings.general.find-navigator-detail", defaultValue: "Find Navigator Detail", comment: "Find navigator detail picker"), selection: $settings.findNavigatorDetail) {
            ForEach(SettingsData.NavigatorDetail.allCases, id: \.self) { tag in
                Text(tag.label).tag(tag)
            }
        }
    }

    // TODO: Implement reflecting Issue Navigator Detail preference and remove disabled modifier
    var issueNavigatorDetail: some View {
        Picker(String(localized: "settings.general.issue-navigator-detail", defaultValue: "Issue Navigator Detail", comment: "Issue navigator detail picker"), selection: $settings.issueNavigatorDetail) {
            ForEach(SettingsData.NavigatorDetail.allCases, id: \.self) { tag in
                Text(tag.label).tag(tag)
            }
        }
        .disabled(true)
    }

    // TODO: Implement reset for Don't Ask Me warnings Button and remove disabled modifier
    var dialogWarnings: some View {
        LabeledContent(String(localized: "settings.general.dialog-warnings", defaultValue: "Dialog Warnings", comment: "Dialog warnings label")) {
            Button(action: {
            }, label: {
                Text(String(localized: "settings.general.reset-dont-ask-me-warnings", defaultValue: "Reset \"Don't Ask Me\" Warnings", comment: "Reset don't ask me warnings button"))
            })
            .buttonStyle(.bordered)
        }
        .disabled(true)
    }

    var shellCommand: some View {
        LabeledContent(String(localized: "settings.general.codeedit-shell-command", defaultValue: "'codeedit' Shell Command", comment: "Codeedit shell command label")) {
            Button(action: installShellCommand, label: {
                Text(String(localized: "settings.general.install", defaultValue: "Install", comment: "Install button"))
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
                Button(String(localized: "settings.general.check-now", defaultValue: "Check Now", comment: "Check now button")) {
                    updater.checkForUpdates()
                }
            } label: {
                Text(String(localized: "settings.general.check-for-updates", defaultValue: "Check for updates", comment: "Check for updates label"))
                Text(String(format: NSLocalizedString("settings.general.last-checked", comment: "Last checked timestamp"), lastUpdatedString))

            }
        }
    }

    var autoUpdateToggle: some View {
        Toggle(String(localized: "settings.general.automatically-check-for-updates", defaultValue: "Automatically check for app updates", comment: "Automatically check for updates toggle"), isOn: $updater.automaticallyChecksForUpdates)
    }

    var prereleaseToggle: some View {
        Toggle(String(localized: "settings.general.include-prerelease-versions", defaultValue: "Include pre-release versions", comment: "Include pre-release versions toggle"), isOn: $updater.includePrereleaseVersions)
    }

    var autoSave: some View {
        Toggle(String(localized: "settings.general.automatically-save-changes", defaultValue: "Automatically save changes to disk", comment: "Automatically save changes toggle"), isOn: $settings.isAutoSaveOn)
    }

    // MARK: - Preference Views

    private var lastUpdatedString: String {
        if let lastUpdatedDate = updater.lastUpdateCheckDate {
            return Self.formatter.string(from: lastUpdatedDate)
        } else {
            return String(localized: "settings.general.never", defaultValue: "Never", comment: "Never checked status")
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
        Toggle(String(localized: "settings.general.show-open-with-codeedit", defaultValue: "Show \"Open With CodeEdit\" option in Finder", comment: "Show open with CodeEdit toggle"), isOn: $openInCodeEdit)
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
        Toggle(String(localized: "settings.general.automatically-reveal-in-navigator", defaultValue: "Automatically reveal in project navigator", comment: "Automatically reveal in project navigator toggle"), isOn: $settings.revealFileOnFocusChange)
    }

    private static let formatter = configure(DateFormatter()) {
        $0.dateStyle = .medium
        $0.timeStyle = .medium
    }
}
