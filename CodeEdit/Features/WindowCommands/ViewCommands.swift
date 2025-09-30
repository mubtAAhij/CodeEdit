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
            Button(String(localized: "view.show_command_palette", comment: "Show command palette menu item")) {
                NSApp.sendAction(#selector(CodeEditWindowController.openCommandPalette(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("p", modifiers: [.shift, .command])

            Button(String(localized: "view.open_search_navigator", comment: "Open search navigator menu item")) {
                NSApp.sendAction(#selector(CodeEditWindowController.openSearchNavigator(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("f", modifiers: [.shift, .command])

            Menu(String(localized: "view.font_size", comment: "Font size menu label")) {
                Button(String(localized: "view.font_size.increase", comment: "Increase font size menu item")) {
                    if editorFontSize < 288 {
                        editorFontSize += 1
                    }
                    if terminalFontSize < 288 {
                        terminalFontSize += 1
                    }
                }
                .keyboardShortcut("+")

                Button(String(localized: "view.font_size.decrease", comment: "Decrease font size menu item")) {
                    if editorFontSize > 1 {
                        editorFontSize -= 1
                    }
                    if terminalFontSize > 1 {
                        terminalFontSize -= 1
                    }
                }
                .keyboardShortcut("-")

                Divider()

                Button(String(localized: "view.font_size.reset", comment: "Reset font size menu item")) {
                    editorFontSize = 12
                    terminalFontSize = 12
                }
                .keyboardShortcut("0", modifiers: [.command, .control])
            }
            .disabled(windowController == nil)

            Button(String(localized: "view.customize_toolbar", comment: "Customize toolbar menu item")) {

            }
            .disabled(true)

            Divider()

            HideCommands()

            Divider()

            Button(showEditorJumpBar ? String(localized: "view.hide_jump_bar", comment: "Hide jump bar menu item") : String(localized: "view.show_jump_bar", comment: "Show jump bar menu item")) {
                showEditorJumpBar.toggle()
            }

            Toggle(String(localized: "view.dim_editors_without_focus", comment: "Dim editors without focus menu item"), isOn: $dimEditorsWithoutFocus)

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
            Button(navigatorCollapsed ? String(localized: "view.show_navigator", comment: "Show navigator menu item") : String(localized: "view.hide_navigator", comment: "Hide navigator menu item")) {
                windowController?.toggleFirstPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("0", modifiers: [.command])

            Button("\(inspectorCollapsed ? "Show" : "Hide") Inspector") {
                windowController?.toggleLastPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("i", modifiers: [.control, .command])

            Button("\(utilityAreaCollapsed ? "Show" : "Hide") Utility Area") {
                CommandManager.shared.executeCommand("open.drawer")
            }
            .disabled(windowController == nil)
            .keyboardShortcut("y", modifiers: [.shift, .command])

            Button("\(toolbarCollapsed ? "Show" : "Hide") Toolbar") {
                windowController?.toggleToolbar()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("t", modifiers: [.option, .command])

            Button("\(isInterfaceHidden ? "Show" : "Hide") Interface") {
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
            Menu(String(localized: "view.navigators", comment: "Navigators menu title"), content: {
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
