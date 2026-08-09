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
    private var shellSelector: some View {
        Picker(String(localized: "terminal.settings.shell", defaultValue: "Shell", comment: "Label for terminal shell selection setting"), selection: $settings.shell) {
            Text(String(localized: "terminal.settings.shell.system-default", defaultValue: "System Default", comment: "Option for using the system default shell"))
                .tag(SettingsData.TerminalShell.system)
            Divider()
            Text("Zsh")
                .tag(SettingsData.TerminalShell.zsh)
            Text("Bash")
                .tag(SettingsData.TerminalShell.bash)
        }
    }

    private var cursorStyle: some View {
        Picker(String(localized: "terminal.settings.cursor-style", defaultValue: "Terminal Cursor Style", comment: "Label for terminal cursor style setting"), selection: $settings.cursorStyle) {
            Text(String(localized: "terminal.settings.cursor-style.block", defaultValue: "Block", comment: "Option for block cursor style"))
                .tag(SettingsData.TerminalCursorStyle.block)
            Text(String(localized: "terminal.settings.cursor-style.underline", defaultValue: "Underline", comment: "Option for underline cursor style"))
                .tag(SettingsData.TerminalCursorStyle.underline)
            Text(String(localized: "terminal.settings.cursor-style.bar", defaultValue: "Bar", comment: "Option for bar cursor style"))
                .tag(SettingsData.TerminalCursorStyle.bar)
        }
    }

    private var cursorBlink: some View {
        Toggle(String(localized: "terminal.settings.blink-cursor", defaultValue: "Blink Cursor", comment: "Toggle label for blinking terminal cursor"), isOn: $settings.cursorBlink)
    }

    private var optionAsMetaToggle: some View {
        Toggle("Use \"Option\" key as \"Meta\"", isOn: $settings.optionAsMeta)
    }

    private var useTextEditorFontToggle: some View {
        Toggle(String(localized: "terminal.settings.use-text-editor-font", defaultValue: "Use text editor font", comment: "Toggle label for using the editor font in terminal"), isOn: $settings.useTextEditorFont)
    }

    private var fontSelector: some View {
        MonospacedFontPicker(title: String(localized: "terminal.settings.font", defaultValue: "Font", comment: "Label for terminal font selection"), selectedFontName: $settings.font.name)
    }

    private var fontSizeSelector: some View {
        Stepper(
            String(localized: "terminal.settings.font-size", defaultValue: "Font Size", comment: "Label for terminal font size setting"),
            value: $settings.font.size,
            in: 1 ... 288,
            step: 1,
            format: .number
        )
    }

    private var fontWeightSelector: some View {
        FontWeightPicker(selection: $settings.font.weight)
    }

    private var injectionOptions: some View {
        VStack {
            Toggle(String(localized: "terminal.settings.shell-integration", defaultValue: "Shell Integration", comment: "Section title for terminal shell integration settings"), isOn: $settings.useShellIntegration)
                // swiftlint:disable:next line_length
                .help(String(localized: "terminal.settings.shell-integration.description", defaultValue: "CodeEdit supports integrating with common shells such as Bash and Zsh. This enables features like terminal title detection.", comment: "Description text explaining shell integration support"))
            if !settings.useShellIntegration {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(Color(NSColor.systemYellow))
                    Text(String(localized: "terminal.settings.shell-integration.warning", defaultValue: "Warning: Disabling integration disables features such as terminal title detection.", comment: "Warning text shown when shell integration is disabled"))
                    Spacer()
                }
            }
        }
    }

    @ViewBuilder private var useLoginShell: some View {
        if settings.useShellIntegration {
            Toggle(String(localized: "terminal.settings.use-login-shell", defaultValue: "Use Login Shell", comment: "Toggle label for using a login shell in terminal"), isOn: $settings.useLoginShell)
                // swiftlint:disable:next line_length
                .help(String(localized: "terminal.settings.use-login-shell.description", defaultValue: "Whether or not to use a login shell when starting a terminal session. By default, a login shell is used used similar to Terminal.app.", comment: "Help text describing login shell behavior"))
        }
    }
}
