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
        Picker(String(localized: "terminal_settings.shell", comment: "Label for shell selector"), selection: $settings.shell) {
            Text(String(localized: "terminal_settings.shell.system_default", comment: "System default shell option"))
                .tag(SettingsData.TerminalShell.system)
            Divider()
            Text("Zsh")
                .tag(SettingsData.TerminalShell.zsh)
            Text("Bash")
                .tag(SettingsData.TerminalShell.bash)
        }
    }

    private var cursorStyle: some View {
        Picker(String(localized: "terminal_settings.cursor_style", comment: "Label for cursor style picker"), selection: $settings.cursorStyle) {
            Text(String(localized: "terminal_settings.cursor_style.block", comment: "Block cursor style option"))
                .tag(SettingsData.TerminalCursorStyle.block)
            Text(String(localized: "terminal_settings.cursor_style.underline", comment: "Underline cursor style option"))
                .tag(SettingsData.TerminalCursorStyle.underline)
            Text(String(localized: "terminal_settings.cursor_style.bar", comment: "Bar cursor style option"))
                .tag(SettingsData.TerminalCursorStyle.bar)
        }
    }

    private var cursorBlink: some View {
        Toggle(String(localized: "terminal_settings.blink_cursor", comment: "Toggle label for cursor blinking"), isOn: $settings.cursorBlink)
    }

    private var optionAsMetaToggle: some View {
        Toggle("Use \"Option\" key as \"Meta\"", isOn: $settings.optionAsMeta)
    }

    private var useTextEditorFontToggle: some View {
        Toggle(String(localized: "terminal_settings.use_text_editor_font", comment: "Toggle label for using text editor font"), isOn: $settings.useTextEditorFont)
    }

    @ViewBuilder private var fontSelector: some View {
        MonospacedFontPicker(title: String(localized: "terminal_settings.font", comment: "Label for font picker"), selectedFontName: $settings.font.name)
    }

    private var fontSizeSelector: some View {
        Stepper(
            String(localized: "terminal_settings.font_size", comment: "Label for font size stepper"),
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
            Toggle(String(localized: "terminal_settings.shell_integration", comment: "Toggle label for shell integration"), isOn: $settings.useShellIntegration)
            // swiftlint:disable:next line_length
                .help(String(localized: "terminal_settings.shell_integration.help", comment: "Help text for shell integration toggle"))
            if !settings.useShellIntegration {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(Color(NSColor.systemYellow))
                    Text(String(localized: "terminal_settings.shell_integration.warning", comment: "Warning text when shell integration is disabled"))
                    Spacer()
                }
            }
        }
    }

    @ViewBuilder private var useLoginShell: some View {
        if settings.useShellIntegration {
            Toggle(String(localized: "terminal_settings.use_login_shell", comment: "Toggle label for using login shell"), isOn: $settings.useLoginShell)
            // swiftlint:disable:next line_length
                .help(String(localized: "terminal_settings.use_login_shell.help", comment: "Help text for login shell toggle"))
        } else {
            EmptyView()
        }
    }
}
