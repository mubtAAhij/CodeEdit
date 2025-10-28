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
        Picker("terminal.shell", comment: "Shell picker label", selection: $settings.shell) {
            Text("terminal.shell.system_default", comment: "Default shell option")
                .tag(SettingsData.TerminalShell.system)
            Divider()
            Text("Zsh")
                .tag(SettingsData.TerminalShell.zsh)
            Text("Bash")
                .tag(SettingsData.TerminalShell.bash)
        }
    }

    private var cursorStyle: some View {
        Picker("terminal.cursor_style", comment: "Terminal cursor style picker", selection: $settings.cursorStyle) {
            Text("terminal.cursor.block", comment: "Block cursor style")
                .tag(SettingsData.TerminalCursorStyle.block)
            Text("terminal.cursor.underline", comment: "Underline cursor style")
                .tag(SettingsData.TerminalCursorStyle.underline)
            Text("terminal.cursor.bar", comment: "Bar cursor style")
                .tag(SettingsData.TerminalCursorStyle.bar)
        }
    }

    private var cursorBlink: some View {
        Toggle("terminal.cursor.blink", comment: "Blink cursor toggle", isOn: $settings.cursorBlink)
    }

    private var optionAsMetaToggle: some View {
        Toggle("terminal.option_as_meta", comment: "Use Option key as Meta toggle", isOn: $settings.optionAsMeta)
    }

    private var useTextEditorFontToggle: some View {
        Toggle("terminal.use_editor_font", comment: "Use text editor font toggle", isOn: $settings.useTextEditorFont)
    }

    @ViewBuilder private var fontSelector: some View {
        MonospacedFontPicker(title: String(localized: "terminal.font", comment: "Font picker label"), selectedFontName: $settings.font.name)
    }

    private var fontSizeSelector: some View {
        Stepper(
            "terminal.font_size",
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
            Toggle("terminal.shell_integration", comment: "Shell integration toggle", isOn: $settings.useShellIntegration)
            // swiftlint:disable:next line_length
                .help("terminal.shell_integration.help", comment: "Shell integration help text")
            if !settings.useShellIntegration {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(Color(NSColor.systemYellow))
                    Text("terminal.shell_integration.warning", comment: "Shell integration warning")
                    Spacer()
                }
            }
        }
    }

    @ViewBuilder private var useLoginShell: some View {
        if settings.useShellIntegration {
            Toggle("terminal.use_login_shell", comment: "Use login shell toggle", isOn: $settings.useLoginShell)
            // swiftlint:disable:next line_length
                .help("terminal.use_login_shell.help", comment: "Use login shell help text")
        } else {
            EmptyView()
        }
    }
}
