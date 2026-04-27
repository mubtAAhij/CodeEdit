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
        Picker(String(localized: "terminal-settings.picker.shell", defaultValue: "Shell", comment: "Picker label for shell selection"), selection: $settings.shell) {
            Text(String(localized: "terminal-settings.shell.system-default", defaultValue: "System Default", comment: "Shell option for system default"))
                .tag(SettingsData.TerminalShell.system)
            Divider()
            Text(String(localized: "terminal-settings.shell.zsh", defaultValue: "Zsh", comment: "Shell option for Zsh"))
                .tag(SettingsData.TerminalShell.zsh)
            Text(String(localized: "terminal-settings.shell.bash", defaultValue: "Bash", comment: "Shell option for Bash"))
                .tag(SettingsData.TerminalShell.bash)
        }
    }

    private var cursorStyle: some View {
        Picker(String(localized: "terminal-settings.picker.cursor-style", defaultValue: "Terminal Cursor Style", comment: "Picker label for terminal cursor style"), selection: $settings.cursorStyle) {
            Text(String(localized: "terminal-settings.cursor.block", defaultValue: "Block", comment: "Cursor style option for block"))
                .tag(SettingsData.TerminalCursorStyle.block)
            Text(String(localized: "terminal-settings.cursor.underline", defaultValue: "Underline", comment: "Cursor style option for underline"))
                .tag(SettingsData.TerminalCursorStyle.underline)
            Text(String(localized: "terminal-settings.cursor.bar", defaultValue: "Bar", comment: "Cursor style option for bar"))
                .tag(SettingsData.TerminalCursorStyle.bar)
        }
    }

    private var cursorBlink: some View {
        Toggle(String(localized: "terminal-settings.toggle.blink-cursor", defaultValue: "Blink Cursor", comment: "Toggle for blinking cursor"), isOn: $settings.cursorBlink)
    }

    private var optionAsMetaToggle: some View {
        Toggle(String(localized: "terminal-settings.toggle.option-as-meta", defaultValue: "Use \"Option\" key as \"Meta\"", comment: "Toggle for using Option key as Meta"), isOn: $settings.optionAsMeta)
    }

    private var useTextEditorFontToggle: some View {
        Toggle(String(localized: "terminal-settings.toggle.use-editor-font", defaultValue: "Use text editor font", comment: "Toggle for using text editor font"), isOn: $settings.useTextEditorFont)
    }

    @ViewBuilder private var fontSelector: some View {
        MonospacedFontPicker(title: "Font", selectedFontName: $settings.font.name)
    }

    private var fontSizeSelector: some View {
        Stepper(
            String(localized: "terminal-settings.stepper.font-size", defaultValue: "Font Size", comment: "Stepper label for font size"),
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
            Toggle(String(localized: "terminal-settings.toggle.shell-integration", defaultValue: "Shell Integration", comment: "Toggle for shell integration"), isOn: $settings.useShellIntegration)
            // swiftlint:disable:next line_length
                .help(String(localized: "terminal-settings.help.shell-integration", defaultValue: "CodeEdit supports integrating with common shells such as Bash and Zsh. This enables features like terminal title detection.", comment: "Help text for shell integration toggle"))
            if !settings.useShellIntegration {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(Color(NSColor.systemYellow))
                    Text(String(localized: "terminal-settings.warning.integration-disabled", defaultValue: "Warning: Disabling integration disables features such as terminal title detection.", comment: "Warning message when shell integration is disabled"))
                    Spacer()
                }
            }
        }
    }

    @ViewBuilder private var useLoginShell: some View {
        if settings.useShellIntegration {
            Toggle(String(localized: "terminal-settings.toggle.login-shell", defaultValue: "Use Login Shell", comment: "Toggle for using login shell"), isOn: $settings.useLoginShell)
            // swiftlint:disable:next line_length
                .help(String(localized: "terminal-settings.help.login-shell", defaultValue: "Whether or not to use a login shell when starting a terminal session. By default, a login shell is used used similar to Terminal.app.", comment: "Help text for login shell toggle"))
        } else {
            EmptyView()
        }
    }
}
