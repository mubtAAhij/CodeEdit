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
        Picker(String(localized: "shell", defaultValue: "Shell", comment: "Shell picker label", os_id: "102464"), selection: $settings.shell) {
            Text(String(localized: "system-default", defaultValue: "System Default", comment: "System default shell option", os_id: "102470"))
                .tag(SettingsData.TerminalShell.system)
            Divider()
            Text(String(localized: "zsh", defaultValue: "Zsh", comment: "Zsh shell option", os_id: "102471"))
                .tag(SettingsData.TerminalShell.zsh)
            Text(String(localized: "bash", defaultValue: "Bash", comment: "Bash shell option", os_id: "102472"))
                .tag(SettingsData.TerminalShell.bash)
        }
    }

    private var cursorStyle: some View {
        Picker(String(localized: "terminal-cursor-style", defaultValue: "Terminal Cursor Style", comment: "Terminal cursor style picker label", os_id: "102468"), selection: $settings.cursorStyle) {
            Text(String(localized: "block", defaultValue: "Block", comment: "Block cursor style option", os_id: "102473"))
                .tag(SettingsData.TerminalCursorStyle.block)
            Text(String(localized: "underline", defaultValue: "Underline", comment: "Underline cursor style option"))
                .tag(SettingsData.TerminalCursorStyle.underline)
            Text(String(localized: "bar", defaultValue: "Bar", comment: "Bar cursor style option", os_id: "102475"))
                .tag(SettingsData.TerminalCursorStyle.bar)
        }
    }

    private var cursorBlink: some View {
        Toggle(String(localized: "blink-cursor", defaultValue: "Blink Cursor", comment: "Blink cursor toggle label", os_id: "102469"), isOn: $settings.cursorBlink)
    }

    private var optionAsMetaToggle: some View {
        Toggle(String(localized: "use-option-as-meta", defaultValue: "Use \"Option\" key as \"Meta\"", comment: "Use option key as meta toggle label", os_id: "102465"), isOn: $settings.optionAsMeta)
    }

    private var useTextEditorFontToggle: some View {
        Toggle(String(localized: "use-text-editor-font", defaultValue: "Use text editor font", comment: "Use text editor font toggle label", os_id: "102466"), isOn: $settings.useTextEditorFont)
    }

    @ViewBuilder private var fontSelector: some View {
        MonospacedFontPicker(title: "Font", selectedFontName: $settings.font.name)
    }

    private var fontSizeSelector: some View {
        Stepper(
            String(localized: "font-size", defaultValue: "Font Size", comment: "Font size stepper label"),
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
            Toggle(String(localized: "shell-integration", defaultValue: "Shell Integration", comment: "Shell integration toggle label", os_id: "102476"), isOn: $settings.useShellIntegration)
            // swiftlint:disable:next line_length
                .help(String(localized: "shell-integration-help", defaultValue: "CodeEdit supports integrating with common shells such as Bash and Zsh. This enables features like terminal title detection.", comment: "Shell integration help text", os_id: "102477"))
            if !settings.useShellIntegration {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(Color(NSColor.systemYellow))
                    Text(String(localized: "shell-integration-warning", defaultValue: "Warning: Disabling integration disables features such as terminal title detection.", comment: "Shell integration warning message", os_id: "102478"))
                    Spacer()
                }
            }
        }
    }

    @ViewBuilder private var useLoginShell: some View {
        if settings.useShellIntegration {
            Toggle(String(localized: "use-login-shell", defaultValue: "Use Login Shell", comment: "Use login shell toggle label", os_id: "102479"), isOn: $settings.useLoginShell)
            // swiftlint:disable:next line_length
                .help(String(localized: "use-login-shell-help", defaultValue: "Whether or not to use a login shell when starting a terminal session. By default, a login shell is used used similar to Terminal.app.", comment: "Use login shell help text", os_id: "102480"))
        } else {
            EmptyView()
        }
    }
}
