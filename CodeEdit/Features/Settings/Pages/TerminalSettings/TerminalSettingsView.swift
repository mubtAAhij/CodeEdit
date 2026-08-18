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
        Picker(String(localized: "settings.terminal.shell", defaultValue: "Shell", comment: "Terminal settings label for shell selection"), selection: $settings.shell) {
            Text(String(localized: "settings.terminal.shell.system-default", defaultValue: "System Default", comment: "Terminal shell picker option for using the system default shell"))
                .tag(SettingsData.TerminalShell.system)
            Divider()
            Text(String(localized: "settings.terminal.shell.zsh", defaultValue: "Zsh", comment: "Terminal shell picker option for Zsh"))
                .tag(SettingsData.TerminalShell.zsh)
            Text(String(localized: "settings.terminal.shell.bash", defaultValue: "Bash", comment: "Terminal shell picker option for Bash"))
                .tag(SettingsData.TerminalShell.bash)
        }
    }

    private var cursorStyle: some View {
        Picker(String(localized: "settings.terminal.cursor-style", defaultValue: "Terminal Cursor Style", comment: "Terminal settings label for cursor style selection"), selection: $settings.cursorStyle) {
            Text(String(localized: "settings.terminal.cursor-style.block", defaultValue: "Block", comment: "Terminal cursor style option for block cursor"))
                .tag(SettingsData.TerminalCursorStyle.block)
            Text(String(localized: "settings.terminal.cursor-style.underline", defaultValue: "Underline", comment: "Terminal cursor style option for underline cursor"))
                .tag(SettingsData.TerminalCursorStyle.underline)
            Text(String(localized: "settings.terminal.cursor-style.bar", defaultValue: "Bar", comment: "Terminal cursor style option for bar cursor"))
                .tag(SettingsData.TerminalCursorStyle.bar)
        }
    }

    private var cursorBlink: some View {
        Toggle(String(localized: "settings.terminal.blink-cursor", defaultValue: "Blink Cursor", comment: "Terminal settings toggle for blinking cursor"), isOn: $settings.cursorBlink)
    }

    private var optionAsMetaToggle: some View {
        Toggle(String(localized: "settings.terminal.use-option-as-meta", defaultValue: "Use \"Option\" key as \"Meta\"", comment: "Terminal settings toggle to treat Option key as Meta"), isOn: $settings.optionAsMeta)
    }

    private var useTextEditorFontToggle: some View {
        Toggle(String(localized: "settings.terminal.use-text-editor-font", defaultValue: "Use text editor font", comment: "Terminal settings toggle for using editor font in terminal"), isOn: $settings.useTextEditorFont)
    }

    @ViewBuilder private var fontSelector: some View {
        MonospacedFontPicker(title: String(localized: "settings.terminal.font", defaultValue: "Font", comment: "Terminal settings label for font selection"), selectedFontName: $settings.font.name)
    }

    private var fontSizeSelector: some View {
        Stepper(
            String(localized: "settings.terminal.font-size", defaultValue: "Font Size", comment: "Terminal settings label for terminal font size"),
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
            Toggle(String(localized: "settings.terminal.shell-integration.title", defaultValue: "Shell Integration", comment: "Terminal settings section title for shell integration"), isOn: $settings.useShellIntegration)
            // swiftlint:disable:next line_length
                .help(String(localized: "settings.terminal.shell-integration.description", defaultValue: "CodeEdit supports integrating with common shells such as Bash and Zsh. This enables features like terminal title detection.", comment: "Terminal settings description explaining shell integration support and benefits"))
            if !settings.useShellIntegration {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(Color(NSColor.systemYellow))
                    Text(String(localized: "settings.terminal.shell-integration.warning", defaultValue: "Warning: Disabling integration disables features such as terminal title detection.", comment: "Warning text shown when shell integration is disabled"))
                    Spacer()
                }
            }
        }
    }

    @ViewBuilder private var useLoginShell: some View {
        if settings.useShellIntegration {
            Toggle(String(localized: "settings.terminal.use-login-shell", defaultValue: "Use Login Shell", comment: "Terminal settings toggle for using a login shell"), isOn: $settings.useLoginShell)
            // swiftlint:disable:next line_length
                .help(String(localized: "settings.terminal.use-login-shell.description", defaultValue: "Whether or not to use a login shell when starting a terminal session. By default, a login shell is used used similar to Terminal.app.", comment: "Terminal settings help text explaining login shell behavior"))
        } else {
            EmptyView()
        }
    }
}
