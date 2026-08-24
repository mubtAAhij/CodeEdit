//
//  ViewCommands.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 13/03/2023.
//

import Combine
import SwiftUI

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
            Button(String(localized: "window.view.show-command-palette", defaultValue: "Show Command Palette", comment: "Command title to show the command palette")) {
                NSApp.sendAction(#selector(CodeEditWindowController.openCommandPalette(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("p", modifiers: [.shift, .command])

            Button(String(localized: "window.view.open-search-navigator", defaultValue: "Open Search Navigator", comment: "Command title to open the search navigator")) {
                NSApp.sendAction(#selector(CodeEditWindowController.openSearchNavigator(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("f", modifiers: [.shift, .command])

            Menu(String(localized: "window.view.font-size", defaultValue: "Font Size", comment: "Submenu title for font size commands")) {
                Button(String(localized: "window.view.font-size.increase", defaultValue: "Increase", comment: "Command title to increase editor font size")) {
                    if editorFontSize < 288 {
                        editorFontSize += 1
                    }
                    if terminalFontSize < 288 {
                        terminalFontSize += 1
                    }
                }
                .keyboardShortcut("+")

                Button(String(localized: "window.view.font-size.decrease", defaultValue: "Decrease", comment: "Command title to decrease editor font size")) {
                    if editorFontSize > 1 {
                        editorFontSize -= 1
                    }
                    if terminalFontSize > 1 {
                        terminalFontSize -= 1
                    }
                }
                .keyboardShortcut("-")

                Divider()

                Button(String(localized: "window.view.font-size.reset", defaultValue: "Reset", comment: "Command title to reset editor font size")) {
                    editorFontSize = 12
                    terminalFontSize = 12
                }
                .keyboardShortcut("0", modifiers: [.command, .control])
            }
            .disabled(windowController == nil)

            Button(String(localized: "window.view.customize-toolbar", defaultValue: "Customize Toolbar...", comment: "Command title to open toolbar customization")) {}
                .disabled(true)

            Divider()

            HideCommands()

            Divider()

            Button("\(showEditorJumpBar ? String(localized: "window.view.hide", defaultValue: "Hide", comment: "Verb used in view toggle commands when currently visible") : String(localized: "window.view.show", defaultValue: "Show", comment: "Verb used in view toggle commands when currently hidden")) Jump Bar") {
                showEditorJumpBar.toggle()
            }

            Toggle(String(localized: "window.view.dim-editors-without-focus", defaultValue: "Dim editors without focus", comment: "Menu item title to toggle dimming unfocused editors"), isOn: $dimEditorsWithoutFocus)

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
            windowController?.isInterfaceStillHidden() ?? false
        }

        var body: some View {
            Button("\(navigatorCollapsed ? String(localized: "window.view.show", defaultValue: "Show", comment: "Verb for showing hidden UI sections") : String(localized: "window.view.hide", defaultValue: "Hide", comment: "Verb for hiding visible UI sections")) Navigator") {
                windowController?.toggleFirstPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("0", modifiers: [.command])

            Button("\(inspectorCollapsed ? String(localized: "window.view.show", defaultValue: "Show", comment: "Verb for showing hidden UI sections") : String(localized: "window.view.hide", defaultValue: "Hide", comment: "Verb for hiding visible UI sections")) Inspector") {
                windowController?.toggleLastPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("i", modifiers: [.control, .command])

            Button("\(utilityAreaCollapsed ? String(localized: "window.view.show", defaultValue: "Show", comment: "Verb for showing hidden UI sections") : String(localized: "window.view.hide", defaultValue: "Hide", comment: "Verb for hiding visible UI sections")) Utility Area") {
                CommandManager.shared.executeCommand("open.drawer")
            }
            .disabled(windowController == nil)
            .keyboardShortcut("y", modifiers: [.shift, .command])

            Button("\(toolbarCollapsed ? String(localized: "window.view.show", defaultValue: "Show", comment: "Verb for showing hidden UI sections") : String(localized: "window.view.hide", defaultValue: "Hide", comment: "Verb for hiding visible UI sections")) Toolbar") {
                windowController?.toggleToolbar()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("t", modifiers: [.option, .command])

            Button("\(isInterfaceHidden ? String(localized: "window.view.show", defaultValue: "Show", comment: "Verb for showing hidden UI sections") : String(localized: "window.view.hide", defaultValue: "Hide", comment: "Verb for hiding visible UI sections")) Interface") {
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
            Menu(String(localized: "window.view.navigators", defaultValue: "Navigators", comment: "Submenu title for navigator visibility commands"), content: {
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
