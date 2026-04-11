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
        Picker(String(localized: "terminal.shell", defaultValue: "Shell", comment: "Label for shell picker"), selection: $settings.shell) {
            Text(String(localized: "terminal.shell.system-default", defaultValue: "System Default", comment: "Option for system default shell"))
                .tag(SettingsData.TerminalShell.system)
            Divider()
            Text(String(localized: "terminal.shell.zsh", defaultValue: "Zsh", comment: "Option for Zsh shell"))
                .tag(SettingsData.TerminalShell.zsh)
            Text(String(localized: "terminal.shell.bash", defaultValue: "Bash", comment: "Option for Bash shell"))
                .tag(SettingsData.TerminalShell.bash)
        }
    }

    private var cursorStyle: some View {
        Picker(String(localized: "terminal.cursor-style", defaultValue: "Terminal Cursor Style", comment: "Label for cursor style picker"), selection: $settings.cursorStyle) {
            Text(String(localized: "terminal.cursor-style.block", defaultValue: "Block", comment: "Option for block cursor style"))
                .tag(SettingsData.TerminalCursorStyle.block)
            Text(String(localized: "terminal.cursor-style.underline", defaultValue: "Underline", comment: "Option for underline cursor style"))
                .tag(SettingsData.TerminalCursorStyle.underline)
            Text(String(localized: "terminal.cursor-style.bar", defaultValue: "Bar", comment: "Option for bar cursor style"))
                .tag(SettingsData.TerminalCursorStyle.bar)
        }
    }

    private var cursorBlink: some View {
        Toggle(String(localized: "terminal.blink-cursor", defaultValue: "Blink Cursor", comment: "Toggle for cursor blinking"), isOn: $settings.cursorBlink)
    }

    private var optionAsMetaToggle: some View {
        Toggle(String(localized: "terminal.option-as-meta", defaultValue: "Use \"Option\" key as \"Meta\"", comment: "Toggle for using Option key as Meta key"), isOn: $settings.optionAsMeta)
    }

    private var useTextEditorFontToggle: some View {
        Toggle(String(localized: "terminal.use-editor-font", defaultValue: "Use text editor font", comment: "Toggle for using text editor font"), isOn: $settings.useTextEditorFont)
    }

    @ViewBuilder private var fontSelector: some View {
        MonospacedFontPicker(title: "Font", selectedFontName: $settings.font.name)
    }

    private var fontSizeSelector: some View {
        Stepper(
            String(localized: "terminal.font-size", defaultValue: "Font Size", comment: "Label for font size stepper"),
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
            Toggle(String(localized: "terminal.shell-integration", defaultValue: "Shell Integration", comment: "Toggle for shell integration"), isOn: $settings.useShellIntegration)
            // swiftlint:disable:next line_length
                .help(String(localized: "terminal.shell-integration.help", defaultValue: "CodeEdit supports integrating with common shells such as Bash and Zsh. This enables features like terminal title detection.", comment: "Help text for shell integration toggle"))
            if !settings.useShellIntegration {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(Color(NSColor.systemYellow))
                    Text(String(localized: "terminal.shell-integration.warning", defaultValue: "Warning: Disabling integration disables features such as terminal title detection.", comment: "Warning message when shell integration is disabled"))
                    Spacer()
                }
            }
        }
    }

    @ViewBuilder private var useLoginShell: some View {
        if settings.useShellIntegration {
            Toggle(String(localized: "terminal.use-login-shell", defaultValue: "Use Login Shell", comment: "Toggle for using login shell"), isOn: $settings.useLoginShell)
            // swiftlint:disable:next line_length
                .help(String(localized: "terminal.use-login-shell.help", defaultValue: "Whether or not to use a login shell when starting a terminal session. By default, a login shell is used used similar to Terminal.app.", comment: "Help text for login shell toggle"))
        } else {
            EmptyView()
        }
    }
}
