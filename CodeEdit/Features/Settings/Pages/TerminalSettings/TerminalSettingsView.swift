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
        Picker(String(localized: "terminal.shell", defaultValue: "Shell", comment: "Shell picker label"), selection: $settings.shell) {
            Text(String(localized: "terminal.shell.system", defaultValue: "System Default", comment: "System default shell option"))
                .tag(SettingsData.TerminalShell.system)
            Divider()
            Text(String(localized: "terminal.shell.zsh", defaultValue: "Zsh", comment: "Zsh shell option"))
                .tag(SettingsData.TerminalShell.zsh)
            Text(String(localized: "terminal.shell.bash", defaultValue: "Bash", comment: "Bash shell option"))
                .tag(SettingsData.TerminalShell.bash)
        }
    }

    private var cursorStyle: some View {
        Picker(String(localized: "terminal.cursor-style", defaultValue: "Terminal Cursor Style", comment: "Cursor style picker label"), selection: $settings.cursorStyle) {
            Text(String(localized: "terminal.cursor-style.block", defaultValue: "Block", comment: "Block cursor style option"))
                .tag(SettingsData.TerminalCursorStyle.block)
            Text(String(localized: "terminal.cursor-style.underline", defaultValue: "Underline", comment: "Underline cursor style option"))
                .tag(SettingsData.TerminalCursorStyle.underline)
            Text(String(localized: "terminal.cursor-style.bar", defaultValue: "Bar", comment: "Bar cursor style option"))
                .tag(SettingsData.TerminalCursorStyle.bar)
        }
    }

    private var cursorBlink: some View {
        Toggle(String(localized: "terminal.blink-cursor", defaultValue: "Blink Cursor", comment: "Blink cursor toggle"), isOn: $settings.cursorBlink)
    }

    private var optionAsMetaToggle: some View {
        Toggle(String(localized: "terminal.option-as-meta", defaultValue: "Use \"Option\" key as \"Meta\"", comment: "Option as meta key toggle"), isOn: $settings.optionAsMeta)
    }

    private var useTextEditorFontToggle: some View {
        Toggle(String(localized: "terminal.use-editor-font", defaultValue: "Use text editor font", comment: "Use text editor font toggle"), isOn: $settings.useTextEditorFont)
    }

    @ViewBuilder private var fontSelector: some View {
        MonospacedFontPicker(title: String(localized: "terminal.font", defaultValue: "Font", comment: "Font picker label"), selectedFontName: $settings.font.name)
    }

    private var fontSizeSelector: some View {
        Stepper(
            String(localized: "terminal.font-size", defaultValue: "Font Size", comment: "Font size stepper label"),
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
            Toggle(String(localized: "terminal.shell-integration", defaultValue: "Shell Integration", comment: "Shell integration toggle"), isOn: $settings.useShellIntegration)
            // swiftlint:disable:next line_length
                .help(String(localized: "terminal.shell-integration-help", defaultValue: "CodeEdit supports integrating with common shells such as Bash and Zsh. This enables features like terminal title detection.", comment: "Shell integration help text"))
            if !settings.useShellIntegration {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(Color(NSColor.systemYellow))
                    Text(String(localized: "terminal.shell-integration-warning", defaultValue: "Warning: Disabling integration disables features such as terminal title detection.", comment: "Shell integration warning"))
                    Spacer()
                }
            }
        }
    }

    @ViewBuilder private var useLoginShell: some View {
        if settings.useShellIntegration {
            Toggle(String(localized: "terminal.use-login-shell", defaultValue: "Use Login Shell", comment: "Use login shell toggle"), isOn: $settings.useLoginShell)
            // swiftlint:disable:next line_length
                .help(String(localized: "terminal.use-login-shell-help", defaultValue: "Whether or not to use a login shell when starting a terminal session. By default, a login shell is used used similar to Terminal.app.", comment: "Use login shell help text"))
        } else {
            EmptyView()
        }
    }
}
