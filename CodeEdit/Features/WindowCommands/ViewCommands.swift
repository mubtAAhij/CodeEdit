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
            Button(String(localized: "window-commands.view.show-command-palette", defaultValue: "Show Command Palette", comment: "Menu item title to show the command palette")) {
                NSApp.sendAction(#selector(CodeEditWindowController.openCommandPalette(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("p", modifiers: [.shift, .command])

            Button(String(localized: "window-commands.view.open-search-navigator", defaultValue: "Open Search Navigator", comment: "Menu item title to open search navigator")) {
                NSApp.sendAction(#selector(CodeEditWindowController.openSearchNavigator(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("f", modifiers: [.shift, .command])

            Menu(String(localized: "window-commands.view.font-size", defaultValue: "Font Size", comment: "Submenu title for editor font size controls")) {
                Button(String(localized: "window-commands.view.font-size.increase", defaultValue: "Increase", comment: "Menu action to increase font size")) {
                    if editorFontSize < 288 {
                        editorFontSize += 1
                    }
                    if terminalFontSize < 288 {
                        terminalFontSize += 1
                    }
                }
                .keyboardShortcut("+")

                Button(String(localized: "window-commands.view.font-size.decrease", defaultValue: "Decrease", comment: "Menu action to decrease font size")) {
                    if editorFontSize > 1 {
                        editorFontSize -= 1
                    }
                    if terminalFontSize > 1 {
                        terminalFontSize -= 1
                    }
                }
                .keyboardShortcut("-")

                Divider()

                Button(String(localized: "window-commands.view.font-size.reset", defaultValue: "Reset", comment: "Menu action to reset font size")) {
                    editorFontSize = 12
                    terminalFontSize = 12
                }
                .keyboardShortcut("0", modifiers: [.command, .control])
            }
            .disabled(windowController == nil)

            Button(String(localized: "window-commands.view.customize-toolbar", defaultValue: "Customize Toolbar...", comment: "Menu action to customize window toolbar")) {

            }
            .disabled(true)

            Divider()

            HideCommands()

            Divider()

            Button(String(format: String(localized: "window-commands.view.jump-bar.toggle", defaultValue: "%@ Jump Bar", comment: "Menu item title to show or hide editor jump bar"), (showEditorJumpBar
                ? String(localized: "window-commands.view.state.hide-window-commands-view-jump-ba", defaultValue: String(localized: "window-commands.view.jump-bar.hide", defaultValue: "Hide", comment: "Verb used for hide state in jump bar toggle menu item"), comment: "Verb used to hide interface elements in View menu")
                : String(localized: "window-commands.view.state.show-window-commands-view-jump-ba", defaultValue: String(localized: "window-commands.view.jump-bar.show", defaultValue: "Show", comment: "Verb used for show state in jump bar toggle menu item"), comment: "Verb used to show interface elements in View menu")))) {
                showEditorJumpBar.toggle()
            }

            Toggle(String(localized: "window-commands.view.dim-editors-without-focus", defaultValue: "Dim editors without focus", comment: "Toggle menu item to dim unfocused editors"), isOn: $dimEditorsWithoutFocus)

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
            Button(String(format: String(localized: "window-commands.view.navigator.toggle", defaultValue: "%@ Navigator", comment: "Menu item title to show or hide navigator pane"), (navigatorCollapsed
                ? String(localized: "window-commands.view.state.show-window-commands-view-navigat", defaultValue: String(localized: "window-commands.view.navigator.show", defaultValue: "Show", comment: "Verb used for show state in navigator toggle menu item"), comment: "Verb used to show interface elements in View menu")
                : String(localized: "window-commands.view.state.hide-window-commands-view-navigat", defaultValue: String(localized: "window-commands.view.navigator.hide", defaultValue: "Hide", comment: "Verb used for hide state in navigator toggle menu item"), comment: "Verb used to hide interface elements in View menu")))) {
                windowController?.toggleFirstPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("0", modifiers: [.command])

            Button(String(format: String(localized: "window-commands.view.inspector.toggle", defaultValue: "%@ Inspector", comment: "Menu item title to show or hide inspector pane"), (inspectorCollapsed
                ? String(localized: "window-commands.view.state.show", defaultValue: String(localized: "window-commands.view.inspector.show", defaultValue: "Show", comment: "Verb used for show state in inspector toggle menu item"), comment: "Verb used to show interface elements in View menu")
                : String(localized: "window-commands.view.state.hide", defaultValue: String(localized: "window-commands.view.inspector.hide", defaultValue: "Hide", comment: "Verb used for hide state in inspector toggle menu item"), comment: "Verb used to hide interface elements in View menu")))) {
                windowController?.toggleLastPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("i", modifiers: [.control, .command])

            Button(String(format: String(localized: "window-commands.view.utility-area.toggle", defaultValue: "%@ Utility Area", comment: "Menu item title to show or hide utility area pane"), (utilityAreaCollapsed
                ? String(localized: "window-commands.view.state.show-window-commands-view-utility", defaultValue: String(localized: "window-commands.view.utility-area.show", defaultValue: "Show", comment: "Verb used for show state in utility area toggle menu item"), comment: "Verb used to show interface elements in View menu")
                : String(localized: "window-commands.view.state.hide-window-commands-view-utility", defaultValue: String(localized: "window-commands.view.utility-area.hide", defaultValue: "Hide", comment: "Verb used for hide state in utility area toggle menu item"), comment: "Verb used to hide interface elements in View menu")))) {
                CommandManager.shared.executeCommand("open.drawer")
            }
            .disabled(windowController == nil)
            .keyboardShortcut("y", modifiers: [.shift, .command])

            Button(String(format: String(localized: "window-commands.view.toolbar.toggle", defaultValue: "%@ Toolbar", comment: "Menu item title to show or hide toolbar"), (toolbarCollapsed
                ? String(localized: "window-commands.view.state.show-window-commands-view-toolbar", defaultValue: String(localized: "window-commands.view.toolbar.show", defaultValue: "Show", comment: "Verb used for show state in toolbar toggle menu item"), comment: "Verb used to show interface elements in View menu")
                : String(localized: "window-commands.view.state.hide-window-commands-view-toolbar", defaultValue: String(localized: "window-commands.view.toolbar.hide", defaultValue: "Hide", comment: "Verb used for hide state in toolbar toggle menu item"), comment: "Verb used to hide interface elements in View menu")))) {
                windowController?.toggleToolbar()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("t", modifiers: [.option, .command])

            Button(String(format: String(localized: "window-commands.view.interface.toggle", defaultValue: "%@ Interface", comment: "Menu item title to show or hide interface"), (isInterfaceHidden
                ? String(localized: "window-commands.view.state.show-window-commands-view-interfa", defaultValue: String(localized: "window-commands.view.interface.show", defaultValue: "Show", comment: "Verb used for show state in interface toggle menu item"), comment: "Verb used to show interface elements in View menu")
                : String(localized: "window-commands.view.state.hide-window-commands-view-interfa", defaultValue: String(localized: "window-commands.view.interface.hide", defaultValue: "Hide", comment: "Verb used for hide state in interface toggle menu item"), comment: "Verb used to hide interface elements in View menu")))) {
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
            Menu(String(localized: "window-commands.view.navigators", defaultValue: "Navigators", comment: "Menu grouping title for navigator-related commands"), content: {
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
