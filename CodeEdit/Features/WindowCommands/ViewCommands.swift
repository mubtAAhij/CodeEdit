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

            Button(String(localized: "window-commands.view.open-search-navigator", defaultValue: "Open Search Navigator", comment: "Menu item title to open search navigator")) {
                NSApp.sendAction(#selector(CodeEditWindowController.openSearchNavigator(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("f", modifiers: [.shift, .command])

            Menu(String(localized: "window-commands.view.font-size.menu-title", defaultValue: "Font Size", comment: "Title for the font size submenu in View menu")) {
                Button(String(localized: "window-commands.view.font-size.increase", defaultValue: "Increase", comment: "Menu item to increase editor font size")) {
                    if editorFontSize < 288 {
                        editorFontSize += 1
                    }
                    if terminalFontSize < 288 {
                        terminalFontSize += 1
                    }
                }
                .keyboardShortcut("+")

                Button(String(localized: "window-commands.view.font-size.decrease", defaultValue: "Decrease", comment: "Menu item to decrease editor font size")) {
                    if editorFontSize > 1 {
                        editorFontSize -= 1
                    }
                    if terminalFontSize > 1 {
                        terminalFontSize -= 1
                    }
                }
                .keyboardShortcut("-")

                Divider()

                Button(String(localized: "window-commands.view.font-size.reset", defaultValue: "Reset", comment: "Menu item to reset editor font size")) {
                    editorFontSize = 12
                    terminalFontSize = 12
                }
                .keyboardShortcut("0", modifiers: [.command, .control])
            }
            .disabled(windowController == nil)

            Button(String(localized: "window-commands.view.customize-toolbar", defaultValue: "Customize Toolbar...", comment: "Menu item to customize window toolbar")) {

            }
            .disabled(true)

            Divider()

            HideCommands()

            Divider()

            Button(String(format: String(localized: "window-commands.view.jump-bar.visibility", defaultValue: "%@ Jump Bar", comment: "Menu item title to toggle jump bar visibility"), (showEditorJumpBar ? String(localized: "window-commands.view.visibility.hide", defaultValue: "Hide", comment: "Verb used in visibility toggle menu labels") : String(localized: "window-commands.view.visibility.show", defaultValue: "Show", comment: "Verb used in visibility toggle menu labels")))) {
                showEditorJumpBar.toggle()
            }

            Toggle(String(localized: "window-commands.view.dim-editors-without-focus", defaultValue: "Dim editors without focus", comment: "Menu item title to toggle dimming unfocused editors"), isOn: $dimEditorsWithoutFocus)

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
            Button(String(format: String(localized: "window-commands.view.navigator.visibility", defaultValue: "%@ Navigator", comment: "Menu item title to toggle navigator visibility"), (navigatorCollapsed ? String(localized: "window-commands.view.visibility.show", defaultValue: "Show", comment: "Verb used in visibility toggle menu labels") : String(localized: "window-commands.view.visibility.hide", defaultValue: "Hide", comment: "Verb used in visibility toggle menu labels")))) {
                windowController?.toggleFirstPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("0", modifiers: [.command])

            Button(String(format: String(localized: "window-commands.view.inspector.visibility", defaultValue: "%@ Inspector", comment: "Menu item title to toggle inspector visibility"), (inspectorCollapsed ? String(localized: "window-commands.view.visibility.show", defaultValue: "Show", comment: "Verb used in visibility toggle menu labels") : String(localized: "window-commands.view.visibility.hide", defaultValue: "Hide", comment: "Verb used in visibility toggle menu labels")))) {
                windowController?.toggleLastPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("i", modifiers: [.control, .command])

            Button(String(format: String(localized: "window-commands.view.utility-area.visibility", defaultValue: "%@ Utility Area", comment: "Menu item title to toggle utility area visibility"), (utilityAreaCollapsed ? String(localized: "window-commands.view.visibility.show", defaultValue: "Show", comment: "Verb used in visibility toggle menu labels") : String(localized: "window-commands.view.visibility.hide", defaultValue: "Hide", comment: "Verb used in visibility toggle menu labels")))) {
                CommandManager.shared.executeCommand("open.drawer")
            }
            .disabled(windowController == nil)
            .keyboardShortcut("y", modifiers: [.shift, .command])

            Button(String(format: String(localized: "window-commands.view.toolbar.visibility", defaultValue: "%@ Toolbar", comment: "Menu item title to toggle toolbar visibility"), (toolbarCollapsed ? String(localized: "window-commands.view.visibility.show", defaultValue: "Show", comment: "Verb used in visibility toggle menu labels") : String(localized: "window-commands.view.visibility.hide", defaultValue: "Hide", comment: "Verb used in visibility toggle menu labels")))) {
                windowController?.toggleToolbar()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("t", modifiers: [.option, .command])

            Button(String(format: String(localized: "window-commands.view.interface.visibility", defaultValue: "%@ Interface", comment: "Menu item title to toggle full interface visibility"), (isInterfaceHidden ? String(localized: "window-commands.view.visibility.show", defaultValue: "Show", comment: "Verb used in visibility toggle menu labels") : String(localized: "window-commands.view.visibility.hide", defaultValue: "Hide", comment: "Verb used in visibility toggle menu labels")))) {
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
            Menu(String(localized: "window-commands.view.navigators.menu-title", defaultValue: "Navigators", comment: "Title of the Navigators submenu in View menu"), content: {
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
