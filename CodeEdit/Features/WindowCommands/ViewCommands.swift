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
                localized: "window-commands.view.show-command-palette",
                defaultValue: "Show Command Palette",
                comment: "View menu command to open the command palette"
            )) {
                NSApp.sendAction(#selector(CodeEditWindowController.openCommandPalette(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("p", modifiers: [.shift, .command])

            Button(String(
                localized: "window-commands.view.open-search-navigator",
                defaultValue: "Open Search Navigator",
                comment: "View menu command to open the search navigator"
            )) {
                NSApp.sendAction(#selector(CodeEditWindowController.openSearchNavigator(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("f", modifiers: [.shift, .command])

            Menu(String(
                localized: "window-commands.view.font-size",
                defaultValue: "Font Size",
                comment: "View menu title for font size controls"
            )) {
                Button(String(
                    localized: "window-commands.view.font-size.increase",
                    defaultValue: "Increase",
                    comment: "View menu command to increase font size"
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
                    localized: "window-commands.view.font-size.decrease",
                    defaultValue: "Decrease",
                    comment: "View menu command to decrease font size"
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
                    localized: "window-commands.view.font-size.reset",
                    defaultValue: "Reset",
                    comment: "View menu command to reset font size"
                )) {
                    editorFontSize = 12
                    terminalFontSize = 12
                }
                .keyboardShortcut("0", modifiers: [.command, .control])
            }
            .disabled(windowController == nil)

            Button(String(
                localized: "window-commands.view.customize-toolbar",
                defaultValue: "Customize Toolbar...",
                comment: "View menu command to customize the toolbar"
            )) {

            }
            .disabled(true)

            Divider()

            HideCommands()

            Divider()

            Button(
                showEditorJumpBar
                    ? String(
                        localized: "window-commands.view.hide-jump-bar",
                        defaultValue: "Hide Jump Bar",
                        comment: "View menu command to hide the jump bar"
                    )
                    : String(
                        localized: "window-commands.view.show-jump-bar",
                        defaultValue: "Show Jump Bar",
                        comment: "View menu command to show the jump bar"
                    )
            ) {
                showEditorJumpBar.toggle()
            }

            Toggle(String(
                localized: "window-commands.view.dim-editors-without-focus",
                defaultValue: "Dim editors without focus",
                comment: "View menu toggle to dim editors that do not have focus"
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
            Button(
                navigatorCollapsed
                    ? String(
                        localized: "window-commands.view.show-navigator",
                        defaultValue: "Show Navigator",
                        comment: "View menu command to show the navigator panel"
                    )
                    : String(
                        localized: "window-commands.view.hide-navigator",
                        defaultValue: "Hide Navigator",
                        comment: "View menu command to hide the navigator panel"
                    )
            ) {
                windowController?.toggleFirstPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("0", modifiers: [.command])

            Button(
                inspectorCollapsed
                    ? String(
                        localized: "window-commands.view.show-inspector",
                        defaultValue: "Show Inspector",
                        comment: "View menu command to show the inspector panel"
                    )
                    : String(
                        localized: "window-commands.view.hide-inspector",
                        defaultValue: "Hide Inspector",
                        comment: "View menu command to hide the inspector panel"
                    )
            ) {
                windowController?.toggleLastPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("i", modifiers: [.control, .command])

            Button(
                utilityAreaCollapsed
                    ? String(
                        localized: "window-commands.view.show-utility-area",
                        defaultValue: "Show Utility Area",
                        comment: "View menu command to show the utility area"
                    )
                    : String(
                        localized: "window-commands.view.hide-utility-area",
                        defaultValue: "Hide Utility Area",
                        comment: "View menu command to hide the utility area"
                    )
            ) {
                CommandManager.shared.executeCommand("open.drawer")
            }
            .disabled(windowController == nil)
            .keyboardShortcut("y", modifiers: [.shift, .command])

            Button(String(format: String(
                localized: "window-commands.view.hide-toolbar",
                defaultValue: "Hide Toolbar",
                comment: "View menu command label to hide the toolbar"
            ), (toolbarCollapsed
                ? String(
                    localized: "window-commands.view.toolbar-visibility.show",
                    defaultValue: "Show",
                    comment: "Verb in View menu item to show toolbar"
                )
                : String(
                    localized: "window-commands.view.toolbar-visibility.hide",
                    defaultValue: "Hide",
                    comment: "Verb in View menu item to hide toolbar"
                )))) {
                windowController?.toggleToolbar()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("t", modifiers: [.option, .command])

            Button(String(format: String(
                localized: "window-commands.view.hide-interface",
                defaultValue: "Hide Interface",
                comment: "View menu command label to hide the interface"
            ), (isInterfaceHidden
                ? String(
                    localized: "window-commands.view.interface-visibility.show",
                    defaultValue: "Show",
                    comment: "Verb in View menu item to show interface"
                )
                : String(
                    localized: "window-commands.view.interface-visibility.hide",
                    defaultValue: "Hide",
                    comment: "Verb in View menu item to hide interface"
                )))) {
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
                localized: "window-commands.view.navigators",
                defaultValue: "Navigators",
                comment: "View menu title for the navigator picker commands"
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
