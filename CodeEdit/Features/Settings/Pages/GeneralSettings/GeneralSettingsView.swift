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
        Picker(String(localized: "settings.general.appearance.section", defaultValue: "Appearance", comment: "Section title for appearance settings"), selection: $settings.appAppearance) {
            Text(String(localized: "settings.general.appearance.system.option", defaultValue: "System", comment: "Option title for following system appearance"))
                .tag(SettingsData.Appearances.system)
            Divider()
            Text(String(localized: "settings.general.appearance.light.option", defaultValue: "Light", comment: "Option title for light appearance mode"))
                .tag(SettingsData.Appearances.light)
            Text(String(localized: "settings.general.appearance.dark.option", defaultValue: "Dark", comment: "Option title for dark appearance mode"))
                .tag(SettingsData.Appearances.dark)
        }
        .onChange(of: settings.appAppearance) { _, tag in
            tag.applyAppearance()
        }
    }

    // TODO: Implement reflecting Show Issues preference and remove disabled modifier
    var showIssues: some View {
        Picker(String(localized: "settings.general.issues.show-issues.option", defaultValue: "Show Issues", comment: "Option title for issue display style that shows issues"), selection: $settings.showIssues) {
            Text(String(localized: "settings.general.issues.show-inline.option", defaultValue: "Show Inline", comment: "Option title for issue display style showing inline issues"))
                .tag(SettingsData.Issues.inline)
            Text(String(localized: "settings.general.issues.show-minimized.option", defaultValue: "Show Minimized", comment: "Option title for minimized issue display style"))
                .tag(SettingsData.Issues.minimized)
        }
    }

    var showLiveIssues: some View {
        Toggle(String(localized: "settings.general.issues.show-live-issues.toggle", defaultValue: "Show Live Issues", comment: "Toggle title for showing live issues"), isOn: $settings.showLiveIssues)
    }

    var showEditorJumpBar: some View {
        Toggle(String(localized: "settings.general.show-jump-bar.toggle", defaultValue: "Show Jump Bar", comment: "Toggle title for showing the jump bar"), isOn: $settings.showEditorJumpBar)
    }

    var dimEditorsWithoutFocus: some View {
        Toggle(String(localized: "settings.general.dim-editors-without-focus.toggle", defaultValue: "Dim editors without focus", comment: "Toggle title for dimming unfocused editors"), isOn: $settings.dimEditorsWithoutFocus)
    }

    var fileExtensions: some View {
        Group {
            Picker(String(localized: "settings.general.file-extensions.section", defaultValue: "File Extensions", comment: "Section title for file extension visibility settings"), selection: $settings.fileExtensionsVisibility) {
                Text(String(localized: "settings.general.file-extensions.hide-all.option", defaultValue: "Hide all", comment: "Option title for hiding all file extensions"))
                    .tag(SettingsData.FileExtensionsVisibility.hideAll)
                Text(String(localized: "settings.general.file-extensions.show-all.option", defaultValue: "Show all", comment: "Option title for showing all file extensions"))
                    .tag(SettingsData.FileExtensionsVisibility.showAll)
                Divider()
                Text(String(localized: "settings.general.file-extensions.show-only.option", defaultValue: "Show only", comment: "Option title for showing only certain file extensions"))
                    .tag(SettingsData.FileExtensionsVisibility.showOnly)
                Text(String(localized: "settings.general.file-extensions.hide-only.option", defaultValue: "Hide only", comment: "Option title for hiding only certain file extensions"))
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
        Picker(String(localized: "settings.general.file-icon-style.label", defaultValue: "File Icon Style", comment: "Label for file icon style selection"), selection: $settings.fileIconStyle) {
            Text(String(localized: "settings.general.file-icon-style.color.option", defaultValue: "Color", comment: "Option title for colored file icons"))
                .tag(SettingsData.FileIconStyle.color)
            Text(String(localized: "settings.general.file-icon-style.monochrome.option", defaultValue: "Monochrome", comment: "Option title for monochrome file icons"))
                .tag(SettingsData.FileIconStyle.monochrome)
        }
        .pickerStyle(.radioGroup)
    }

    var navigatorTabBarPosition: some View {
        Picker(String(localized: "settings.general.navigator-tab-bar-position.label", defaultValue: "Navigator Tab Bar Position", comment: "Label for navigator tab bar position setting"), selection: $settings.navigatorTabBarPosition) {
            Text(String(localized: "settings.general.navigator-tab-bar-position.top.option", defaultValue: "Top", comment: "Option title for placing navigator tab bar at top"))
                .tag(SettingsData.SidebarTabBarPosition.top)
            Text(String(localized: "settings.general.navigator-tab-bar-position.side.option", defaultValue: "Side", comment: "Option title for placing navigator tab bar on the side"))
                .tag(SettingsData.SidebarTabBarPosition.side)
        }
        .pickerStyle(.radioGroup)
    }

    var inspectorTabBarPosition: some View {
        Picker(String(localized: "settings.general.inspector-tab-bar-position.label", defaultValue: "Inspector Tab Bar Position", comment: "Label for inspector tab bar position setting"), selection: $settings.inspectorTabBarPosition) {
            Text(String(localized: "settings.general.inspector-tab-bar-position.top.option", defaultValue: "Top", comment: "Option title for placing inspector tab bar at top"))
                .tag(SettingsData.SidebarTabBarPosition.top)
            Text(String(localized: "settings.general.inspector-tab-bar-position.side.option", defaultValue: "Side", comment: "Option title for placing inspector tab bar on the side"))
                .tag(SettingsData.SidebarTabBarPosition.side)
        }
        .pickerStyle(.radioGroup)
    }

    var reopenBehavior: some View {
        Picker(String(localized: "settings.general.reopen-behavior.label", defaultValue: "Reopen Behavior", comment: "Label for reopen behavior setting"), selection: $settings.reopenBehavior) {
            Text(String(localized: "settings.general.reopen-behavior.welcome-screen.option", defaultValue: "Welcome Screen", comment: "Option title for reopening to welcome screen"))
                .tag(SettingsData.ReopenBehavior.welcome)
            Divider()
            Text(String(localized: "settings.general.reopen-behavior.open-panel.option", defaultValue: "Open Panel", comment: "Option title for reopening with open panel"))
                .tag(SettingsData.ReopenBehavior.openPanel)
            Text(String(localized: "settings.general.reopen-behavior.new-document.option", defaultValue: "New Document", comment: "Option title for reopening with new document"))
                .tag(SettingsData.ReopenBehavior.newDocument)
        }
    }

    var afterWindowsCloseBehaviour: some View {
        Picker(
            String(localized: "settings.general.after-last-window-closed.label", defaultValue: "After the last window is closed", comment: "Label for behavior setting after closing last window"),
            selection: $settings.reopenWindowAfterClose
        ) {
            Text(String(localized: "settings.general.after-last-window-closed.do-nothing.option", defaultValue: "Do nothing", comment: "Option title for taking no action after closing last window"))
                .tag(SettingsData.ReopenWindowBehavior.doNothing)
            Divider()
            Text(String(localized: "settings.general.after-last-window-closed.show-welcome-window.option", defaultValue: "Show Welcome Window", comment: "Option title for showing welcome window after closing last window"))
                .tag(SettingsData.ReopenWindowBehavior.showWelcomeWindow)
            Text(String(localized: "settings.general.after-last-window-closed.quit.option", defaultValue: "Quit", comment: "Option title for quitting app after closing last window"))
                .tag(SettingsData.ReopenWindowBehavior.quit)
        }
    }

    var projectNavigatorSize: some View {
        Picker(String(localized: "settings.general.project-navigator-size.label", defaultValue: "Project Navigator Size", comment: "Label for project navigator size setting"), selection: $settings.projectNavigatorSize) {
            Text(String(localized: "settings.general.project-navigator-size.small.option", defaultValue: "Small", comment: "Option title for small project navigator size"))
                .tag(SettingsData.ProjectNavigatorSize.small)
            Text(String(localized: "settings.general.project-navigator-size.medium.option", defaultValue: "Medium", comment: "Option title for medium project navigator size"))
                .tag(SettingsData.ProjectNavigatorSize.medium)
            Text(String(localized: "settings.general.project-navigator-size.large.option", defaultValue: "Large", comment: "Option title for large project navigator size"))
                .tag(SettingsData.ProjectNavigatorSize.large)
        }
    }

    var findNavigatorDetail: some View {
        Picker(String(localized: "settings.general.find-navigator-detail.label", defaultValue: "Find Navigator Detail", comment: "Label for find navigator detail setting"), selection: $settings.findNavigatorDetail) {
            ForEach(SettingsData.NavigatorDetail.allCases, id: \.self) { tag in
                Text(tag.label).tag(tag)
            }
        }
    }

    // TODO: Implement reflecting Issue Navigator Detail preference and remove disabled modifier
    var issueNavigatorDetail: some View {
        Picker(String(localized: "settings.general.issue-navigator-detail.label", defaultValue: "Issue Navigator Detail", comment: "Label for issue navigator detail setting"), selection: $settings.issueNavigatorDetail) {
            ForEach(SettingsData.NavigatorDetail.allCases, id: \.self) { tag in
                Text(tag.label).tag(tag)
            }
        }
        .disabled(true)
    }

    // TODO: Implement reset for Don't Ask Me warnings Button and remove disabled modifier
    var dialogWarnings: some View {
        LabeledContent(String(localized: "settings.general.dialog-warnings.section", defaultValue: "Dialog Warnings", comment: "Section title for dialog warning settings")) {
            Button(action: {
            }, label: {
                Text(String(localized: "settings.general.dialog-warnings.reset-dont-ask-me.button", defaultValue: "Reset \"Don't Ask Me\" Warnings", comment: "Button title to reset suppressed dialog warnings"))
            })
            .buttonStyle(.bordered)
        }
        .disabled(true)
    }

    var shellCommand: some View {
        LabeledContent(String(localized: "settings.general.shell-command.codeedit.title", defaultValue: "'codeedit' Shell Command", comment: "Section title for CodeEdit shell command setting")) {
            Button(action: installShellCommand, label: {
                Text(String(localized: "settings.general.shell-command.install.button", defaultValue: "Install", comment: "Button title to install the codeedit shell command"))
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
                Button(String(localized: "settings.general.updates.check-now.button", defaultValue: "Check Now", comment: "Button title to immediately check for app updates")) {
                    updater.checkForUpdates()
                }
            } label: {
                Text(String(localized: "settings.general.updates.check-for-updates.toggle", defaultValue: "Check for updates", comment: "Toggle label for enabling update checks"))
                Text(String(format: String(localized: "settings.general.updates.last-checked.label", defaultValue: "Last checked: %@", comment: "Label showing the last time updates were checked"), "\(lastUpdatedString)"))

            }
        }
    }

    var autoUpdateToggle: some View {
        Toggle(String(localized: "settings.general.updates.automatically-check.toggle", defaultValue: "Automatically check for app updates", comment: "Toggle label for automatic app update checks"), isOn: $updater.automaticallyChecksForUpdates)
    }

    var prereleaseToggle: some View {
        Toggle(String(localized: "settings.general.updates.include-prerelease.toggle", defaultValue: "Include pre-release versions", comment: "Toggle label for including pre-release updates"), isOn: $updater.includePrereleaseVersions)
    }

    var autoSave: some View {
        Toggle(String(localized: "settings.general.auto-save.automatically-save.toggle", defaultValue: "Automatically save changes to disk", comment: "Toggle label for automatically saving changes"), isOn: $settings.isAutoSaveOn)
    }

    // MARK: - Preference Views

    private var lastUpdatedString: String {
        if let lastUpdatedDate = updater.lastUpdateCheckDate {
            return Self.formatter.string(from: lastUpdatedDate)
        } else {
            return String(localized: "settings.general.auto-save.interval.never.option", defaultValue: "Never", comment: "Option title indicating auto-save should never run")
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
        Toggle(String(localized: "settings.general.finder-integration.show-open-with-codeedit.toggle", defaultValue: "Show “Open With CodeEdit” option in Finder", comment: "Toggle label for Finder context menu integration"), isOn: $openInCodeEdit)
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
        Toggle(String(localized: "settings.general.project-navigator.automatically-reveal.toggle", defaultValue: "Automatically reveal in project navigator", comment: "Toggle label for revealing current file in project navigator"), isOn: $settings.revealFileOnFocusChange)
    }

    private static let formatter = configure(DateFormatter()) {
        $0.dateStyle = .medium
        $0.timeStyle = .medium
    }
}
