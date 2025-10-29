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
        Picker(String(localized: "Appearance", comment: "Settings option for app appearance"), selection: $settings.appAppearance) {
            Text(String(localized: "System", comment: "System appearance option"))
                .tag(SettingsData.Appearances.system)
            Divider()
            Text(String(localized: "Light", comment: "Light appearance option"))
                .tag(SettingsData.Appearances.light)
            Text(String(localized: "Dark", comment: "Dark appearance option"))
                .tag(SettingsData.Appearances.dark)
        }
        .onChange(of: settings.appAppearance) { tag in
            tag.applyAppearance()
        }
    }

    // TODO: Implement reflecting Show Issues preference and remove disabled modifier
    var showIssues: some View {
        Picker(String(localized: "Show Issues", comment: "Settings option for issue display"), selection: $settings.showIssues) {
            Text(String(localized: "Show Inline", comment: "Display issues inline"))
                .tag(SettingsData.Issues.inline)
            Text(String(localized: "Show Minimized", comment: "Display issues minimized"))
                .tag(SettingsData.Issues.minimized)
        }
    }

    var showLiveIssues: some View {
        Toggle(String(localized: "Show Live Issues", comment: "Toggle for showing live code issues"), isOn: $settings.showLiveIssues)
    }

    var showEditorJumpBar: some View {
        Toggle(String(localized: "Show Jump Bar", comment: "Toggle for showing editor jump bar"), isOn: $settings.showEditorJumpBar)
    }

    var dimEditorsWithoutFocus: some View {
        Toggle(String(localized: "Dim editors without focus", comment: "Toggle for dimming unfocused editors"), isOn: $settings.dimEditorsWithoutFocus)
    }

    var fileExtensions: some View {
        Group {
            Picker(String(localized: "File Extensions", comment: "Settings option for file extension visibility"), selection: $settings.fileExtensionsVisibility) {
                Text(String(localized: "Hide all", comment: "Hide all file extensions"))
                    .tag(SettingsData.FileExtensionsVisibility.hideAll)
                Text(String(localized: "Show all", comment: "Show all file extensions"))
                    .tag(SettingsData.FileExtensionsVisibility.showAll)
                Divider()
                Text(String(localized: "Show only", comment: "Show only specific file extensions"))
                    .tag(SettingsData.FileExtensionsVisibility.showOnly)
                Text(String(localized: "Hide only", comment: "Hide only specific file extensions"))
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
        Picker(String(localized: "File Icon Style", comment: "Settings option for file icon appearance"), selection: $settings.fileIconStyle) {
            Text(String(localized: "Color", comment: "Colored file icons"))
                .tag(SettingsData.FileIconStyle.color)
            Text(String(localized: "Monochrome", comment: "Monochrome file icons"))
                .tag(SettingsData.FileIconStyle.monochrome)
        }
        .pickerStyle(.radioGroup)
    }

    var navigatorTabBarPosition: some View {
        Picker(String(localized: "Navigator Tab Bar Position", comment: "Settings option for navigator tab bar placement"), selection: $settings.navigatorTabBarPosition) {
            Text(String(localized: "Top", comment: "Tab bar at top position"))
                .tag(SettingsData.SidebarTabBarPosition.top)
            Text(String(localized: "Side", comment: "Tab bar at side position"))
                .tag(SettingsData.SidebarTabBarPosition.side)
        }
        .pickerStyle(.radioGroup)
    }

    var inspectorTabBarPosition: some View {
        Picker(String(localized: "Inspector Tab Bar Position", comment: "Settings option for inspector tab bar placement"), selection: $settings.inspectorTabBarPosition) {
            Text(String(localized: "Top", comment: "Tab bar at top position"))
                .tag(SettingsData.SidebarTabBarPosition.top)
            Text(String(localized: "Side", comment: "Tab bar at side position"))
                .tag(SettingsData.SidebarTabBarPosition.side)
        }
        .pickerStyle(.radioGroup)
    }

    var reopenBehavior: some View {
        Picker(String(localized: "Reopen Behavior", comment: "Settings option for app reopen behavior"), selection: $settings.reopenBehavior) {
            Text(String(localized: "Welcome Screen", comment: "Reopen to welcome screen"))
                .tag(SettingsData.ReopenBehavior.welcome)
            Divider()
            Text(String(localized: "Open Panel", comment: "Reopen with open panel"))
                .tag(SettingsData.ReopenBehavior.openPanel)
            Text(String(localized: "New Document", comment: "Reopen with new document"))
                .tag(SettingsData.ReopenBehavior.newDocument)
        }
    }

    var afterWindowsCloseBehaviour: some View {
        Picker(
            String(localized: "After the last window is closed", comment: "Settings option for behavior after last window closes"),
            selection: $settings.reopenWindowAfterClose
        ) {
            Text(String(localized: "Do nothing", comment: "Do nothing when last window closes"))
                .tag(SettingsData.ReopenWindowBehavior.doNothing)
            Divider()
            Text(String(localized: "Show Welcome Window", comment: "Show welcome window when last window closes"))
                .tag(SettingsData.ReopenWindowBehavior.showWelcomeWindow)
            Text(String(localized: "Quit", comment: "Quit app when last window closes"))
                .tag(SettingsData.ReopenWindowBehavior.quit)
        }
    }

    var projectNavigatorSize: some View {
        Picker(String(localized: "Project Navigator Size", comment: "Settings option for project navigator size"), selection: $settings.projectNavigatorSize) {
            Text(String(localized: "Small", comment: "Small size option"))
                .tag(SettingsData.ProjectNavigatorSize.small)
            Text(String(localized: "Medium", comment: "Medium size option"))
                .tag(SettingsData.ProjectNavigatorSize.medium)
            Text(String(localized: "Large", comment: "Large size option"))
                .tag(SettingsData.ProjectNavigatorSize.large)
        }
    }

    var findNavigatorDetail: some View {
        Picker(String(localized: "Find Navigator Detail", comment: "Settings option for find navigator detail level"), selection: $settings.findNavigatorDetail) {
            ForEach(SettingsData.NavigatorDetail.allCases, id: \.self) { tag in
                Text(tag.label).tag(tag)
            }
        }
    }

    // TODO: Implement reflecting Issue Navigator Detail preference and remove disabled modifier
    var issueNavigatorDetail: some View {
        Picker(String(localized: "Issue Navigator Detail", comment: "Settings option for issue navigator detail level"), selection: $settings.issueNavigatorDetail) {
            ForEach(SettingsData.NavigatorDetail.allCases, id: \.self) { tag in
                Text(tag.label).tag(tag)
            }
        }
        .disabled(true)
    }

    // TODO: Implement reset for Don't Ask Me warnings Button and remove disabled modifier
    var dialogWarnings: some View {
        LabeledContent(String(localized: "Dialog Warnings", comment: "Settings section for dialog warnings")) {
            Button(action: {
            }, label: {
                Text(String(localized: "Reset \"Don't Ask Me\" Warnings", comment: "Button to reset warning dialogs"))
            })
            .buttonStyle(.bordered)
        }
        .disabled(true)
    }

    var shellCommand: some View {
        LabeledContent(String(localized: "'codeedit' Shell Command", comment: "Settings label for shell command installation")) {
            Button(action: installShellCommand, label: {
                Text(String(localized: "Install", comment: "Button to install shell command"))
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
                Button(String(localized: "Check Now", comment: "Button to check for updates immediately")) {
                    updater.checkForUpdates()
                }
            } label: {
                Text(String(localized: "Check for updates", comment: "Label for update checking section"))
                Text(String(localized: "Last checked: \(lastUpdatedString)", comment: "Displays when updates were last checked"))

            }
        }
    }

    var autoUpdateToggle: some View {
        Toggle(String(localized: "Automatically check for app updates", comment: "Toggle for automatic update checking"), isOn: $updater.automaticallyChecksForUpdates)
    }

    var prereleaseToggle: some View {
        Toggle(String(localized: "Include pre-release versions", comment: "Toggle to include pre-release versions in updates"), isOn: $updater.includePrereleaseVersions)
    }

    var autoSave: some View {
        Toggle(String(localized: "Automatically save changes to disk", comment: "Toggle for automatic file saving"), isOn: $settings.isAutoSaveOn)
    }

    // MARK: - Preference Views

    private var lastUpdatedString: String {
        if let lastUpdatedDate = updater.lastUpdateCheckDate {
            return Self.formatter.string(from: lastUpdatedDate)
        } else {
            return String(localized: "Never", comment: "Indicates updates have never been checked")
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
        Toggle(String(localized: "Automatically reveal in project navigator", comment: "Toggle to automatically reveal files in navigator"), isOn: $settings.revealFileOnFocusChange)
    }

    private static let formatter = configure(DateFormatter()) {
        $0.dateStyle = .medium
        $0.timeStyle = .medium
    }
}
