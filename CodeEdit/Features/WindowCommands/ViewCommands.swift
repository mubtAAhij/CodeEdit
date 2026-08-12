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

            Button(String(localized: "window-commands.view.open-search-navigator", defaultValue: "Open Search Navigator", comment: "Menu item title to open the search navigator")) {
                NSApp.sendAction(#selector(CodeEditWindowController.openSearchNavigator(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("f", modifiers: [.shift, .command])

            Menu(String(localized: "window-commands.view.font-size", defaultValue: "Font Size", comment: "Menu title for font size actions")) {
                Button(String(localized: "window-commands.view.font-size.increase", defaultValue: "Increase", comment: "Menu item title to increase font size")) {
                    if editorFontSize < 288 {
                        editorFontSize += 1
                    }
                    if terminalFontSize < 288 {
                        terminalFontSize += 1
                    }
                }
                .keyboardShortcut("+")

                Button(String(localized: "window-commands.view.font-size.decrease", defaultValue: "Decrease", comment: "Menu item title to decrease font size")) {
                    if editorFontSize > 1 {
                        editorFontSize -= 1
                    }
                    if terminalFontSize > 1 {
                        terminalFontSize -= 1
                    }
                }
                .keyboardShortcut("-")

                Divider()

                Button(String(localized: "window-commands.view.font-size.reset", defaultValue: "Reset", comment: "Menu item title to reset font size")) {
                    editorFontSize = 12
                    terminalFontSize = 12
                }
                .keyboardShortcut("0", modifiers: [.command, .control])
            }
            .disabled(windowController == nil)

            Button(String(localized: "window-commands.view.customize-toolbar", defaultValue: "Customize Toolbar...", comment: "Menu item title to customize the toolbar")) {

            }
            .disabled(true)

            Divider()

            HideCommands()

            Divider()

            Button(String(format: String(localized: "window-commands.view.editor-jump-bar.toggle", defaultValue: "%@ Jump Bar", comment: "Menu item title to show or hide the jump bar based on current state"), (showEditorJumpBar ? String(localized: "window-commands.view.editor-jump-bar.hide", defaultValue: "Hide", comment: "Verb in jump bar toggle action when jump bar is visible") : String(localized: "window-commands.view.editor-jump-bar.show", defaultValue: "Show", comment: "Verb in jump bar toggle action when jump bar is hidden")))) {
                showEditorJumpBar.toggle()
            }

            Toggle(String(localized: "window-commands.view.dim-editors-without-focus", defaultValue: "Dim editors without focus", comment: "Toggle action title for dimming unfocused editors"), isOn: $dimEditorsWithoutFocus)

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
            Button(String(format: String(localized: "window-commands.view.navigator.toggle", defaultValue: "%@ Navigator", comment: "Menu item title to show or hide the navigator based on current state"), (navigatorCollapsed ? String(localized: "window-commands.view.navigator.show", defaultValue: "Show", comment: "Verb in navigator toggle action when navigator is hidden") : String(localized: "window-commands.view.navigator.hide", defaultValue: "Hide", comment: "Verb in navigator toggle action when navigator is visible")))) {
                windowController?.toggleFirstPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("0", modifiers: [.command])

            Button(String(format: String(localized: "window-commands.view.inspector.toggle", defaultValue: "%@ Inspector", comment: "Menu item title to show or hide the inspector based on current state"), (inspectorCollapsed ? String(localized: "window-commands.view.inspector.show", defaultValue: "Show", comment: "Verb in inspector toggle action when inspector is hidden") : String(localized: "window-commands.view.inspector.hide", defaultValue: "Hide", comment: "Verb in inspector toggle action when inspector is visible")))) {
                windowController?.toggleLastPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("i", modifiers: [.control, .command])

            Button(String(format: String(localized: "window-commands.view.utility-area.toggle", defaultValue: "%@ Utility Area", comment: "Menu item title to show or hide the utility area based on current state"), (utilityAreaCollapsed ? String(localized: "window-commands.view.utility-area.show", defaultValue: "Show", comment: "Verb in utility area toggle action when utility area is hidden") : String(localized: "window-commands.view.utility-area.hide", defaultValue: "Hide", comment: "Verb in utility area toggle action when utility area is visible")))) {
                CommandManager.shared.executeCommand("open.drawer")
            }
            .disabled(windowController == nil)
            .keyboardShortcut("y", modifiers: [.shift, .command])

            Button(String(format: String(localized: "window-commands.view.toolbar.toggle", defaultValue: "%@ Toolbar", comment: "Menu item title to show or hide the toolbar based on current state"), (toolbarCollapsed ? String(localized: "window-commands.view.toolbar.show", defaultValue: "Show", comment: "Verb in toolbar toggle action when toolbar is hidden") : String(localized: "window-commands.view.toolbar.hide", defaultValue: "Hide", comment: "Verb in toolbar toggle action when toolbar is visible")))) {
                windowController?.toggleToolbar()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("t", modifiers: [.option, .command])

            Button(String(format: String(localized: "window-commands.view.interface.toggle", defaultValue: "%@ Interface", comment: "Menu item title to show or hide the interface based on current state"), (isInterfaceHidden ? String(localized: "window-commands.view.interface.show", defaultValue: "Show", comment: "Verb in interface toggle action when interface is hidden") : String(localized: "window-commands.view.interface.hide", defaultValue: "Hide", comment: "Verb in interface toggle action when interface is visible")))) {
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
            Menu(String(localized: "window-commands.view.navigators", defaultValue: "Navigators", comment: "Menu title for navigator visibility commands"), content: {
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
