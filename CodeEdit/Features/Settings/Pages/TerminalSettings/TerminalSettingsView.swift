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
        Picker(String(localized: "settings.terminal.shell.title", defaultValue: "Shell", comment: "Title for terminal shell selection setting."), selection: $settings.shell) {
            Text(String(localized: "settings.terminal.shell.option.system-default", defaultValue: "System Default", comment: "Option label for using system default shell."))
                .tag(SettingsData.TerminalShell.system)
            Divider()
            Text(String(localized: "settings.terminal.shell.option.zsh", defaultValue: "Zsh", comment: "Option label for Zsh shell."))
                .tag(SettingsData.TerminalShell.zsh)
            Text(String(localized: "settings.terminal.shell.option.bash", defaultValue: "Bash", comment: "Option label for Bash shell."))
                .tag(SettingsData.TerminalShell.bash)
        }
    }

    private var cursorStyle: some View {
        Picker(String(localized: "settings.terminal.cursor-style.title", defaultValue: "Terminal Cursor Style", comment: "Title for terminal cursor style setting."), selection: $settings.cursorStyle) {
            Text(String(localized: "settings.terminal.cursor-style.option.block", defaultValue: "Block", comment: "Option label for block cursor style."))
                .tag(SettingsData.TerminalCursorStyle.block)
            Text(String(localized: "settings.terminal.cursor-style.option.underline", defaultValue: "Underline", comment: "Option label for underline cursor style."))
                .tag(SettingsData.TerminalCursorStyle.underline)
            Text(String(localized: "settings.terminal.cursor-style.option.bar", defaultValue: "Bar", comment: "Option label for bar cursor style."))
                .tag(SettingsData.TerminalCursorStyle.bar)
        }
    }

    private var cursorBlink: some View {
        Toggle(String(localized: "settings.terminal.blink-cursor", defaultValue: "Blink Cursor", comment: "Toggle label for blinking cursor in terminal."), isOn: $settings.cursorBlink)
    }

    private var optionAsMetaToggle: some View {
        Toggle(String(localized: "settings.terminal.option-key-as-meta", defaultValue: "Use \"Option\" key as \"Meta\"", comment: "Toggle label for treating Option key as Meta in terminal."), isOn: $settings.optionAsMeta)
    }

    private var useTextEditorFontToggle: some View {
        Toggle(String(localized: "settings.terminal.use-text-editor-font", defaultValue: "Use text editor font", comment: "Toggle label for using editor font in terminal."), isOn: $settings.useTextEditorFont)
    }

    @ViewBuilder private var fontSelector: some View {
        MonospacedFontPicker(title: String(localized: "settings.terminal.font.title", defaultValue: "Font", comment: "Title for terminal font family setting."), selectedFontName: $settings.font.name)
    }

    private var fontSizeSelector: some View {
        Stepper(
            String(localized: "settings.terminal.font-size.title", defaultValue: "Font Size", comment: "Title for terminal font size setting."),
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
            Toggle(String(localized: "settings.terminal.shell-integration.title", defaultValue: "Shell Integration", comment: "Section title for terminal shell integration settings."), isOn: $settings.useShellIntegration)
            // swiftlint:disable:next line_length
                .help(String(localized: "settings.terminal.shell-integration.description", defaultValue: "CodeEdit supports integrating with common shells such as Bash and Zsh. This enables features like terminal title detection.", comment: "Description text for shell integration feature."))
            if !settings.useShellIntegration {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(Color(NSColor.systemYellow))
                    Text(String(localized: "settings.terminal.shell-integration.warning", defaultValue: "Warning: Disabling integration disables features such as terminal title detection.", comment: "Warning text shown when shell integration is disabled."))
                    Spacer()
                }
            }
        }
    }

    @ViewBuilder private var useLoginShell: some View {
        if settings.useShellIntegration {
            Toggle(String(localized: "settings.terminal.use-login-shell", defaultValue: "Use Login Shell", comment: "Toggle label for using a login shell in terminal sessions."), isOn: $settings.useLoginShell)
            // swiftlint:disable:next line_length
                .help(String(localized: "settings.terminal.use-login-shell.description", defaultValue: "Whether or not to use a login shell when starting a terminal session. By default, a login shell is used used similar to Terminal.app.", comment: "Description text explaining login shell behavior in terminal sessions."))
        } else {
            EmptyView()
        }
    }
}
