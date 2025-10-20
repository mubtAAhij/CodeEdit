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
        Picker(String(localized: "generalSettings.appearance", comment: "Label text"), selection: $settings.appAppearance) {
            Text(String(localized: "generalSettings.system", comment: "Appearance option"))
                .tag(SettingsData.Appearances.system)
            Divider()
            Text(String(localized: "generalSettings.light", comment: "Appearance option"))
                .tag(SettingsData.Appearances.light)
            Text(String(localized: "generalSettings.dark", comment: "Appearance option"))
                .tag(SettingsData.Appearances.dark)
        }
        .onChange(of: settings.appAppearance) { tag in
            tag.applyAppearance()
        }
    }

    // TODO: Implement reflecting Show Issues preference and remove disabled modifier
    var showIssues: some View {
        Picker(String(localized: "generalSettings.showIssues", comment: "Label text"), selection: $settings.showIssues) {
            Text(String(localized: "generalSettings.showInline", comment: "Issues display option"))
                .tag(SettingsData.Issues.inline)
            Text(String(localized: "generalSettings.showMinimized", comment: "Issues display option"))
                .tag(SettingsData.Issues.minimized)
        }
    }

    var showLiveIssues: some View {
        Toggle(String(localized: "generalSettings.showLiveIssues", comment: "Toggle label"), isOn: $settings.showLiveIssues)
    }

    var showEditorJumpBar: some View {
        Toggle(String(localized: "generalSettings.showJumpBar", comment: "Toggle label"), isOn: $settings.showEditorJumpBar)
    }

    var dimEditorsWithoutFocus: some View {
        Toggle(String(localized: "generalSettings.dimEditorsWithoutFocus", comment: "Toggle label"), isOn: $settings.dimEditorsWithoutFocus)
    }

    var fileExtensions: some View {
        Group {
            Picker(String(localized: "generalSettings.fileExtensions", comment: "Label text"), selection: $settings.fileExtensionsVisibility) {
                Text(String(localized: "generalSettings.hideAll", comment: "File extensions option"))
                    .tag(SettingsData.FileExtensionsVisibility.hideAll)
                Text(String(localized: "generalSettings.showAll", comment: "File extensions option"))
                    .tag(SettingsData.FileExtensionsVisibility.showAll)
                Divider()
                Text(String(localized: "generalSettings.showOnly", comment: "File extensions option"))
                    .tag(SettingsData.FileExtensionsVisibility.showOnly)
                Text(String(localized: "generalSettings.hideOnly", comment: "File extensions option"))
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
        Picker(String(localized: "generalSettings.fileIconStyle", comment: "Label text"), selection: $settings.fileIconStyle) {
            Text(String(localized: "generalSettings.color", comment: "Icon style option"))
                .tag(SettingsData.FileIconStyle.color)
            Text(String(localized: "generalSettings.monochrome", comment: "Icon style option"))
                .tag(SettingsData.FileIconStyle.monochrome)
        }
        .pickerStyle(.radioGroup)
    }

    var navigatorTabBarPosition: some View {
        Picker(String(localized: "generalSettings.navigatorTabBarPosition", comment: "Label text"), selection: $settings.navigatorTabBarPosition) {
            Text(String(localized: "generalSettings.top", comment: "Tab bar position option"))
                .tag(SettingsData.SidebarTabBarPosition.top)
            Text(String(localized: "generalSettings.side", comment: "Tab bar position option"))
                .tag(SettingsData.SidebarTabBarPosition.side)
        }
        .pickerStyle(.radioGroup)
    }

    var inspectorTabBarPosition: some View {
        Picker(String(localized: "generalSettings.inspectorTabBarPosition", comment: "Label text"), selection: $settings.inspectorTabBarPosition) {
            Text(String(localized: "generalSettings.top", comment: "Tab bar position option"))
                .tag(SettingsData.SidebarTabBarPosition.top)
            Text(String(localized: "generalSettings.side", comment: "Tab bar position option"))
                .tag(SettingsData.SidebarTabBarPosition.side)
        }
        .pickerStyle(.radioGroup)
    }

    var reopenBehavior: some View {
        Picker(String(localized: "generalSettings.reopenBehavior", comment: "Label text"), selection: $settings.reopenBehavior) {
            Text(String(localized: "generalSettings.welcomeScreen", comment: "Reopen behavior option"))
                .tag(SettingsData.ReopenBehavior.welcome)
            Divider()
            Text(String(localized: "generalSettings.openPanel", comment: "Reopen behavior option"))
                .tag(SettingsData.ReopenBehavior.openPanel)
            Text(String(localized: "generalSettings.newDocument", comment: "Reopen behavior option"))
                .tag(SettingsData.ReopenBehavior.newDocument)
        }
    }

    var afterWindowsCloseBehaviour: some View {
        Picker(
            String(localized: "generalSettings.afterLastWindowClosed", comment: "Label text"),
            selection: $settings.reopenWindowAfterClose
        ) {
            Text(String(localized: "generalSettings.doNothing", comment: "Window close behavior option"))
                .tag(SettingsData.ReopenWindowBehavior.doNothing)
            Divider()
            Text(String(localized: "generalSettings.showWelcomeWindow", comment: "Window close behavior option"))
                .tag(SettingsData.ReopenWindowBehavior.showWelcomeWindow)
            Text(String(localized: "generalSettings.quit", comment: "Window close behavior option"))
                .tag(SettingsData.ReopenWindowBehavior.quit)
        }
    }

    var projectNavigatorSize: some View {
        Picker(String(localized: "generalSettings.projectNavigatorSize", comment: "Label text"), selection: $settings.projectNavigatorSize) {
            Text(String(localized: "generalSettings.small", comment: "Size option"))
                .tag(SettingsData.ProjectNavigatorSize.small)
            Text(String(localized: "generalSettings.medium", comment: "Size option"))
                .tag(SettingsData.ProjectNavigatorSize.medium)
            Text(String(localized: "generalSettings.large", comment: "Size option"))
                .tag(SettingsData.ProjectNavigatorSize.large)
        }
    }

    var findNavigatorDetail: some View {
        Picker(String(localized: "generalSettings.findNavigatorDetail", comment: "Label text"), selection: $settings.findNavigatorDetail) {
            ForEach(SettingsData.NavigatorDetail.allCases, id: \.self) { tag in
                Text(tag.label).tag(tag)
            }
        }
    }

    // TODO: Implement reflecting Issue Navigator Detail preference and remove disabled modifier
    var issueNavigatorDetail: some View {
        Picker(String(localized: "generalSettings.issueNavigatorDetail", comment: "Label text"), selection: $settings.issueNavigatorDetail) {
            ForEach(SettingsData.NavigatorDetail.allCases, id: \.self) { tag in
                Text(tag.label).tag(tag)
            }
        }
        .disabled(true)
    }

    // TODO: Implement reset for Don't Ask Me warnings Button and remove disabled modifier
    var dialogWarnings: some View {
        LabeledContent(String(localized: "generalSettings.dialogWarnings", comment: "Label text")) {
            Button(action: {
            }, label: {
                Text(String(localized: "generalSettings.resetDontAskWarnings", comment: "Button text"))
            })
            .buttonStyle(.bordered)
        }
        .disabled(true)
    }

    var shellCommand: some View {
        LabeledContent(String(localized: "generalSettings.shellCommand", comment: "Label text")) {
            Button(action: installShellCommand, label: {
                Text(String(localized: "generalSettings.install", comment: "Button text"))
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
                Button(String(localized: "generalSettings.checkNow", comment: "Button text")) {
                    updater.checkForUpdates()
                }
            } label: {
                Text(String(localized: "generalSettings.checkForUpdates", comment: "Label text"))
                Text(String(localized: "generalSettings.lastChecked", comment: "Status message", arguments: lastUpdatedString))

            }
        }
    }

    var autoUpdateToggle: some View {
        Toggle(String(localized: "generalSettings.autoCheckUpdates", comment: "Toggle label"), isOn: $updater.automaticallyChecksForUpdates)
    }

    var prereleaseToggle: some View {
        Toggle(String(localized: "generalSettings.includePrereleaseVersions", comment: "Toggle label"), isOn: $updater.includePrereleaseVersions)
    }

    var autoSave: some View {
        Toggle(String(localized: "generalSettings.autoSaveChanges", comment: "Toggle label"), isOn: $settings.isAutoSaveOn)
    }

    // MARK: - Preference Views

    private var lastUpdatedString: String {
        if let lastUpdatedDate = updater.lastUpdateCheckDate {
            return Self.formatter.string(from: lastUpdatedDate)
        } else {
            return String(localized: "generalSettings.never", comment: "Status text")
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
    var openInCodeEditToggle: some View {
        Toggle(String(localized: "generalSettings.showOpenWithCodeEdit", comment: "Toggle label"), isOn: $openInCodeEdit)
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
        Toggle(String(localized: "generalSettings.autoRevealInNavigator", comment: "Toggle label"), isOn: $settings.revealFileOnFocusChange)
    }

    private static let formatter = configure(DateFormatter()) {
        $0.dateStyle = .medium
        $0.timeStyle = .medium
    }
}
