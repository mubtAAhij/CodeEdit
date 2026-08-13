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
            Button(String(localized: "window-commands.view.show-command-palette", defaultValue: "Show Command Palette", comment: "Menu item title to open the command palette")) {
                NSApp.sendAction(#selector(CodeEditWindowController.openCommandPalette(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("p", modifiers: [.shift, .command])

            Button(String(localized: "window-commands.view.open-search-navigator", defaultValue: "Open Search Navigator", comment: "Menu item title to open the search navigator")) {
                NSApp.sendAction(#selector(CodeEditWindowController.openSearchNavigator(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("f", modifiers: [.shift, .command])

            Menu(String(localized: "window-commands.view.font-size.menu-title", defaultValue: "Font Size", comment: "Title of the Font Size submenu")) {
                Button(String(localized: "window-commands.view.font-size.increase", defaultValue: "Increase", comment: "Menu item title to increase editor font size")) {
                    if editorFontSize < 288 {
                        editorFontSize += 1
                    }
                    if terminalFontSize < 288 {
                        terminalFontSize += 1
                    }
                }
                .keyboardShortcut("+")

                Button(String(localized: "window-commands.view.font-size.decrease", defaultValue: "Decrease", comment: "Menu item title to decrease editor font size")) {
                    if editorFontSize > 1 {
                        editorFontSize -= 1
                    }
                    if terminalFontSize > 1 {
                        terminalFontSize -= 1
                    }
                }
                .keyboardShortcut("-")

                Divider()

                Button(String(localized: "window-commands.view.font-size.reset", defaultValue: "Reset", comment: "Menu item title to reset editor font size")) {
                    editorFontSize = 12
                    terminalFontSize = 12
                }
                .keyboardShortcut("0", modifiers: [.command, .control])
            }
            .disabled(windowController == nil)

            Button(String(localized: "window-commands.view.customize-toolbar", defaultValue: "Customize Toolbar...", comment: "Menu item title to customize toolbar")) {

            }
            .disabled(true)

            Divider()

            HideCommands()

            Divider()

            Button(String(format: String(localized: "window-commands.view.toggle-jump-bar", defaultValue: "%@ Jump Bar", comment: "Menu item title to show or hide jump bar"), (showEditorJumpBar ? String(localized: "window-commands.view.action.hide", defaultValue: "Hide", comment: "Verb used in view menu toggle labels") : String(localized: "window-commands.view.action.show", defaultValue: "Show", comment: "Verb used in view menu toggle labels")))) {
                showEditorJumpBar.toggle()
            }

            Toggle(String(localized: "window-commands.view.dim-editors-without-focus", defaultValue: "Dim editors without focus", comment: "Menu item title to dim unfocused editors"), isOn: $dimEditorsWithoutFocus)

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
            Button(String(format: String(localized: "window-commands.view.toggle-navigator", defaultValue: "%@ Navigator", comment: "Menu item title to show or hide navigator"), (navigatorCollapsed ? String(localized: "window-commands.view.action.show", defaultValue: "Show", comment: "Verb used in view menu toggle labels") : String(localized: "window-commands.view.action.hide", defaultValue: "Hide", comment: "Verb used in view menu toggle labels")))) {
                windowController?.toggleFirstPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("0", modifiers: [.command])

            Button(String(format: String(localized: "window-commands.view.toggle-inspector", defaultValue: "%@ Inspector", comment: "Menu item title to show or hide inspector"), (inspectorCollapsed ? String(localized: "window-commands.view.action.show", defaultValue: "Show", comment: "Verb used in view menu toggle labels") : String(localized: "window-commands.view.action.hide", defaultValue: "Hide", comment: "Verb used in view menu toggle labels")))) {
                windowController?.toggleLastPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("i", modifiers: [.control, .command])

            Button(String(format: String(localized: "window-commands.view.toggle-utility-area", defaultValue: "%@ Utility Area", comment: "Menu item title to show or hide utility area"), (utilityAreaCollapsed ? String(localized: "window-commands.view.action.show", defaultValue: "Show", comment: "Verb used in view menu toggle labels") : String(localized: "window-commands.view.action.hide", defaultValue: "Hide", comment: "Verb used in view menu toggle labels")))) {
                CommandManager.shared.executeCommand("open.drawer")
            }
            .disabled(windowController == nil)
            .keyboardShortcut("y", modifiers: [.shift, .command])

            Button(String(format: String(localized: "window-commands.view.toggle-toolbar", defaultValue: "%@ Toolbar", comment: "Menu item title to show or hide toolbar"), (toolbarCollapsed ? String(localized: "window-commands.view.action.show", defaultValue: "Show", comment: "Verb used in view menu toggle labels") : String(localized: "window-commands.view.action.hide", defaultValue: "Hide", comment: "Verb used in view menu toggle labels")))) {
                windowController?.toggleToolbar()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("t", modifiers: [.option, .command])

            Button(String(format: String(localized: "window-commands.view.toggle-interface", defaultValue: "%@ Interface", comment: "Menu item title to show or hide editor interface"), (isInterfaceHidden ? String(localized: "window-commands.view.action.show", defaultValue: "Show", comment: "Verb used in view menu toggle labels") : String(localized: "window-commands.view.action.hide", defaultValue: "Hide", comment: "Verb used in view menu toggle labels")))) {
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
            Menu(String(localized: "window-commands.view.navigators.menu-title", defaultValue: "Navigators", comment: "Title of the Navigators submenu in the View menu"), content: {
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
