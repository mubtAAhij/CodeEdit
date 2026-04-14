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
            Button(String(localized: "show-command-palette", defaultValue: "Show Command Palette", comment: "Show command palette button", os_id: "102783")) {
                NSApp.sendAction(#selector(CodeEditWindowController.openCommandPalette(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("p", modifiers: [.shift, .command])

            Button(String(localized: "open-search-navigator", defaultValue: "Open Search Navigator", comment: "Open search navigator button", os_id: "102784")) {
                NSApp.sendAction(#selector(CodeEditWindowController.openSearchNavigator(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("f", modifiers: [.shift, .command])

            Menu(String(localized: "font-size", defaultValue: "Font Size", comment: "Font size menu")) {
                Button(String(localized: "increase", defaultValue: "Increase", comment: "Increase button", os_id: "102785")) {
                    if editorFontSize < 288 {
                        editorFontSize += 1
                    }
                    if terminalFontSize < 288 {
                        terminalFontSize += 1
                    }
                }
                .keyboardShortcut("+")

                Button(String(localized: "decrease", defaultValue: "Decrease", comment: "Decrease button", os_id: "102786")) {
                    if editorFontSize > 1 {
                        editorFontSize -= 1
                    }
                    if terminalFontSize > 1 {
                        terminalFontSize -= 1
                    }
                }
                .keyboardShortcut("-")

                Divider()

                Button(String(localized: "reset", defaultValue: "Reset", comment: "Reset button", os_id: "102787")) {
                    editorFontSize = 12
                    terminalFontSize = 12
                }
                .keyboardShortcut("0", modifiers: [.command, .control])
            }
            .disabled(windowController == nil)

            Button(String(localized: "customize-toolbar", defaultValue: "Customize Toolbar...", comment: "Customize toolbar button", os_id: "102788")) {

            }
            .disabled(true)

            Divider()

            HideCommands()

            Divider()

            Button(String(format: String(localized: "toggle-jump-bar", defaultValue: "%@ Jump Bar", comment: "Toggle jump bar button", os_id: "102789"), showEditorJumpBar ? String(localized: "hide", defaultValue: "Hide", comment: "Hide action") : String(localized: "show", defaultValue: "Show", comment: "Show action"))) {
                showEditorJumpBar.toggle()
            }

            Toggle(String(localized: "dim-editors-without-focus", defaultValue: "Dim editors without focus", comment: "Dim editors without focus toggle", os_id: "102380"), isOn: $dimEditorsWithoutFocus)

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
            Button(String(format: String(localized: "toggle-navigator", defaultValue: "%@ Navigator", comment: "Toggle navigator button", os_id: "102792"), navigatorCollapsed ? String(localized: "show", defaultValue: "Show", comment: "Show action") : String(localized: "hide", defaultValue: "Hide", comment: "Hide action"))) {
                windowController?.toggleFirstPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("0", modifiers: [.command])

            Button(String(format: String(localized: "toggle-inspector", defaultValue: "%@ Inspector", comment: "Toggle inspector button", os_id: "102793"), inspectorCollapsed ? String(localized: "show", defaultValue: "Show", comment: "Show action") : String(localized: "hide", defaultValue: "Hide", comment: "Hide action"))) {
                windowController?.toggleLastPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("i", modifiers: [.control, .command])

            Button(String(format: String(localized: "toggle-utility-area", defaultValue: "%@ Utility Area", comment: "Toggle utility area button", os_id: "102794"), utilityAreaCollapsed ? String(localized: "show", defaultValue: "Show", comment: "Show action") : String(localized: "hide", defaultValue: "Hide", comment: "Hide action"))) {
                CommandManager.shared.executeCommand("open.drawer")
            }
            .disabled(windowController == nil)
            .keyboardShortcut("y", modifiers: [.shift, .command])

            Button(String(format: String(localized: "toggle-toolbar", defaultValue: "%@ Toolbar", comment: "Toggle toolbar button", os_id: "102795"), toolbarCollapsed ? String(localized: "show", defaultValue: "Show", comment: "Show action") : String(localized: "hide", defaultValue: "Hide", comment: "Hide action"))) {
                windowController?.toggleToolbar()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("t", modifiers: [.option, .command])

            Button(String(format: String(localized: "toggle-interface", defaultValue: "%@ Interface", comment: "Toggle interface button", os_id: "102796"), isInterfaceHidden ? String(localized: "show", defaultValue: "Show", comment: "Show action", os_id: "102791") : String(localized: "hide", defaultValue: "Hide", comment: "Hide action", os_id: "102790"))) {
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
            Menu(String(localized: "navigators", defaultValue: "Navigators", comment: "Navigators menu", os_id: "102797"), content: {
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
