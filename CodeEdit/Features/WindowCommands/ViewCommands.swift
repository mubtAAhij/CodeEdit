//
//  ViewCommands.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 13/03/2023.
//

import SwiftUI
import Combine

struct ViewCommands: Commands {
    @AppSettings(\.textEditing.font.size)
    var editorFontSize
    @AppSettings(\.terminal.font.size)
    var terminalFontSize
    @AppSettings(\.general.showEditorJumpBar)
    var showEditorJumpBar
    @AppSettings(\.general.dimEditorsWithoutFocus)
    var dimEditorsWithoutFocus

    @FocusedBinding(\.navigationSplitViewVisibility)
    var navigationSplitViewVisibility

    @FocusedBinding(\.inspectorVisibility)
    var inspectorVisibility

    @UpdatingWindowController var windowController: CodeEditWindowController?

    var body: some Commands {
        CommandGroup(after: .toolbar) {
            Button(String(localized: "view-commands.show-command-palette", defaultValue: "Show Command Palette", comment: "Show command palette menu item")) {
                NSApp.sendAction(#selector(CodeEditWindowController.openCommandPalette(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("p", modifiers: [.shift, .command])

            Button(String(localized: "view-commands.open-search-navigator", defaultValue: "Open Search Navigator", comment: "Open search navigator menu item")) {
                NSApp.sendAction(#selector(CodeEditWindowController.openSearchNavigator(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("f", modifiers: [.shift, .command])

            Menu(String(localized: "view-commands.font-size", defaultValue: "Font Size", comment: "Font size menu")) {
                Button(String(localized: "view-commands.increase", defaultValue: "Increase", comment: "Increase font size menu item")) {
                    if editorFontSize < 288 {
                        editorFontSize += 1
                    }
                    if terminalFontSize < 288 {
                        terminalFontSize += 1
                    }
                }
                .keyboardShortcut("+")

                Button(String(localized: "view-commands.decrease", defaultValue: "Decrease", comment: "Decrease font size menu item")) {
                    if editorFontSize > 1 {
                        editorFontSize -= 1
                    }
                    if terminalFontSize > 1 {
                        terminalFontSize -= 1
                    }
                }
                .keyboardShortcut("-")

                Divider()

                Button(String(localized: "view-commands.reset", defaultValue: "Reset", comment: "Reset font size menu item")) {
                    editorFontSize = 12
                    terminalFontSize = 12
                }
                .keyboardShortcut("0", modifiers: [.command, .control])
            }
            .disabled(windowController == nil)

            Button(String(localized: "view-commands.customize-toolbar", defaultValue: "Customize Toolbar...", comment: "Customize toolbar menu item")) {

            }
            .disabled(true)

            Divider()

            HideCommands()

            Divider()

            Button(String(format: String(localized: "view-commands.toggle-jump-bar", defaultValue: "%@ Jump Bar", comment: "Toggle jump bar menu item"), showEditorJumpBar ? String(localized: "view-commands.hide", defaultValue: "Hide", comment: "Hide label") : String(localized: "view-commands.show", defaultValue: "Show", comment: "Show label"))) {
                showEditorJumpBar.toggle()
            }

            Toggle(String(localized: "view-commands.dim-editors", defaultValue: "Dim editors without focus", comment: "Dim editors without focus toggle"), isOn: $dimEditorsWithoutFocus)

            Divider()

            if let model = windowController?.navigatorSidebarViewModel {
                Divider()
                NavigatorCommands(model: model)
            }
        }
    }
}

extension ViewCommands {
    struct HideCommands: View {
        @UpdatingWindowController var windowController: CodeEditWindowController?

        var navigatorCollapsed: Bool {
            windowController?.navigatorCollapsed ?? true
        }

        var inspectorCollapsed: Bool {
            windowController?.inspectorCollapsed ?? true
        }

        var utilityAreaCollapsed: Bool {
            windowController?.workspace?.utilityAreaModel?.isCollapsed ?? true
        }

        var toolbarCollapsed: Bool {
            windowController?.toolbarCollapsed ?? true
        }

        var isInterfaceHidden: Bool {
            return windowController?.isInterfaceStillHidden() ?? false
        }

        var body: some View {
            Button(String(format: String(localized: "view-commands.toggle-navigator", defaultValue: "%@ Navigator", comment: "Toggle navigator menu item"), navigatorCollapsed ? String(localized: "view-commands.show-navigator", defaultValue: "Show", comment: "Show navigator label") : String(localized: "view-commands.hide-navigator", defaultValue: "Hide", comment: "Hide navigator label"))) {
                windowController?.toggleFirstPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("0", modifiers: [.command])

            Button(String(format: String(localized: "view-commands.toggle-inspector", defaultValue: "%@ Inspector", comment: "Toggle inspector menu item"), inspectorCollapsed ? String(localized: "view-commands.show-inspector", defaultValue: "Show", comment: "Show inspector label") : String(localized: "view-commands.hide-inspector", defaultValue: "Hide", comment: "Hide inspector label"))) {
                windowController?.toggleLastPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("i", modifiers: [.control, .command])

            Button(String(format: String(localized: "view-commands.toggle-utility-area", defaultValue: "%@ Utility Area", comment: "Toggle utility area menu item"), utilityAreaCollapsed ? String(localized: "view-commands.show-utility-area", defaultValue: "Show", comment: "Show utility area label") : String(localized: "view-commands.hide-utility-area", defaultValue: "Hide", comment: "Hide utility area label"))) {
                CommandManager.shared.executeCommand("open.drawer")
            }
            .disabled(windowController == nil)
            .keyboardShortcut("y", modifiers: [.shift, .command])

            Button(String(format: String(localized: "view-commands.toggle-toolbar", defaultValue: "%@ Toolbar", comment: "Toggle toolbar menu item"), toolbarCollapsed ? String(localized: "view-commands.show-toolbar", defaultValue: "Show", comment: "Show toolbar label") : String(localized: "view-commands.hide-toolbar", defaultValue: "Hide", comment: "Hide toolbar label"))) {
                windowController?.toggleToolbar()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("t", modifiers: [.option, .command])

            Button(String(format: String(localized: "view-commands.toggle-interface", defaultValue: "%@ Interface", comment: "Toggle interface menu item"), isInterfaceHidden ? String(localized: "view-commands.show-interface", defaultValue: "Show", comment: "Show interface label") : String(localized: "view-commands.hide-interface", defaultValue: "Hide", comment: "Hide interface label"))) {
                windowController?.toggleInterface(shouldHide: !isInterfaceHidden)
            }
            .disabled(windowController == nil)
            .keyboardShortcut("H", modifiers: [.shift, .command])
        }
    }
}

extension ViewCommands {
    struct NavigatorCommands: View {
        @ObservedObject var model: NavigatorAreaViewModel

        var body: some View {
            Menu(String(localized: "view-commands.navigators", defaultValue: "Navigators", comment: "Navigators menu"), content: {
                ForEach(Array(model.tabItems.prefix(9).enumerated()), id: \.element) { index, tab in
                    Button(tab.title) {
                        model.setNavigatorTab(tab: tab)
                    }
                    .keyboardShortcut(KeyEquivalent(Character(String(index + 1))))
                }
            })
        }
    }
}
