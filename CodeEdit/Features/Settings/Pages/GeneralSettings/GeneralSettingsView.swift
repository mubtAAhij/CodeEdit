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
            localized: "settings.general.appearance",
            defaultValue: "Appearance",
            comment: "General settings label for appearance mode"
        ), selection: $settings.appAppearance) {
            Text(String(
                localized: "settings.general.appearance.system",
                defaultValue: "System",
                comment: "Appearance option to follow system setting"
            ))
                .tag(SettingsData.Appearances.system)
            Divider()
            Text(String(
                localized: "settings.general.appearance.light",
                defaultValue: "Light",
                comment: "Appearance option for light theme"
            ))
                .tag(SettingsData.Appearances.light)
            Text(String(
                localized: "settings.general.appearance.dark",
                defaultValue: "Dark",
                comment: "Appearance option for dark theme"
            ))
                .tag(SettingsData.Appearances.dark)
        }
        .onChange(of: settings.appAppearance) { _, tag in
            tag.applyAppearance()
        }
    }

    // TODO: Implement reflecting Show Issues preference and remove disabled modifier
    var showIssues: some View {
        Picker(String(
            localized: "settings.general.issues.show-issues",
            defaultValue: "Show Issues",
            comment: "General settings label for issue display mode"
        ), selection: $settings.showIssues) {
            Text(String(
                localized: "settings.general.issues.show-inline",
                defaultValue: "Show Inline",
                comment: "Option to show issues inline in editor"
            ))
                .tag(SettingsData.Issues.inline)
            Text(String(
                localized: "settings.general.issues.show-minimized",
                defaultValue: "Show Minimized",
                comment: "Option to show minimized issues"
            ))
                .tag(SettingsData.Issues.minimized)
        }
    }

    var showLiveIssues: some View {
        Toggle(String(
            localized: "settings.general.issues.show-live-issues",
            defaultValue: "Show Live Issues",
            comment: "Toggle for displaying live issues"
        ), isOn: $settings.showLiveIssues)
    }

    var showEditorJumpBar: some View {
        Toggle(String(
            localized: "settings.general.show-jump-bar",
            defaultValue: "Show Jump Bar",
            comment: "Toggle for showing jump bar"
        ), isOn: $settings.showEditorJumpBar)
    }

    var dimEditorsWithoutFocus: some View {
        Toggle(String(
            localized: "settings.general.dim-unfocused-editors",
            defaultValue: "Dim editors without focus",
            comment: "Toggle for dimming unfocused editors"
        ), isOn: $settings.dimEditorsWithoutFocus)
    }

    var fileExtensions: some View {
        Group {
            Picker(String(
                localized: "settings.general.file-extensions",
                defaultValue: "File Extensions",
                comment: "General settings label for file extension visibility"
            ), selection: $settings.fileExtensionsVisibility) {
                Text(String(
                    localized: "settings.general.file-extensions.hide-all",
                    defaultValue: "Hide all",
                    comment: "Option to hide all file extensions"
                ))
                    .tag(SettingsData.FileExtensionsVisibility.hideAll)
                Text(String(
                    localized: "settings.general.file-extensions.show-all",
                    defaultValue: "Show all",
                    comment: "Option to show all file extensions"
                ))
                    .tag(SettingsData.FileExtensionsVisibility.showAll)
                Divider()
                Text(String(
                    localized: "settings.general.file-extensions.show-only",
                    defaultValue: "Show only",
                    comment: "Option to show only selected file extensions"
                ))
                    .tag(SettingsData.FileExtensionsVisibility.showOnly)
                Text(String(
                    localized: "settings.general.file-extensions.hide-only",
                    defaultValue: "Hide only",
                    comment: "Option to hide only selected file extensions"
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
            localized: "settings.general.file-icon-style",
            defaultValue: "File Icon Style",
            comment: "General settings label for file icon style"
        ), selection: $settings.fileIconStyle) {
            Text(String(
                localized: "settings.general.file-icon-style.color",
                defaultValue: "Color",
                comment: "Option for colored file icons"
            ))
                .tag(SettingsData.FileIconStyle.color)
            Text(String(
                localized: "settings.general.file-icon-style.monochrome",
                defaultValue: "Monochrome",
                comment: "Option for monochrome file icons"
            ))
                .tag(SettingsData.FileIconStyle.monochrome)
        }
        .pickerStyle(.radioGroup)
    }

    var navigatorTabBarPosition: some View {
        Picker(String(
            localized: "settings.general.navigator-tab-bar-position",
            defaultValue: "Navigator Tab Bar Position",
            comment: "General settings label for navigator tab bar position"
        ), selection: $settings.navigatorTabBarPosition) {
            Text(String(
                localized: "settings.general.navigator-tab-bar-position.top",
                defaultValue: "Top",
                comment: "Option for placing navigator tab bar at top"
            ))
                .tag(SettingsData.SidebarTabBarPosition.top)
            Text(String(
                localized: "settings.general.navigator-tab-bar-position.side",
                defaultValue: "Side",
                comment: "Option for placing navigator tab bar on the side"
            ))
                .tag(SettingsData.SidebarTabBarPosition.side)
        }
        .pickerStyle(.radioGroup)
    }

    var inspectorTabBarPosition: some View {
        Picker(String(
            localized: "settings.general.inspector-tab-bar-position",
            defaultValue: "Inspector Tab Bar Position",
            comment: "General settings label for inspector tab bar position"
        ), selection: $settings.inspectorTabBarPosition) {
            Text(String(
                localized: "settings.general.inspector-tab-bar-position.top",
                defaultValue: "Top",
                comment: "Option for placing inspector tab bar at top"
            ))
                .tag(SettingsData.SidebarTabBarPosition.top)
            Text(String(
                localized: "settings.general.inspector-tab-bar-position.side",
                defaultValue: "Side",
                comment: "Option for placing inspector tab bar on the side"
            ))
                .tag(SettingsData.SidebarTabBarPosition.side)
        }
        .pickerStyle(.radioGroup)
    }

    var reopenBehavior: some View {
        Picker(String(
            localized: "settings.general.reopen-behavior",
            defaultValue: "Reopen Behavior",
            comment: "General settings label for reopen behavior"
        ), selection: $settings.reopenBehavior) {
            Text(String(
                localized: "settings.general.reopen-behavior.welcome-screen",
                defaultValue: "Welcome Screen",
                comment: "Reopen behavior option to show welcome screen"
            ))
                .tag(SettingsData.ReopenBehavior.welcome)
            Divider()
            Text(String(
                localized: "settings.general.reopen-behavior.open-panel",
                defaultValue: "Open Panel",
                comment: "Reopen behavior option to show open panel"
            ))
                .tag(SettingsData.ReopenBehavior.openPanel)
            Text(String(
                localized: "settings.general.reopen-behavior.new-document",
                defaultValue: "New Document",
                comment: "Reopen behavior option to create a new document"
            ))
                .tag(SettingsData.ReopenBehavior.newDocument)
        }
    }

    var afterWindowsCloseBehaviour: some View {
        Picker(
            String(
                localized: "settings.general.after-last-window-closed",
                defaultValue: "After the last window is closed",
                comment: "General settings label for behavior when last window closes"
            ),
            selection: $settings.reopenWindowAfterClose
        ) {
            Text(String(
                localized: "settings.general.after-last-window-closed.do-nothing",
                defaultValue: "Do nothing",
                comment: "Option to do nothing when last window closes"
            ))
                .tag(SettingsData.ReopenWindowBehavior.doNothing)
            Divider()
            Text(String(
                localized: "settings.general.after-last-window-closed.show-welcome-window",
                defaultValue: "Show Welcome Window",
                comment: "Option to show welcome window when last window closes"
            ))
                .tag(SettingsData.ReopenWindowBehavior.showWelcomeWindow)
            Text(String(
                localized: "settings.general.after-last-window-closed.quit",
                defaultValue: "Quit",
                comment: "Option to quit app when last window closes"
            ))
                .tag(SettingsData.ReopenWindowBehavior.quit)
        }
    }

    var projectNavigatorSize: some View {
        Picker(String(
            localized: "settings.general.project-navigator-size",
            defaultValue: "Project Navigator Size",
            comment: "General settings label for project navigator icon size"
        ), selection: $settings.projectNavigatorSize) {
            Text(String(
                localized: "settings.general.project-navigator-size.small",
                defaultValue: "Small",
                comment: "Project navigator size option small"
            ))
                .tag(SettingsData.ProjectNavigatorSize.small)
            Text(String(
                localized: "settings.general.project-navigator-size.medium",
                defaultValue: "Medium",
                comment: "Project navigator size option medium"
            ))
                .tag(SettingsData.ProjectNavigatorSize.medium)
            Text(String(
                localized: "settings.general.project-navigator-size.large",
                defaultValue: "Large",
                comment: "Project navigator size option large"
            ))
                .tag(SettingsData.ProjectNavigatorSize.large)
        }
    }

    var findNavigatorDetail: some View {
        Picker(String(
            localized: "settings.general.find-navigator-detail",
            defaultValue: "Find Navigator Detail",
            comment: "General settings label for find navigator detail level"
        ), selection: $settings.findNavigatorDetail) {
            ForEach(SettingsData.NavigatorDetail.allCases, id: \.self) { tag in
                Text(tag.label).tag(tag)
            }
        }
    }

    // TODO: Implement reflecting Issue Navigator Detail preference and remove disabled modifier
    var issueNavigatorDetail: some View {
        Picker(String(
            localized: "settings.general.issue-navigator-detail",
            defaultValue: "Issue Navigator Detail",
            comment: "General settings label for issue navigator detail level"
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
            localized: "settings.general.dialog-warnings",
            defaultValue: "Dialog Warnings",
            comment: "General settings section title for dialog warning preferences"
        )) {
            Button(action: {
            }, label: {
                Text(String(
                    localized: "settings.general.dialog-warnings.reset-dont-ask-me-warnings",
                    defaultValue: "Reset \"Don't Ask Me\" Warnings",
                    comment: "Button title to reset suppressed warning dialogs"
                ))
            })
            .buttonStyle(.bordered)
        }
        .disabled(true)
    }

    var shellCommand: some View {
        LabeledContent(String(
            localized: "settings.general.shell-command.codeedit-title",
            defaultValue: "'codeedit' Shell Command",
            comment: "General settings section title for installing the codeedit shell command"
        )) {
            Button(action: installShellCommand, label: {
                Text(String(
                    localized: "settings.general.shell-command.install",
                    defaultValue: "Install",
                    comment: "Button title to install shell command"
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
                    localized: "settings.general.updates.check-now",
                    defaultValue: "Check Now",
                    comment: "Button title to manually check for updates"
                )) {
                    updater.checkForUpdates()
                }
            } label: {
                Text(String(
                    localized: "settings.general.updates.check-for-updates",
                    defaultValue: "Check for updates",
                    comment: "Settings label for checking updates"
                ))
                Text(String(format: String(
                    localized: "settings.general.updates.last-checked",
                    defaultValue: "Last checked: %@",
                    comment: "Settings text showing last update check timestamp"
                ), "\(lastUpdatedString)"))

            }
        }
    }

    var autoUpdateToggle: some View {
        Toggle(String(
            localized: "settings.general.updates.automatically-check",
            defaultValue: "Automatically check for app updates",
            comment: "Toggle label for automatic app update checks"
        ), isOn: $updater.automaticallyChecksForUpdates)
    }

    var prereleaseToggle: some View {
        Toggle(String(
            localized: "settings.general.updates.include-prerelease",
            defaultValue: "Include pre-release versions",
            comment: "Toggle label for including pre-release update versions"
        ), isOn: $updater.includePrereleaseVersions)
    }

    var autoSave: some View {
        Toggle(String(
            localized: "settings.general.autosave.automatically-save-changes-to-disk",
            defaultValue: "Automatically save changes to disk",
            comment: "Toggle label for automatically saving changes"
        ), isOn: $settings.isAutoSaveOn)
    }

    // MARK: - Preference Views

    private var lastUpdatedString: String {
        if let lastUpdatedDate = updater.lastUpdateCheckDate {
            return Self.formatter.string(from: lastUpdatedDate)
        } else {
            return String(
                localized: "settings.general.autosave.interval.never",
                defaultValue: "Never",
                comment: "Autosave interval option indicating never autosave"
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
            localized: "settings.general.finder.show-open-with-codeedit",
            defaultValue: "Show “Open With CodeEdit” option in Finder",
            comment: "Toggle label for showing Open With CodeEdit finder extension option"
        ), isOn: $openInCodeEdit)
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
        Toggle(String(
            localized: "settings.general.project-navigator.automatically-reveal",
            defaultValue: "Automatically reveal in project navigator",
            comment: "Toggle label for automatically revealing current file in project navigator"
        ), isOn: $settings.revealFileOnFocusChange)
    }

    private static let formatter = configure(DateFormatter()) {
        $0.dateStyle = .medium
        $0.timeStyle = .medium
    }
}
