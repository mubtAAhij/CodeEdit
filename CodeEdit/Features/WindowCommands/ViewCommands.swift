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
            Button(String(localized: "view.command.show.command.palette", defaultValue: "Show Command Palette", comment: "Show command palette menu item")) {
                NSApp.sendAction(#selector(CodeEditWindowController.openCommandPalette(_:)), to: nil, from: nil)
            }
            .keyboardShortcut(String(localized: "view.command.palette.shortcut", defaultValue: "p", comment: "Command palette keyboard shortcut"), modifiers: [.shift, .command])

            Button(String(localized: "view.command.open.search.navigator", defaultValue: "Open Search Navigator", comment: "Open search navigator menu item")) {
                NSApp.sendAction(#selector(CodeEditWindowController.openSearchNavigator(_:)), to: nil, from: nil)
            }
            .keyboardShortcut(String(localized: "view.command.search.shortcut", defaultValue: "f", comment: "Search navigator keyboard shortcut"), modifiers: [.shift, .command])

            Menu(String(localized: "view.command.font.size", defaultValue: "Font Size", comment: "Font size menu")) {
                Button(String(localized: "view.command.font.increase", defaultValue: "Increase", comment: "Increase font size menu item")) {
                    if editorFontSize < 288 {
                        editorFontSize += 1
                    }
                    if terminalFontSize < 288 {
                        terminalFontSize += 1
                    }
                }
                .keyboardShortcut("+")

                Button(String(localized: "view.command.font.decrease", defaultValue: "Decrease", comment: "Decrease font size menu item")) {
                    if editorFontSize > 1 {
                        editorFontSize -= 1
                    }
                    if terminalFontSize > 1 {
                        terminalFontSize -= 1
                    }
                }
                .keyboardShortcut(String(localized: "view.command.font.decrease.shortcut", defaultValue: "-", comment: "Decrease font size keyboard shortcut"))

                Divider()

                Button(String(localized: "view.command.font.reset", defaultValue: "Reset", comment: "Reset font size menu item")) {
                    editorFontSize = 12
                    terminalFontSize = 12
                }
                .keyboardShortcut(String(localized: "view.command.font.reset.shortcut", defaultValue: "0", comment: "Reset font size keyboard shortcut"), modifiers: [.command, .control])
            }
            .disabled(windowController == nil)

            Button(String(localized: "view.command.customize.toolbar", defaultValue: "Customize Toolbar...", comment: "Customize toolbar menu item")) {

            }
            .disabled(true)

            Divider()

            HideCommands()

            Divider()

            Button(String(format: String(localized: "view.command.toggle.jump.bar", defaultValue: "%@ Jump Bar", comment: "Toggle jump bar menu item"), showEditorJumpBar ? String(localized: "view.command.hide", defaultValue: "Hide", comment: "Hide action") : String(localized: "view.command.show", defaultValue: "Show", comment: "Show action"))) {
                showEditorJumpBar.toggle()
            }

            Toggle(String(localized: "view.command.dim.editors.without.focus", defaultValue: "Dim editors without focus", comment: "Dim editors without focus toggle"), isOn: $dimEditorsWithoutFocus)

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
            Button(String(format: String(localized: "view.command.toggle.navigator", defaultValue: "%@ Navigator", comment: "Toggle navigator menu item"), navigatorCollapsed ? String(localized: "view.command.show", defaultValue: "Show", comment: "Show action") : String(localized: "view.command.hide", defaultValue: "Hide", comment: "Hide action"))) {
                windowController?.toggleFirstPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut(String(localized: "view.command.navigator.shortcut", defaultValue: "0", comment: "Navigator keyboard shortcut"), modifiers: [.command])

            Button(String(format: String(localized: "view.command.toggle.inspector", defaultValue: "%@ Inspector", comment: "Toggle inspector menu item"), inspectorCollapsed ? String(localized: "view.command.show", defaultValue: "Show", comment: "Show action") : String(localized: "view.command.hide", defaultValue: "Hide", comment: "Hide action"))) {
                windowController?.toggleLastPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut(String(localized: "view.command.inspector.shortcut", defaultValue: "i", comment: "Inspector keyboard shortcut"), modifiers: [.control, .command])

            Button(String(format: String(localized: "view.command.toggle.utility.area", defaultValue: "%@ Utility Area", comment: "Toggle utility area menu item"), utilityAreaCollapsed ? String(localized: "view.command.show", defaultValue: "Show", comment: "Show action") : String(localized: "view.command.hide", defaultValue: "Hide", comment: "Hide action"))) {
                CommandManager.shared.executeCommand(String(localized: "view.command.open.drawer.command", defaultValue: "open.drawer", comment: "Open drawer command"))
            }
            .disabled(windowController == nil)
            .keyboardShortcut(String(localized: "view.command.utility.area.shortcut", defaultValue: "y", comment: "Utility area keyboard shortcut"), modifiers: [.shift, .command])

            Button(String(format: String(localized: "view.command.toggle.toolbar", defaultValue: "%@ Toolbar", comment: "Toggle toolbar menu item"), toolbarCollapsed ? String(localized: "view.command.show", defaultValue: "Show", comment: "Show action") : String(localized: "view.command.hide", defaultValue: "Hide", comment: "Hide action"))) {
                windowController?.toggleToolbar()
            }
            .disabled(windowController == nil)
            .keyboardShortcut(String(localized: "view.command.toolbar.shortcut", defaultValue: "t", comment: "Toolbar keyboard shortcut"), modifiers: [.option, .command])

            Button(String(format: String(localized: "view.command.toggle.interface", defaultValue: "%@ Interface", comment: "Toggle interface menu item"), isInterfaceHidden ? String(localized: "view.command.show", defaultValue: "Show", comment: "Show action") : String(localized: "view.command.hide", defaultValue: "Hide", comment: "Hide action"))) {
                windowController?.toggleInterface(shouldHide: !isInterfaceHidden)
            }
            .disabled(windowController == nil)
            .keyboardShortcut(String(localized: "view.command.interface.shortcut", defaultValue: "H", comment: "Interface keyboard shortcut"), modifiers: [.shift, .command])
        }
    }
}

extension ViewCommands {
    struct NavigatorCommands: View {
        @ObservedObject var model: NavigatorAreaViewModel

        var body: some View {
            Menu(String(localized: "view.command.navigators", defaultValue: "Navigators", comment: "Navigators menu"), content: {
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
