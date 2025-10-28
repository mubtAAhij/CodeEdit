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
        Picker("terminal.settings.shell", comment: "Shell selector label", selection: $settings.shell) {
            Text("terminal.settings.shell.system_default", comment: "System default shell option")
                .tag(SettingsData.TerminalShell.system)
            Divider()
            Text("Zsh")
                .tag(SettingsData.TerminalShell.zsh)
            Text("Bash")
                .tag(SettingsData.TerminalShell.bash)
        }
    }

    private var cursorStyle: some View {
        Picker("terminal.settings.cursor_style", comment: "Terminal cursor style selector", selection: $settings.cursorStyle) {
            Text("terminal.settings.cursor_style.block", comment: "Block cursor option")
                .tag(SettingsData.TerminalCursorStyle.block)
            Text("terminal.settings.cursor_style.underline", comment: "Underline cursor option")
                .tag(SettingsData.TerminalCursorStyle.underline)
            Text("terminal.settings.cursor_style.bar", comment: "Bar cursor option")
                .tag(SettingsData.TerminalCursorStyle.bar)
        }
    }

    private var cursorBlink: some View {
        Toggle("terminal.settings.cursor_blink", comment: "Cursor blink toggle", isOn: $settings.cursorBlink)
    }

    private var optionAsMetaToggle: some View {
        Toggle("terminal.settings.option_as_meta", comment: "Option key as Meta toggle", isOn: $settings.optionAsMeta)
    }

    private var useTextEditorFontToggle: some View {
        Toggle("terminal.settings.use_text_editor_font", comment: "Use text editor font toggle", isOn: $settings.useTextEditorFont)
    }

    @ViewBuilder private var fontSelector: some View {
        MonospacedFontPicker(title: String(localized: "terminal.settings.font", comment: "Font selector label"), selectedFontName: $settings.font.name)
    }

    private var fontSizeSelector: some View {
        Stepper(
            "terminal.settings.font_size",
            comment: "Font size stepper",
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
            Toggle("terminal.settings.shell_integration", comment: "Shell integration toggle", isOn: $settings.useShellIntegration)
            // swiftlint:disable:next line_length
                .help("terminal.settings.shell_integration.help", comment: "Shell integration help text")
            if !settings.useShellIntegration {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(Color(NSColor.systemYellow))
                    Text("terminal.settings.shell_integration.warning", comment: "Shell integration warning")
                    Spacer()
                }
            }
        }
    }

    @ViewBuilder private var useLoginShell: some View {
        if settings.useShellIntegration {
            Toggle("terminal.settings.use_login_shell", comment: "Use login shell toggle", isOn: $settings.useLoginShell)
            // swiftlint:disable:next line_length
                .help("terminal.settings.use_login_shell.help", comment: "Use login shell help text")
        } else {
            EmptyView()
        }
    }
}
