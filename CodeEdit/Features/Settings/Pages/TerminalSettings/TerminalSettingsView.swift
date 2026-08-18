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
        Picker(String(
            localized: "settings.terminal.shell.label",
            defaultValue: "Shell",
            comment: "Label for terminal shell selection"
        ), selection: $settings.shell) {
            Text(String(
                localized: "settings.terminal.shell.system-default.option",
                defaultValue: "System Default",
                comment: "Option title for using the system default shell"
            ))
                .tag(SettingsData.TerminalShell.system)
            Divider()
            Text(String(
                localized: "settings.terminal.shell.zsh.option",
                defaultValue: "Zsh",
                comment: "Option title for Zsh shell"
            ))
                .tag(SettingsData.TerminalShell.zsh)
            Text(String(
                localized: "settings.terminal.shell.bash.option",
                defaultValue: "Bash",
                comment: "Option title for Bash shell"
            ))
                .tag(SettingsData.TerminalShell.bash)
        }
    }

    private var cursorStyle: some View {
        Picker(String(
            localized: "settings.terminal.cursor-style.label",
            defaultValue: "Terminal Cursor Style",
            comment: "Label for terminal cursor style selection"
        ), selection: $settings.cursorStyle) {
            Text(String(
                localized: "settings.terminal.cursor-style.block.option",
                defaultValue: "Block",
                comment: "Option title for block cursor style"
            ))
                .tag(SettingsData.TerminalCursorStyle.block)
            Text(String(
                localized: "settings.terminal.cursor-style.underline.option",
                defaultValue: "Underline",
                comment: "Option title for underline cursor style"
            ))
                .tag(SettingsData.TerminalCursorStyle.underline)
            Text(String(
                localized: "settings.terminal.cursor-style.bar.option",
                defaultValue: "Bar",
                comment: "Option title for bar cursor style"
            ))
                .tag(SettingsData.TerminalCursorStyle.bar)
        }
    }

    private var cursorBlink: some View {
        Toggle(String(
            localized: "settings.terminal.blink-cursor.toggle",
            defaultValue: "Blink Cursor",
            comment: "Toggle title for blinking terminal cursor"
        ), isOn: $settings.cursorBlink)
    }

    private var optionAsMetaToggle: some View {
        Toggle(String(
            localized: "settings.terminal.use-option-as-meta.toggle",
            defaultValue: "Use \"Option\" key as \"Meta\"",
            comment: "Toggle title for mapping Option key to Meta in terminal"
        ), isOn: $settings.optionAsMeta)
    }

    private var useTextEditorFontToggle: some View {
        Toggle(String(
            localized: "settings.terminal.use-text-editor-font.toggle",
            defaultValue: "Use text editor font",
            comment: "Toggle title for using editor font in terminal"
        ), isOn: $settings.useTextEditorFont)
    }

    @ViewBuilder private var fontSelector: some View {
        MonospacedFontPicker(title: String(
            localized: "settings.terminal.font.label",
            defaultValue: "Font",
            comment: "Label for terminal font setting"
        ), selectedFontName: $settings.font.name)
    }

    private var fontSizeSelector: some View {
        Stepper(
            String(
                localized: "settings.terminal.font-size.label",
                defaultValue: "Font Size",
                comment: "Label for terminal font size setting"
            ),
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
            Toggle(String(
                localized: "settings.terminal.shell-integration.title",
                defaultValue: "Shell Integration",
                comment: "Section title for shell integration settings"
            ), isOn: $settings.useShellIntegration)
            // swiftlint:disable:next line_length
                .help(String(
                    localized: "settings.terminal.shell-integration.description",
                    defaultValue: "CodeEdit supports integrating with common shells such as Bash and Zsh. This enables features like terminal title detection.",
                    comment: "Description text explaining shell integration benefits"
                ))
            if !settings.useShellIntegration {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(Color(NSColor.systemYellow))
                    Text(String(
                        localized: "settings.terminal.shell-integration.warning",
                        defaultValue: "Warning: Disabling integration disables features such as terminal title detection.",
                        comment: "Warning text shown when shell integration is disabled"
                    ))
                    Spacer()
                }
            }
        }
    }

    @ViewBuilder private var useLoginShell: some View {
        if settings.useShellIntegration {
            Toggle(String(
                localized: "settings.terminal.use-login-shell.toggle",
                defaultValue: "Use Login Shell",
                comment: "Toggle title for starting terminal sessions as login shell"
            ), isOn: $settings.useLoginShell)
            // swiftlint:disable:next line_length
                .help(String(
                    localized: "settings.terminal.use-login-shell.description",
                    defaultValue: "Whether or not to use a login shell when starting a terminal session. By default, a login shell is used used similar to Terminal.app.",
                    comment: "Description text for login shell behavior setting"
                ))
        } else {
            EmptyView()
        }
    }
}
