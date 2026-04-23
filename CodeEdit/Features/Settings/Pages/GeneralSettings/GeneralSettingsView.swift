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
        Picker(String(localized: "general-settings.appearance", defaultValue: "Appearance", comment: "Appearance picker label"), selection: $settings.appAppearance) {
            Text(String(localized: "general-settings.system", defaultValue: "System", comment: "System appearance option", os_id: "105929"))
                .tag(SettingsData.Appearances.system)
            Divider()
            Text(String(localized: "general-settings.light", defaultValue: "Light", comment: "Light appearance option"))
                .tag(SettingsData.Appearances.light)
            Text(String(localized: "general-settings.dark", defaultValue: "Dark", comment: "Dark appearance option"))
                .tag(SettingsData.Appearances.dark)
        }
        .onChange(of: settings.appAppearance) { _, tag in
            tag.applyAppearance()
        }
    }

    // TODO: Implement reflecting Show Issues preference and remove disabled modifier
    var showIssues: some View {
        Picker(String(localized: "general-settings.show-issues", defaultValue: "Show Issues", comment: "Show issues picker label"), selection: $settings.showIssues) {
            Text(String(localized: "general-settings.show-inline", defaultValue: "Show Inline", comment: "Show inline issues option", os_id: "105933"))
                .tag(SettingsData.Issues.inline)
            Text(String(localized: "general-settings.show-minimized", defaultValue: "Show Minimized", comment: "Show minimized issues option", os_id: "105934"))
                .tag(SettingsData.Issues.minimized)
        }
    }

    var showLiveIssues: some View {
        Toggle(String(localized: "general-settings.show-live-issues", defaultValue: "Show Live Issues", comment: "Show live issues toggle"), isOn: $settings.showLiveIssues)
    }

    var showEditorJumpBar: some View {
        Toggle(String(localized: "general-settings.show-jump-bar", defaultValue: "Show Jump Bar", comment: "Show jump bar toggle"), isOn: $settings.showEditorJumpBar)
    }

    var dimEditorsWithoutFocus: some View {
        Toggle(String(localized: "general-settings.dim-editors-without-focus", defaultValue: "Dim editors without focus", comment: "Dim editors without focus toggle"), isOn: $settings.dimEditorsWithoutFocus)
    }

    var fileExtensions: some View {
        Group {
            Picker(String(localized: "general-settings.file-extensions", defaultValue: "File Extensions", comment: "File extensions picker label"), selection: $settings.fileExtensionsVisibility) {
                Text(String(localized: "general-settings.hide-all", defaultValue: "Hide all", comment: "Hide all extensions option", os_id: "105939"))
                    .tag(SettingsData.FileExtensionsVisibility.hideAll)
                Text(String(localized: "general-settings.show-all", defaultValue: "Show all", comment: "Show all extensions option", os_id: "105940"))
                    .tag(SettingsData.FileExtensionsVisibility.showAll)
                Divider()
                Text(String(localized: "general-settings.show-only", defaultValue: "Show only", comment: "Show only specific extensions option", os_id: "105941"))
                    .tag(SettingsData.FileExtensionsVisibility.showOnly)
                Text(String(localized: "general-settings.hide-only", defaultValue: "Hide only", comment: "Hide only specific extensions option", os_id: "105942"))
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
        Picker(String(localized: "general-settings.file-icon-style", defaultValue: "File Icon Style", comment: "File icon style picker label"), selection: $settings.fileIconStyle) {
            Text(String(localized: "general-settings.color", defaultValue: "Color", comment: "Color icon style option", os_id: "105944"))
                .tag(SettingsData.FileIconStyle.color)
            Text(String(localized: "general-settings.monochrome", defaultValue: "Monochrome", comment: "Monochrome icon style option", os_id: "105945"))
                .tag(SettingsData.FileIconStyle.monochrome)
        }
        .pickerStyle(.radioGroup)
    }

    var navigatorTabBarPosition: some View {
        Picker(String(localized: "general-settings.navigator-tab-bar-position", defaultValue: "Navigator Tab Bar Position", comment: "Navigator tab bar position picker label"), selection: $settings.navigatorTabBarPosition) {
            Text(String(localized: "general-settings.top", defaultValue: "Top", comment: "Top position option"))
                .tag(SettingsData.SidebarTabBarPosition.top)
            Text(String(localized: "general-settings.side", defaultValue: "Side", comment: "Side position option"))
                .tag(SettingsData.SidebarTabBarPosition.side)
        }
        .pickerStyle(.radioGroup)
    }

    var inspectorTabBarPosition: some View {
        Picker(String(localized: "general-settings.inspector-tab-bar-position", defaultValue: "Inspector Tab Bar Position", comment: "Inspector tab bar position picker label"), selection: $settings.inspectorTabBarPosition) {
            Text(String(localized: "general-settings.top-inspector", defaultValue: "Top", comment: "Top position option for inspector", os_id: "105947"))
                .tag(SettingsData.SidebarTabBarPosition.top)
            Text(String(localized: "general-settings.side-inspector", defaultValue: "Side", comment: "Side position option for inspector", os_id: "105948"))
                .tag(SettingsData.SidebarTabBarPosition.side)
        }
        .pickerStyle(.radioGroup)
    }

    var reopenBehavior: some View {
        Picker(String(localized: "general-settings.reopen-behavior", defaultValue: "Reopen Behavior", comment: "Reopen behavior picker label"), selection: $settings.reopenBehavior) {
            Text(String(localized: "general-settings.welcome-screen", defaultValue: "Welcome Screen", comment: "Welcome screen reopen option", os_id: "105951"))
                .tag(SettingsData.ReopenBehavior.welcome)
            Divider()
            Text(String(localized: "general-settings.open-panel", defaultValue: "Open Panel", comment: "Open panel reopen option", os_id: "105952"))
                .tag(SettingsData.ReopenBehavior.openPanel)
            Text(String(localized: "general-settings.new-document", defaultValue: "New Document", comment: "New document reopen option", os_id: "105953"))
                .tag(SettingsData.ReopenBehavior.newDocument)
        }
    }

    var afterWindowsCloseBehaviour: some View {
        Picker(
            String(localized: "general-settings.after-last-window-closed", defaultValue: "After the last window is closed", comment: "After last window closed picker label"),
            selection: $settings.reopenWindowAfterClose
        ) {
            Text(String(localized: "general-settings.do-nothing", defaultValue: "Do nothing", comment: "Do nothing option", os_id: "105955"))
                .tag(SettingsData.ReopenWindowBehavior.doNothing)
            Divider()
            Text(String(localized: "general-settings.show-welcome-window", defaultValue: "Show Welcome Window", comment: "Show welcome window option", os_id: "105956"))
                .tag(SettingsData.ReopenWindowBehavior.showWelcomeWindow)
            Text(String(localized: "general-settings.quit", defaultValue: "Quit", comment: "Quit option", os_id: "105957"))
                .tag(SettingsData.ReopenWindowBehavior.quit)
        }
    }

    var projectNavigatorSize: some View {
        Picker(String(localized: "general-settings.project-navigator-size", defaultValue: "Project Navigator Size", comment: "Project navigator size picker label"), selection: $settings.projectNavigatorSize) {
            Text(String(localized: "general-settings.small", defaultValue: "Small", comment: "Small size option"))
                .tag(SettingsData.ProjectNavigatorSize.small)
            Text(String(localized: "general-settings.medium", defaultValue: "Medium", comment: "Medium size option"))
                .tag(SettingsData.ProjectNavigatorSize.medium)
            Text(String(localized: "general-settings.large", defaultValue: "Large", comment: "Large size option"))
                .tag(SettingsData.ProjectNavigatorSize.large)
        }
    }

    var findNavigatorDetail: some View {
        Picker(String(localized: "general-settings.find-navigator-detail", defaultValue: "Find Navigator Detail", comment: "Find navigator detail picker label"), selection: $settings.findNavigatorDetail) {
            ForEach(SettingsData.NavigatorDetail.allCases, id: \.self) { tag in
                Text(tag.label).tag(tag)
            }
        }
    }

    // TODO: Implement reflecting Issue Navigator Detail preference and remove disabled modifier
    var issueNavigatorDetail: some View {
        Picker(String(localized: "general-settings.issue-navigator-detail", defaultValue: "Issue Navigator Detail", comment: "Issue navigator detail picker label"), selection: $settings.issueNavigatorDetail) {
            ForEach(SettingsData.NavigatorDetail.allCases, id: \.self) { tag in
                Text(tag.label).tag(tag)
            }
        }
        .disabled(true)
    }

    // TODO: Implement reset for Don't Ask Me warnings Button and remove disabled modifier
    var dialogWarnings: some View {
        LabeledContent(String(localized: "general-settings.dialog-warnings", defaultValue: "Dialog Warnings", comment: "Dialog warnings label")) {
            Button(action: {
            }, label: {
                Text(String(localized: "general-settings.reset-dont-ask-warnings", defaultValue: "Reset \"Don't Ask Me\" Warnings", comment: "Reset don't ask me warnings button", os_id: "105965"))
            })
            .buttonStyle(.bordered)
        }
        .disabled(true)
    }

    var shellCommand: some View {
        LabeledContent(String(localized: "general-settings.codeedit-shell-command", defaultValue: "'codeedit' Shell Command", comment: "Codeedit shell command label", os_id: "105966")) {
            Button(action: installShellCommand, label: {
                Text(String(localized: "general-settings.install", defaultValue: "Install", comment: "Install button", os_id: "105904"))
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
                Button(String(localized: "general-settings.check-now", defaultValue: "Check Now", comment: "Check now button", os_id: "105967")) {
                    updater.checkForUpdates()
                }
            } label: {
                Text(String(localized: "general-settings.check-for-updates", defaultValue: "Check for updates", comment: "Check for updates label"))
                Text(String(format: String(localized: "general-settings.last-checked", defaultValue: "Last checked: %@", comment: "Last checked label", os_id: "105969"), lastUpdatedString))

            }
        }
    }

    var autoUpdateToggle: some View {
        Toggle(String(localized: "general-settings.automatically-check-updates", defaultValue: "Automatically check for app updates", comment: "Automatically check for app updates toggle"), isOn: $updater.automaticallyChecksForUpdates)
    }

    var prereleaseToggle: some View {
        Toggle(String(localized: "general-settings.include-prerelease", defaultValue: "Include pre-release versions", comment: "Include pre-release versions toggle"), isOn: $updater.includePrereleaseVersions)
    }

    var autoSave: some View {
        Toggle(String(localized: "general-settings.autosave", defaultValue: "Automatically save changes to disk", comment: "Automatically save changes toggle", os_id: "105972"), isOn: $settings.isAutoSaveOn)
    }

    // MARK: - Preference Views

    private var lastUpdatedString: String {
        if let lastUpdatedDate = updater.lastUpdateCheckDate {
            return Self.formatter.string(from: lastUpdatedDate)
        } else {
            return String(localized: "general-settings.never", defaultValue: "Never", comment: "Never checked status", os_id: "105973")
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
        Toggle(String(localized: "general-settings.show-open-with-codeedit", defaultValue: "Show \"Open With CodeEdit\" option in Finder", comment: "Show open with CodeEdit option in Finder toggle", os_id: "105974"), isOn: $openInCodeEdit)
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
        Toggle(String(localized: "general-settings.auto-reveal-navigator", defaultValue: "Automatically reveal in project navigator", comment: "Automatically reveal in project navigator toggle"), isOn: $settings.revealFileOnFocusChange)
    }

    private static let formatter = configure(DateFormatter()) {
        $0.dateStyle = .medium
        $0.timeStyle = .medium
    }
}
