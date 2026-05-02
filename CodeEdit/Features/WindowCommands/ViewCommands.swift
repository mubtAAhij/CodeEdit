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
            Button(String(localized: "view-commands.command-palette", defaultValue: "Show Command Palette", comment: "Menu item to show command palette")) {
                NSApp.sendAction(#selector(CodeEditWindowController.openCommandPalette(_:)), to: nil, from: nil)
            }
            .keyboardShortcut(String(localized: "view-commands.command-palette.shortcut", defaultValue: "p", comment: "Keyboard shortcut key for command palette"), modifiers: [.shift, .command])

            Button(String(localized: "view-commands.search-navigator", defaultValue: "Open Search Navigator", comment: "Menu item to open search navigator")) {
                NSApp.sendAction(#selector(CodeEditWindowController.openSearchNavigator(_:)), to: nil, from: nil)
            }
            .keyboardShortcut(String(localized: "view-commands.search-navigator.shortcut", defaultValue: "f", comment: "Keyboard shortcut key for search navigator"), modifiers: [.shift, .command])

            Menu(String(localized: "view-commands.font-size", defaultValue: "Font Size", comment: "Menu title for font size controls")) {
                Button(String(localized: "view-commands.font-size.increase", defaultValue: "Increase", comment: "Menu item to increase font size")) {
                    if editorFontSize < 288 {
                        editorFontSize += 1
                    }
                    if terminalFontSize < 288 {
                        terminalFontSize += 1
                    }
                }
                .keyboardShortcut("+")

                Button(String(localized: "view-commands.font-size.decrease", defaultValue: "Decrease", comment: "Menu item to decrease font size")) {
                    if editorFontSize > 1 {
                        editorFontSize -= 1
                    }
                    if terminalFontSize > 1 {
                        terminalFontSize -= 1
                    }
                }
                .keyboardShortcut(String(localized: "view-commands.font-size.decrease.shortcut", defaultValue: "-", comment: "Keyboard shortcut key for decrease font size"))

                Divider()

                Button(String(localized: "view-commands.font-size.reset", defaultValue: "Reset", comment: "Menu item to reset font size")) {
                    editorFontSize = 12
                    terminalFontSize = 12
                }
                .keyboardShortcut(String(localized: "view-commands.font-size.reset.shortcut", defaultValue: "0", comment: "Keyboard shortcut key for reset font size"), modifiers: [.command, .control])
            }
            .disabled(windowController == nil)

            Button(String(localized: "view-commands.customize-toolbar", defaultValue: "Customize Toolbar...", comment: "Menu item to customize toolbar")) {

            }
            .disabled(true)

            Divider()

            HideCommands()

            Divider()

            Button(String(format: String(localized: "view-commands.jump-bar", defaultValue: "%@ Jump Bar", comment: "Menu item to show/hide jump bar"), showEditorJumpBar ? String(localized: "view-commands.hide", defaultValue: "Hide", comment: "Action to hide a UI element") : String(localized: "view-commands.show", defaultValue: "Show", comment: "Action to show a UI element"))) {
                showEditorJumpBar.toggle()
            }

            Toggle(String(localized: "view-commands.dim-unfocused-editors", defaultValue: "Dim editors without focus", comment: "Toggle to dim editors without focus"), isOn: $dimEditorsWithoutFocus)

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
            Button(String(format: String(localized: "view-commands.navigator", defaultValue: "%@ Navigator", comment: "Menu item to show/hide navigator"), navigatorCollapsed ? String(localized: "view-commands.show", defaultValue: "Show", comment: "Action to show a UI element") : String(localized: "view-commands.hide", defaultValue: "Hide", comment: "Action to hide a UI element"))) {
                windowController?.toggleFirstPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut(String(localized: "view-commands.navigator.shortcut", defaultValue: "0", comment: "Keyboard shortcut key for navigator toggle"), modifiers: [.command])

            Button(String(format: String(localized: "view-commands.inspector", defaultValue: "%@ Inspector", comment: "Menu item to show/hide inspector"), inspectorCollapsed ? String(localized: "view-commands.show", defaultValue: "Show", comment: "Action to show a UI element") : String(localized: "view-commands.hide", defaultValue: "Hide", comment: "Action to hide a UI element"))) {
                windowController?.toggleLastPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut(String(localized: "view-commands.inspector.shortcut", defaultValue: "i", comment: "Keyboard shortcut key for inspector toggle"), modifiers: [.control, .command])

            Button(String(format: String(localized: "view-commands.utility-area", defaultValue: "%@ Utility Area", comment: "Menu item to show/hide utility area"), utilityAreaCollapsed ? String(localized: "view-commands.show", defaultValue: "Show", comment: "Action to show a UI element") : String(localized: "view-commands.hide", defaultValue: "Hide", comment: "Action to hide a UI element"))) {
                CommandManager.shared.executeCommand(String(localized: "view-commands.utility-area.command", defaultValue: "open.drawer", comment: "Command to toggle utility area"))
            }
            .disabled(windowController == nil)
            .keyboardShortcut(String(localized: "view-commands.utility-area.shortcut", defaultValue: "y", comment: "Keyboard shortcut key for utility area toggle"), modifiers: [.shift, .command])

            Button(String(format: String(localized: "view-commands.toolbar", defaultValue: "%@ Toolbar", comment: "Menu item to show/hide toolbar"), toolbarCollapsed ? String(localized: "view-commands.show", defaultValue: "Show", comment: "Action to show a UI element") : String(localized: "view-commands.hide", defaultValue: "Hide", comment: "Action to hide a UI element"))) {
                windowController?.toggleToolbar()
            }
            .disabled(windowController == nil)
            .keyboardShortcut(String(localized: "view-commands.toolbar.shortcut", defaultValue: "t", comment: "Keyboard shortcut key for toolbar toggle"), modifiers: [.option, .command])

            Button(String(format: String(localized: "view-commands.interface", defaultValue: "%@ Interface", comment: "Menu item to show/hide interface"), isInterfaceHidden ? String(localized: "view-commands.show", defaultValue: "Show", comment: "Action to show a UI element") : String(localized: "view-commands.hide", defaultValue: "Hide", comment: "Action to hide a UI element"))) {
                windowController?.toggleInterface(shouldHide: !isInterfaceHidden)
            }
            .disabled(windowController == nil)
            .keyboardShortcut(String(localized: "view-commands.interface.shortcut", defaultValue: "H", comment: "Keyboard shortcut key for interface toggle"), modifiers: [.shift, .command])
        }
    }
}

extension ViewCommands {
    struct NavigatorCommands: View {
        @ObservedObject var model: NavigatorAreaViewModel

        var body: some View {
            Menu(String(localized: "view-commands.navigators", defaultValue: "Navigators", comment: "Menu title for navigators"), content: {
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
