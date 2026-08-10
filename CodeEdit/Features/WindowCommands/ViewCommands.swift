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
            Button(String(localized: "window.commands.view.show-command-palette", defaultValue: "Show Command Palette", comment: "Menu command title to show the command palette")) {
                NSApp.sendAction(#selector(CodeEditWindowController.openCommandPalette(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("p", modifiers: [.shift, .command])

            Button(String(localized: "window.commands.view.open-search-navigator", defaultValue: "Open Search Navigator", comment: "Menu command title to open the search navigator")) {
                NSApp.sendAction(#selector(CodeEditWindowController.openSearchNavigator(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("f", modifiers: [.shift, .command])

            Menu(String(localized: "window.commands.view.font-size", defaultValue: "Font Size", comment: "Submenu title for font size commands")) {
                Button(String(localized: "window.commands.view.font-size.increase", defaultValue: "Increase", comment: "Menu command title to increase editor font size")) {
                    if editorFontSize < 288 {
                        editorFontSize += 1
                    }
                    if terminalFontSize < 288 {
                        terminalFontSize += 1
                    }
                }
                .keyboardShortcut("+")

                Button(String(localized: "window.commands.view.font-size.decrease", defaultValue: "Decrease", comment: "Menu command title to decrease editor font size")) {
                    if editorFontSize > 1 {
                        editorFontSize -= 1
                    }
                    if terminalFontSize > 1 {
                        terminalFontSize -= 1
                    }
                }
                .keyboardShortcut("-")

                Divider()

                Button(String(localized: "window.commands.view.font-size.reset", defaultValue: "Reset", comment: "Menu command title to reset editor font size")) {
                    editorFontSize = 12
                    terminalFontSize = 12
                }
                .keyboardShortcut("0", modifiers: [.command, .control])
            }
            .disabled(windowController == nil)

            Button(String(localized: "window.commands.view.customize-toolbar", defaultValue: "Customize Toolbar...", comment: "Menu command title to customize the window toolbar")) {

            }
            .disabled(true)

            Divider()

            HideCommands()

            Divider()

            Button("\(showEditorJumpBar ? String(localized: "window.commands.view.jump-bar.hide", defaultValue: "Hide", comment: "Verb used when jump bar is currently visible and can be hidden") : String(localized: "window.commands.view.jump-bar.show", defaultValue: "Show", comment: "Verb used when jump bar is currently hidden and can be shown")) Jump Bar") {
                showEditorJumpBar.toggle()
            }

            Toggle(String(localized: "window.commands.view.dim-editors-without-focus", defaultValue: "Dim editors without focus", comment: "Menu command title to dim inactive editors"), isOn: $dimEditorsWithoutFocus)

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
            Button("\(navigatorCollapsed ? String(localized: "window.commands.view.navigator.show", defaultValue: "Show", comment: "Verb used when navigator is hidden and can be shown") : String(localized: "window.commands.view.navigator.hide", defaultValue: "Hide", comment: "Verb used when navigator is visible and can be hidden")) Navigator") {
                windowController?.toggleFirstPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("0", modifiers: [.command])

            Button("\(inspectorCollapsed ? String(localized: "window.commands.view.inspector.show", defaultValue: "Show", comment: "Verb used when inspector is hidden and can be shown") : String(localized: "window.commands.view.inspector.hide", defaultValue: "Hide", comment: "Verb used when inspector is visible and can be hidden")) Inspector") {
                windowController?.toggleLastPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("i", modifiers: [.control, .command])

            Button("\(utilityAreaCollapsed ? String(localized: "window.commands.view.utility-area.show", defaultValue: "Show", comment: "Verb used when utility area is hidden and can be shown") : String(localized: "window.commands.view.utility-area.hide", defaultValue: "Hide", comment: "Verb used when utility area is visible and can be hidden")) Utility Area") {
                CommandManager.shared.executeCommand("open.drawer")
            }
            .disabled(windowController == nil)
            .keyboardShortcut("y", modifiers: [.shift, .command])

            Button("\(toolbarCollapsed ? String(localized: "window.commands.view.toolbar.show", defaultValue: "Show", comment: "Verb used when toolbar is hidden and can be shown") : String(localized: "window.commands.view.toolbar.hide", defaultValue: "Hide", comment: "Verb used when toolbar is visible and can be hidden")) Toolbar") {
                windowController?.toggleToolbar()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("t", modifiers: [.option, .command])

            Button("\(isInterfaceHidden ? String(localized: "window.commands.view.interface.show", defaultValue: "Show", comment: "Verb used when interface is hidden and can be shown") : String(localized: "window.commands.view.interface.hide", defaultValue: "Hide", comment: "Verb used when interface is visible and can be hidden")) Interface") {
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
            Menu(String(localized: "window.commands.view.navigators", defaultValue: "Navigators", comment: "Submenu title for navigator visibility commands"), content: {
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
