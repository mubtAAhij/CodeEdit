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
            Button(String(
                localized: "view.command-palette.show",
                defaultValue: "Show Command Palette",
                comment: "View menu command to open command palette"
            )) {
                NSApp.sendAction(#selector(CodeEditWindowController.openCommandPalette(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("p", modifiers: [.shift, .command])

            Button(String(
                localized: "view.search-navigator.open",
                defaultValue: "Open Search Navigator",
                comment: "View menu command to open search navigator"
            )) {
                NSApp.sendAction(#selector(CodeEditWindowController.openSearchNavigator(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("f", modifiers: [.shift, .command])

            Menu(String(
                localized: "view.font-size.menu",
                defaultValue: "Font Size",
                comment: "View menu title for font size commands"
            )) {
                Button(String(
                    localized: "view.font-size.increase",
                    defaultValue: "Increase",
                    comment: "View menu command to increase editor and terminal font size"
                )) {
                    if editorFontSize < 288 {
                        editorFontSize += 1
                    }
                    if terminalFontSize < 288 {
                        terminalFontSize += 1
                    }
                }
                .keyboardShortcut("+")

                Button(String(
                    localized: "view.font-size.decrease",
                    defaultValue: "Decrease",
                    comment: "View menu command to decrease editor and terminal font size"
                )) {
                    if editorFontSize > 1 {
                        editorFontSize -= 1
                    }
                    if terminalFontSize > 1 {
                        terminalFontSize -= 1
                    }
                }
                .keyboardShortcut("-")

                Divider()

                Button(String(
                    localized: "view.font-size.reset",
                    defaultValue: "Reset",
                    comment: "View menu command to reset editor and terminal font size"
                )) {
                    editorFontSize = 12
                    terminalFontSize = 12
                }
                .keyboardShortcut("0", modifiers: [.command, .control])
            }
            .disabled(windowController == nil)

            Button(String(
                localized: "view.toolbar.customize",
                defaultValue: "Customize Toolbar...",
                comment: "View menu command to customize toolbar"
            )) {

            }
            .disabled(true)

            Divider()

            HideCommands()

            Divider()

            Button(showEditorJumpBar
                ? String(
                    localized: "view.jump-bar.hide",
                    defaultValue: "Hide Jump Bar",
                    comment: "View menu command to hide jump bar"
                )
                : String(
                    localized: "settings.general.show-jump-bar",
                    defaultValue: "Show Jump Bar",
                    comment: "View menu command to show jump bar"
                )) {
                showEditorJumpBar.toggle()
            }

            Toggle(String(
                localized: "view.editors.dim-without-focus",
                defaultValue: "Dim editors without focus",
                comment: "View menu toggle to dim unfocused editors"
            ), isOn: $dimEditorsWithoutFocus)

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
            Button(navigatorCollapsed
                ? String(
                    localized: "view.navigator.show",
                    defaultValue: "Show Navigator",
                    comment: "View menu command to show navigator"
                )
                : String(
                    localized: "view.navigator.hide",
                    defaultValue: "Hide Navigator",
                    comment: "View menu command to hide navigator"
                )) {
                windowController?.toggleFirstPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("0", modifiers: [.command])

            Button(inspectorCollapsed
                ? String(
                    localized: "view.inspector.show",
                    defaultValue: "Show Inspector",
                    comment: "View menu command to show inspector"
                )
                : String(
                    localized: "view.inspector.hide",
                    defaultValue: "Hide Inspector",
                    comment: "View menu command to hide inspector"
                )) {
                windowController?.toggleLastPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("i", modifiers: [.control, .command])

            Button(utilityAreaCollapsed
                ? String(
                    localized: "view.utility-area.show",
                    defaultValue: "Show Utility Area",
                    comment: "View menu command to show utility area"
                )
                : String(
                    localized: "view.utility-area.hide",
                    defaultValue: "Hide Utility Area",
                    comment: "View menu command to hide utility area"
                )) {
                CommandManager.shared.executeCommand("open.drawer")
            }
            .disabled(windowController == nil)
            .keyboardShortcut("y", modifiers: [.shift, .command])

            Button(toolbarCollapsed
                ? String(
                    localized: "view.toolbar.show",
                    defaultValue: "Show Toolbar",
                    comment: "View menu command to show toolbar"
                )
                : String(
                    localized: "view.toolbar.hide",
                    defaultValue: "Hide Toolbar",
                    comment: "View menu command to hide toolbar"
                )) {
                windowController?.toggleToolbar()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("t", modifiers: [.option, .command])

            Button(isInterfaceHidden
                ? String(
                    localized: "view.interface.show",
                    defaultValue: "Show Interface",
                    comment: "View menu command to show interface"
                )
                : String(
                    localized: "view.interface.hide",
                    defaultValue: "Hide Interface",
                    comment: "View menu command to hide interface"
                )) {
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
            Menu(String(
                localized: "view.navigators.menu",
                defaultValue: "Navigators",
                comment: "View menu title for navigators submenu"
            ), content: {
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
