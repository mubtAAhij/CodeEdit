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
        Picker(String(
            localized: "general-settings.appearance",
            defaultValue: "Appearance",
            comment: "Label for appearance picker"
        ), selection: $settings.appAppearance) {
            Text(String(
                localized: "general-settings.appearance.system",
                defaultValue: "System",
                comment: "System appearance option"
            ))
                .tag(SettingsData.Appearances.system)
            Divider()
            Text(String(
                localized: "general-settings.appearance.light",
                defaultValue: "Light",
                comment: "Light appearance option"
            ))
                .tag(SettingsData.Appearances.light)
            Text(String(
                localized: "general-settings.appearance.dark",
                defaultValue: "Dark",
                comment: "Dark appearance option"
            ))
                .tag(SettingsData.Appearances.dark)
        }
        .onChange(of: settings.appAppearance) { tag in
            tag.applyAppearance()
        }
    }

    // TODO: Implement reflecting Show Issues preference and remove disabled modifier
    var showIssues: some View {
        Picker(String(
            localized: "general-settings.show-issues",
            defaultValue: "Show Issues",
            comment: "Label for show issues picker"
        ), selection: $settings.showIssues) {
            Text(String(
                localized: "general-settings.show-issues.inline",
                defaultValue: "Show Inline",
                comment: "Show issues inline option"
            ))
                .tag(SettingsData.Issues.inline)
            Text(String(
                localized: "general-settings.show-issues.minimized",
                defaultValue: "Show Minimized",
                comment: "Show issues minimized option"
            ))
                .tag(SettingsData.Issues.minimized)
        }
    }

    var showLiveIssues: some View {
        Toggle(String(
            localized: "general-settings.show-live-issues",
            defaultValue: "Show Live Issues",
            comment: "Toggle for showing live issues"
        ), isOn: $settings.showLiveIssues)
    }

    var showEditorJumpBar: some View {
        Toggle(String(
            localized: "general-settings.show-jump-bar",
            defaultValue: "Show Jump Bar",
            comment: "Toggle for showing editor jump bar"
        ), isOn: $settings.showEditorJumpBar)
    }

    var dimEditorsWithoutFocus: some View {
        Toggle(String(
            localized: "general-settings.dim-editors-without-focus",
            defaultValue: "Dim editors without focus",
            comment: "Toggle for dimming unfocused editors"
        ), isOn: $settings.dimEditorsWithoutFocus)
    }

    var fileExtensions: some View {
        Group {
            Picker(String(
                localized: "general-settings.file-extensions",
                defaultValue: "File Extensions",
                comment: "Label for file extensions picker"
            ), selection: $settings.fileExtensionsVisibility) {
                Text(String(
                    localized: "general-settings.file-extensions.hide-all",
                    defaultValue: "Hide all",
                    comment: "Hide all file extensions option"
                ))
                    .tag(SettingsData.FileExtensionsVisibility.hideAll)
                Text(String(
                    localized: "general-settings.file-extensions.show-all",
                    defaultValue: "Show all",
                    comment: "Show all file extensions option"
                ))
                    .tag(SettingsData.FileExtensionsVisibility.showAll)
                Divider()
                Text(String(
                    localized: "general-settings.file-extensions.show-only",
                    defaultValue: "Show only",
                    comment: "Show only specific file extensions option"
                ))
                    .tag(SettingsData.FileExtensionsVisibility.showOnly)
                Text(String(
                    localized: "general-settings.file-extensions.hide-only",
                    defaultValue: "Hide only",
                    comment: "Hide only specific file extensions option"
                ))
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
        Picker(String(
            localized: "general-settings.file-icon-style",
            defaultValue: "File Icon Style",
            comment: "Label for file icon style picker"
        ), selection: $settings.fileIconStyle) {
            Text(String(
                localized: "general-settings.file-icon-style.color",
                defaultValue: "Color",
                comment: "Color file icon style option"
            ))
                .tag(SettingsData.FileIconStyle.color)
            Text(String(
                localized: "general-settings.file-icon-style.monochrome",
                defaultValue: "Monochrome",
                comment: "Monochrome file icon style option"
            ))
                .tag(SettingsData.FileIconStyle.monochrome)
        }
        .pickerStyle(.radioGroup)
    }

    var navigatorTabBarPosition: some View {
        Picker(String(
            localized: "general-settings.navigator-tab-bar-position",
            defaultValue: "Navigator Tab Bar Position",
            comment: "Label for navigator tab bar position picker"
        ), selection: $settings.navigatorTabBarPosition) {
            Text(String(
                localized: "general-settings.navigator-tab-bar-position.top",
                defaultValue: "Top",
                comment: "Top position option"
            ))
                .tag(SettingsData.SidebarTabBarPosition.top)
            Text(String(
                localized: "general-settings.navigator-tab-bar-position.side",
                defaultValue: "Side",
                comment: "Side position option"
            ))
                .tag(SettingsData.SidebarTabBarPosition.side)
        }
        .pickerStyle(.radioGroup)
    }

    var inspectorTabBarPosition: some View {
        Picker(String(
            localized: "general-settings.inspector-tab-bar-position",
            defaultValue: "Inspector Tab Bar Position",
            comment: "Label for inspector tab bar position picker"
        ), selection: $settings.inspectorTabBarPosition) {
            Text(String(
                localized: "general-settings.inspector-tab-bar-position.top",
                defaultValue: "Top",
                comment: "Top position option"
            ))
                .tag(SettingsData.SidebarTabBarPosition.top)
            Text(String(
                localized: "general-settings.inspector-tab-bar-position.side",
                defaultValue: "Side",
                comment: "Side position option"
            ))
                .tag(SettingsData.SidebarTabBarPosition.side)
        }
        .pickerStyle(.radioGroup)
    }

    var reopenBehavior: some View {
        Picker(String(
            localized: "general-settings.reopen-behavior",
            defaultValue: "Reopen Behavior",
            comment: "Label for reopen behavior picker"
        ), selection: $settings.reopenBehavior) {
            Text(String(
                localized: "general-settings.reopen-behavior.welcome-screen",
                defaultValue: "Welcome Screen",
                comment: "Welcome screen reopen option"
            ))
                .tag(SettingsData.ReopenBehavior.welcome)
            Divider()
            Text(String(
                localized: "general-settings.reopen-behavior.open-panel",
                defaultValue: "Open Panel",
                comment: "Open panel reopen option"
            ))
                .tag(SettingsData.ReopenBehavior.openPanel)
            Text(String(
                localized: "general-settings.reopen-behavior.new-document",
                defaultValue: "New Document",
                comment: "New document reopen option"
            ))
                .tag(SettingsData.ReopenBehavior.newDocument)
        }
    }

    var afterWindowsCloseBehaviour: some View {
        Picker(
            String(
                localized: "general-settings.after-last-window-closed",
                defaultValue: "After the last window is closed",
                comment: "Label for window close behavior picker"
            ),
            selection: $settings.reopenWindowAfterClose
        ) {
            Text(String(
                localized: "general-settings.after-last-window-closed.do-nothing",
                defaultValue: "Do nothing",
                comment: "Do nothing after window close option"
            ))
                .tag(SettingsData.ReopenWindowBehavior.doNothing)
            Divider()
            Text(String(
                localized: "general-settings.after-last-window-closed.show-welcome-window",
                defaultValue: "Show Welcome Window",
                comment: "Show welcome window after close option"
            ))
                .tag(SettingsData.ReopenWindowBehavior.showWelcomeWindow)
            Text(String(
                localized: "general-settings.after-last-window-closed.quit",
                defaultValue: "Quit",
                comment: "Quit application after window close option"
            ))
                .tag(SettingsData.ReopenWindowBehavior.quit)
        }
    }

    var projectNavigatorSize: some View {
        Picker(String(
            localized: "general-settings.project-navigator-size",
            defaultValue: "Project Navigator Size",
            comment: "Label for project navigator size picker"
        ), selection: $settings.projectNavigatorSize) {
            Text(String(
                localized: "general-settings.project-navigator-size.small",
                defaultValue: "Small",
                comment: "Small size option"
            ))
                .tag(SettingsData.ProjectNavigatorSize.small)
            Text(String(
                localized: "general-settings.project-navigator-size.medium",
                defaultValue: "Medium",
                comment: "Medium size option"
            ))
                .tag(SettingsData.ProjectNavigatorSize.medium)
            Text(String(
                localized: "general-settings.project-navigator-size.large",
                defaultValue: "Large",
                comment: "Large size option"
            ))
                .tag(SettingsData.ProjectNavigatorSize.large)
        }
    }

    var findNavigatorDetail: some View {
        Picker(String(
            localized: "general-settings.find-navigator-detail",
            defaultValue: "Find Navigator Detail",
            comment: "Label for find navigator detail picker"
        ), selection: $settings.findNavigatorDetail) {
            ForEach(SettingsData.NavigatorDetail.allCases, id: \.self) { tag in
                Text(tag.label).tag(tag)
            }
        }
    }

    // TODO: Implement reflecting Issue Navigator Detail preference and remove disabled modifier
    var issueNavigatorDetail: some View {
        Picker(String(
            localized: "general-settings.issue-navigator-detail",
            defaultValue: "Issue Navigator Detail",
            comment: "Label for issue navigator detail picker"
        ), selection: $settings.issueNavigatorDetail) {
            ForEach(SettingsData.NavigatorDetail.allCases, id: \.self) { tag in
                Text(tag.label).tag(tag)
            }
        }
        .disabled(true)
    }

    // TODO: Implement reset for Don't Ask Me warnings Button and remove disabled modifier
    var dialogWarnings: some View {
        LabeledContent(String(
            localized: "general-settings.dialog-warnings",
            defaultValue: "Dialog Warnings",
            comment: "Label for dialog warnings section"
        )) {
            Button(action: {
            }, label: {
                Text(String(
                    localized: "general-settings.dialog-warnings.reset",
                    defaultValue: "Reset \"Don't Ask Me\" Warnings",
                    comment: "Button to reset dialog warnings"
                ))
            })
            .buttonStyle(.bordered)
        }
        .disabled(true)
    }

    var shellCommand: some View {
        LabeledContent(String(
            localized: "general-settings.shell-command",
            defaultValue: "'codeedit' Shell Command",
            comment: "Label for shell command installation"
        )) {
            Button(action: installShellCommand, label: {
                Text(String(
                    localized: "general-settings.shell-command.install",
                    defaultValue: "Install",
                    comment: "Button to install shell command"
                ))
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
                Button(String(
                    localized: "general-settings.update-checker.check-now",
                    defaultValue: "Check Now",
                    comment: "Button to check for updates now"
                )) {
                    updater.checkForUpdates()
                }
            } label: {
                Text(String(
                    localized: "general-settings.update-checker.label",
                    defaultValue: "Check for updates",
                    comment: "Label for update checker section"
                ))
                let lastChecked = lastUpdatedString
                Text(String(
                    localized: "general-settings.update-checker.last-checked",
                    defaultValue: "Last checked: \(lastChecked)",
                    comment: "Label showing last update check time"
                ))

            }
        }
    }

    var autoUpdateToggle: some View {
        Toggle(String(
            localized: "general-settings.auto-update",
            defaultValue: "Automatically check for app updates",
            comment: "Toggle for automatic update checking"
        ), isOn: $updater.automaticallyChecksForUpdates)
    }

    var prereleaseToggle: some View {
        Toggle(String(
            localized: "general-settings.prerelease",
            defaultValue: "Include pre-release versions",
            comment: "Toggle for including pre-release versions"
        ), isOn: $updater.includePrereleaseVersions)
    }

    var autoSave: some View {
        Toggle(String(
            localized: "general-settings.auto-save",
            defaultValue: "Automatically save changes to disk",
            comment: "Toggle for automatic saving"
        ), isOn: $settings.isAutoSaveOn)
    }

    // MARK: - Preference Views

    private var lastUpdatedString: String {
        if let lastUpdatedDate = updater.lastUpdateCheckDate {
            return Self.formatter.string(from: lastUpdatedDate)
        } else {
            return String(
                localized: "general-settings.update-checker.never",
                defaultValue: "Never",
                comment: "Text when updates have never been checked"
            )
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
        Toggle(String(
            localized: "general-settings.open-in-codeedit",
            defaultValue: "Show \"Open With CodeEdit\" option in Finder",
            comment: "Toggle for showing Open With CodeEdit in Finder"
        ), isOn: $openInCodeEdit)
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
        Toggle(String(
            localized: "general-settings.reveal-file-on-focus",
            defaultValue: "Automatically reveal in project navigator",
            comment: "Toggle for automatically revealing files in navigator"
        ), isOn: $settings.revealFileOnFocusChange)
    }

    private static let formatter = configure(DateFormatter()) {
        $0.dateStyle = .medium
        $0.timeStyle = .medium
    }
}
