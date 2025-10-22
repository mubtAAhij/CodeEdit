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
        Picker(String(localized: "terminal.shell", defaultValue: "Shell", comment: "Label text"), selection: $settings.shell) {
            Text("terminal.shell.system_default", defaultValue: "System Default", comment: "Option text")
                .tag(SettingsData.TerminalShell.system)
            Divider()
            Text("Zsh")
                .tag(SettingsData.TerminalShell.zsh)
            Text("Bash")
                .tag(SettingsData.TerminalShell.bash)
        }
    }

    private var cursorStyle: some View {
        Picker(String(localized: "terminal.cursor_style", defaultValue: "Terminal Cursor Style", comment: "Label text"), selection: $settings.cursorStyle) {
            Text("terminal.cursor_style.block", defaultValue: "Block", comment: "Option text")
                .tag(SettingsData.TerminalCursorStyle.block)
            Text("terminal.cursor_style.underline", defaultValue: "Underline", comment: "Option text")
                .tag(SettingsData.TerminalCursorStyle.underline)
            Text("terminal.cursor_style.bar", defaultValue: "Bar", comment: "Option text")
                .tag(SettingsData.TerminalCursorStyle.bar)
        }
    }

    private var cursorBlink: some View {
        Toggle(String(localized: "terminal.blink_cursor", defaultValue: "Blink Cursor", comment: "Toggle text"), isOn: $settings.cursorBlink)
    }

    private var optionAsMetaToggle: some View {
        Toggle(String(localized: "terminal.option_as_meta", defaultValue: "Use \"Option\" key as \"Meta\"", comment: "Toggle text"), isOn: $settings.optionAsMeta)
    }

    private var useTextEditorFontToggle: some View {
        Toggle(String(localized: "terminal.use_text_editor_font", defaultValue: "Use text editor font", comment: "Toggle text"), isOn: $settings.useTextEditorFont)
    }

    @ViewBuilder private var fontSelector: some View {
        MonospacedFontPicker(title: String(localized: "terminal.font", defaultValue: "Font", comment: "Label text"), selectedFontName: $settings.font.name)
    }

    private var fontSizeSelector: some View {
        Stepper(
            String(localized: "terminal.font_size", defaultValue: "Font Size", comment: "Label text"),
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
            Toggle(String(localized: "terminal.shell_integration", defaultValue: "Shell Integration", comment: "Toggle text"), isOn: $settings.useShellIntegration)
            // swiftlint:disable:next line_length
                .help(String(localized: "terminal.shell_integration.help", defaultValue: "CodeEdit supports integrating with common shells such as Bash and Zsh. This enables features like terminal title detection.", comment: "Help text"))
            if !settings.useShellIntegration {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(Color(NSColor.systemYellow))
                    Text("terminal.shell_integration.warning", defaultValue: "Warning: Disabling integration disables features such as terminal title detection.", comment: "Warning text")
                    Spacer()
                }
            }
        }
    }

    @ViewBuilder private var useLoginShell: some View {
        if settings.useShellIntegration {
            Toggle(String(localized: "terminal.use_login_shell", defaultValue: "Use Login Shell", comment: "Toggle text"), isOn: $settings.useLoginShell)
            // swiftlint:disable:next line_length
                .help(String(localized: "terminal.use_login_shell.help", defaultValue: "Whether or not to use a login shell when starting a terminal session. By default, a login shell is used used similar to Terminal.app.", comment: "Help text"))
        } else {
            EmptyView()
        }
    }
}
