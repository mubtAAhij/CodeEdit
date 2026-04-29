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
        Picker(String(localized: "terminal-settings.shell", defaultValue: "Shell", comment: "Label for shell picker"), selection: $settings.shell) {
            Text(String(localized: "terminal-settings.shell.system-default", defaultValue: "System Default", comment: "System default shell option"))
                .tag(SettingsData.TerminalShell.system)
            Divider()
            Text(String(localized: "terminal-settings.shell.zsh", defaultValue: "Zsh", comment: "Zsh shell option"))
                .tag(SettingsData.TerminalShell.zsh)
            Text(String(localized: "terminal-settings.shell.bash", defaultValue: "Bash", comment: "Bash shell option"))
                .tag(SettingsData.TerminalShell.bash)
        }
    }

    private var cursorStyle: some View {
        Picker(String(localized: "terminal-settings.cursor-style", defaultValue: "Terminal Cursor Style", comment: "Label for cursor style picker"), selection: $settings.cursorStyle) {
            Text(String(localized: "terminal-settings.cursor-style.block", defaultValue: "Block", comment: "Block cursor style option"))
                .tag(SettingsData.TerminalCursorStyle.block)
            Text(String(localized: "terminal-settings.cursor-style.underline", defaultValue: "Underline", comment: "Underline cursor style option"))
                .tag(SettingsData.TerminalCursorStyle.underline)
            Text(String(localized: "terminal-settings.cursor-style.bar", defaultValue: "Bar", comment: "Bar cursor style option"))
                .tag(SettingsData.TerminalCursorStyle.bar)
        }
    }

    private var cursorBlink: some View {
        Toggle(String(localized: "terminal-settings.blink-cursor", defaultValue: "Blink Cursor", comment: "Toggle for cursor blinking"), isOn: $settings.cursorBlink)
    }

    private var optionAsMetaToggle: some View {
        Toggle(String(localized: "terminal-settings.option-as-meta", defaultValue: "Use \"Option\" key as \"Meta\"", comment: "Toggle for Option as Meta key"), isOn: $settings.optionAsMeta)
    }

    private var useTextEditorFontToggle: some View {
        Toggle(String(localized: "terminal-settings.use-text-editor-font", defaultValue: "Use text editor font", comment: "Toggle to use text editor font"), isOn: $settings.useTextEditorFont)
    }

    @ViewBuilder private var fontSelector: some View {
        MonospacedFontPicker(title: String(localized: "font", defaultValue: "Font", comment: "Label for font picker"), selectedFontName: $settings.font.name)
    }

    private var fontSizeSelector: some View {
        Stepper(
            String(localized: "terminal-settings.font-size", defaultValue: "Font Size", comment: "Label for font size stepper"),
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
            Toggle(String(localized: "terminal-settings.shell-integration", defaultValue: "Shell Integration", comment: "Toggle for shell integration"), isOn: $settings.useShellIntegration)
            // swiftlint:disable:next line_length
                .help(String(localized: "terminal-settings.shell-integration-help", defaultValue: "CodeEdit supports integrating with common shells such as Bash and Zsh. This enables features like terminal title detection.", comment: "Help text for shell integration toggle"))
            if !settings.useShellIntegration {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(Color(NSColor.systemYellow))
                    Text(String(localized: "terminal-settings.shell-integration-warning", defaultValue: "Warning: Disabling integration disables features such as terminal title detection.", comment: "Warning when shell integration is disabled"))
                    Spacer()
                }
            }
        }
    }

    @ViewBuilder private var useLoginShell: some View {
        if settings.useShellIntegration {
            Toggle(String(localized: "terminal-settings.use-login-shell", defaultValue: "Use Login Shell", comment: "Toggle to use login shell"), isOn: $settings.useLoginShell)
            // swiftlint:disable:next line_length
                .help(String(localized: "terminal-settings.use-login-shell-help", defaultValue: "Whether or not to use a login shell when starting a terminal session. By default, a login shell is used used similar to Terminal.app.", comment: "Help text for login shell toggle"))
        } else {
            EmptyView()
        }
    }
}
