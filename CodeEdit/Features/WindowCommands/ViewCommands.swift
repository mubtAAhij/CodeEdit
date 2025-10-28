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
            Button("view.show_command_palette", comment: "Show command palette menu item") {
                NSApp.sendAction(#selector(CodeEditWindowController.openCommandPalette(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("p", modifiers: [.shift, .command])

            Button("view.open_search_navigator", comment: "Open search navigator menu item") {
                NSApp.sendAction(#selector(CodeEditWindowController.openSearchNavigator(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("f", modifiers: [.shift, .command])

            Menu("view.font_size", comment: "Font size menu") {
                Button("view.increase", comment: "Increase font size") {
                    if editorFontSize < 288 {
                        editorFontSize += 1
                    }
                    if terminalFontSize < 288 {
                        terminalFontSize += 1
                    }
                }
                .keyboardShortcut("+")

                Button("view.decrease", comment: "Decrease font size") {
                    if editorFontSize > 1 {
                        editorFontSize -= 1
                    }
                    if terminalFontSize > 1 {
                        terminalFontSize -= 1
                    }
                }
                .keyboardShortcut("-")

                Divider()

                Button("view.reset", comment: "Reset font size") {
                    editorFontSize = 12
                    terminalFontSize = 12
                }
                .keyboardShortcut("0", modifiers: [.command, .control])
            }
            .disabled(windowController == nil)

            Button("view.customize_toolbar", comment: "Customize toolbar menu item") {

            }
            .disabled(true)

            Divider()

            HideCommands()

            Divider()

            Button("view.jump_bar \(showEditorJumpBar ? "Hide" : "Show")", comment: "Toggle jump bar visibility") {
                showEditorJumpBar.toggle()
            }

            Toggle("view.dim_editors", comment: "Dim editors without focus toggle", isOn: $dimEditorsWithoutFocus)

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
            Button("view.navigator \(navigatorCollapsed ? "Show" : "Hide")", comment: "Toggle navigator visibility") {
                windowController?.toggleFirstPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("0", modifiers: [.command])

            Button("view.inspector \(inspectorCollapsed ? "Show" : "Hide")", comment: "Toggle inspector visibility") {
                windowController?.toggleLastPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("i", modifiers: [.control, .command])

            Button("view.utility_area \(utilityAreaCollapsed ? "Show" : "Hide")", comment: "Toggle utility area visibility") {
                CommandManager.shared.executeCommand("open.drawer")
            }
            .disabled(windowController == nil)
            .keyboardShortcut("y", modifiers: [.shift, .command])

            Button("view.toolbar \(toolbarCollapsed ? \"Show\" : \"Hide\")", comment: "Toggle toolbar visibility") {
                windowController?.toggleToolbar()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("t", modifiers: [.option, .command])

            Button("view.interface \(isInterfaceHidden ? \"Show\" : \"Hide\")", comment: "Toggle interface visibility") {
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
            Menu("view.navigators", comment: "Navigators menu", content: {
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
