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
        Picker(String(localized: "terminal.settings.shell", comment: "Terminal shell setting label"), selection: $settings.shell) {
            Text(String(localized: "terminal.settings.system_default", comment: "System default shell option"))
                .tag(SettingsData.TerminalShell.system)
            Divider()
            Text("Zsh")
                .tag(SettingsData.TerminalShell.zsh)
            Text("Bash")
                .tag(SettingsData.TerminalShell.bash)
        }
    }

    private var cursorStyle: some View {
        Picker(String(localized: "terminal.settings.cursor_style", comment: "Terminal cursor style setting label"), selection: $settings.cursorStyle) {
            Text(String(localized: "terminal.settings.cursor.block", comment: "Block cursor style option"))
                .tag(SettingsData.TerminalCursorStyle.block)
            Text(String(localized: "terminal.settings.cursor.underline", comment: "Underline cursor style option"))
                .tag(SettingsData.TerminalCursorStyle.underline)
            Text(String(localized: "terminal.settings.cursor.bar", comment: "Bar cursor style option"))
                .tag(SettingsData.TerminalCursorStyle.bar)
        }
    }

    private var cursorBlink: some View {
        Toggle(String(localized: "terminal.settings.blink_cursor", comment: "Blink cursor setting label"), isOn: $settings.cursorBlink)
    }

    private var optionAsMetaToggle: some View {
        Toggle("Use \"Option\" key as \"Meta\"", isOn: $settings.optionAsMeta)
    }

    private var useTextEditorFontToggle: some View {
        Toggle(String(localized: "terminal.settings.use_editor_font", comment: "Use text editor font setting label"), isOn: $settings.useTextEditorFont)
    }

    @ViewBuilder private var fontSelector: some View {
        MonospacedFontPicker(title: String(localized: "terminal.settings.font", comment: "Terminal font setting label"), selectedFontName: $settings.font.name)
    }

    private var fontSizeSelector: some View {
        Stepper(
            String(localized: "terminal.settings.font_size", comment: "Terminal font size setting label"),
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
            Toggle(String(localized: "terminal.settings.shell_integration", comment: "Shell integration setting label"), isOn: $settings.useShellIntegration)
            // swiftlint:disable:next line_length
                .help(String(localized: "terminal.settings.shell_integration.description", comment: "Shell integration feature description"))
            if !settings.useShellIntegration {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(Color(NSColor.systemYellow))
                    Text(String(localized: "terminal.settings.shell_integration.warning", comment: "Warning about disabling shell integration"))
                    Spacer()
                }
            }
        }
    }

    @ViewBuilder private var useLoginShell: some View {
        if settings.useShellIntegration {
            Toggle(String(localized: "terminal.settings.use_login_shell", comment: "Use login shell setting label"), isOn: $settings.useLoginShell)
            // swiftlint:disable:next line_length
                .help(String(localized: "terminal.settings.use_login_shell.description", comment: "Login shell setting description"))
        } else {
            EmptyView()
        }
    }
}
