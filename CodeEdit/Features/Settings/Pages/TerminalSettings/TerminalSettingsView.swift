//
//  TerminalSettingsView.swift
//  CodeEdit
//
//  Created by Raymond Vleeshouwer on 02/04/23.
//

import SwiftUI

struct TerminalSettingsView: View {
    @AppSettings(\.terminal)
    var settings

    var body: some View {
        SettingsForm {
            Section {
                shellSelector
                optionAsMetaToggle
            }
            Section {
                useTextEditorFontToggle
                if !settings.useTextEditorFont {
                    fontSelector
                    fontSizeSelector
                    fontWeightSelector
                }
            }
            Section {
                cursorStyle
                cursorBlink
            }
            Section {
                injectionOptions
                useLoginShell
            }
        }
    }
}

private extension TerminalSettingsView {
    @ViewBuilder private var shellSelector: some View {
        Picker(String(localized: "terminalSettings.shellLabel", comment: "Label text"), selection: $settings.shell) {
            Text(String(localized: "terminalSettings.systemDefault", comment: "Shell option"))
                .tag(SettingsData.TerminalShell.system)
            Divider()
            Text("Zsh")
                .tag(SettingsData.TerminalShell.zsh)
            Text("Bash")
                .tag(SettingsData.TerminalShell.bash)
        }
    }

    private var cursorStyle: some View {
        Picker(String(localized: "terminalSettings.cursorStyleLabel", comment: "Label text"), selection: $settings.cursorStyle) {
            Text(String(localized: "terminalSettings.cursorBlock", comment: "Cursor style option"))
                .tag(SettingsData.TerminalCursorStyle.block)
            Text(String(localized: "terminalSettings.cursorUnderline", comment: "Cursor style option"))
                .tag(SettingsData.TerminalCursorStyle.underline)
            Text(String(localized: "terminalSettings.cursorBar", comment: "Cursor style option"))
                .tag(SettingsData.TerminalCursorStyle.bar)
        }
    }

    private var cursorBlink: some View {
        Toggle(String(localized: "terminalSettings.blinkCursorToggle", comment: "Toggle label"), isOn: $settings.cursorBlink)
    }

    private var optionAsMetaToggle: some View {
        Toggle(String(localized: "terminalSettings.optionAsMetaToggle", comment: "Toggle label"), isOn: $settings.optionAsMeta)
    }

    private var useTextEditorFontToggle: some View {
        Toggle(String(localized: "terminalSettings.useTextEditorFontToggle", comment: "Toggle label"), isOn: $settings.useTextEditorFont)
    }

    @ViewBuilder private var fontSelector: some View {
        MonospacedFontPicker(title: String(localized: "terminalSettings.fontLabel", comment: "Label text"), selectedFontName: $settings.font.name)
    }

    private var fontSizeSelector: some View {
        Stepper(
            String(localized: "terminalSettings.fontSizeLabel", comment: "Label text"),
            value: $settings.font.size,
            in: 1...288,
            step: 1,
            format: .number
        )
    }

    @ViewBuilder private var fontWeightSelector: some View {
        FontWeightPicker(selection: $settings.font.weight)
    }

    @ViewBuilder private var injectionOptions: some View {
        VStack {
            Toggle(String(localized: "terminalSettings.shellIntegration", comment: "Toggle label"), isOn: $settings.useShellIntegration)
            // swiftlint:disable:next line_length
                .help(String(localized: "terminalSettings.shellIntegrationHelp", comment: "Help text"))
            if !settings.useShellIntegration {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(Color(NSColor.systemYellow))
                    Text(String(localized: "terminalSettings.shellIntegrationWarning", comment: "Warning message"))
                    Spacer()
                }
            }
        }
    }

    @ViewBuilder private var useLoginShell: some View {
        if settings.useShellIntegration {
            Toggle(String(localized: "terminalSettings.useLoginShell", comment: "Toggle label"), isOn: $settings.useLoginShell)
            // swiftlint:disable:next line_length
                .help(String(localized: "terminalSettings.useLoginShellHelp", comment: "Help text"))
        } else {
            EmptyView()
        }
    }
}
