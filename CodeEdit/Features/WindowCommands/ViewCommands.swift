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
                localized: "view-commands.show-command-palette",
                defaultValue: "Show Command Palette",
                comment: "Button to show command palette"
            )) {
                NSApp.sendAction(#selector(CodeEditWindowController.openCommandPalette(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("p", modifiers: [.shift, .command])

            Button(String(
                localized: "view-commands.open-search-navigator",
                defaultValue: "Open Search Navigator",
                comment: "Button to open search navigator"
            )) {
                NSApp.sendAction(#selector(CodeEditWindowController.openSearchNavigator(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("f", modifiers: [.shift, .command])

            Menu(String(
                localized: "view-commands.font-size",
                defaultValue: "Font Size",
                comment: "Menu for font size adjustments"
            )) {
                Button(String(
                    localized: "view-commands.font-size.increase",
                    defaultValue: "Increase",
                    comment: "Button to increase font size"
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
                    localized: "view-commands.font-size.decrease",
                    defaultValue: "Decrease",
                    comment: "Button to decrease font size"
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
                    localized: "view-commands.font-size.reset",
                    defaultValue: "Reset",
                    comment: "Button to reset font size to default"
                )) {
                    editorFontSize = 12
                    terminalFontSize = 12
                }
                .keyboardShortcut("0", modifiers: [.command, .control])
            }
            .disabled(windowController == nil)

            Button(String(
                localized: "view-commands.customize-toolbar",
                defaultValue: "Customize Toolbar...",
                comment: "Button to customize toolbar"
            )) {

            }
            .disabled(true)

            Divider()

            HideCommands()

            Divider()

            Button({
                let action = showEditorJumpBar ? String(
                    localized: "view-commands.jump-bar.hide",
                    defaultValue: "Hide",
                    comment: "Action to hide jump bar"
                ) : String(
                    localized: "view-commands.jump-bar.show",
                    defaultValue: "Show",
                    comment: "Action to show jump bar"
                )
                return String(
                    localized: "view-commands.jump-bar.toggle",
                    defaultValue: "\(action) Jump Bar",
                    comment: "Button to toggle jump bar visibility"
                )
            }()) {
                showEditorJumpBar.toggle()
            }

            Toggle(
                String(
                    localized: "view-commands.dim-editors-without-focus",
                    defaultValue: "Dim editors without focus",
                    comment: "Toggle to dim editors without focus"
                ),
                isOn: $dimEditorsWithoutFocus
            )

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
            Button({
                let action = navigatorCollapsed ? String(
                    localized: "view-commands.navigator.show",
                    defaultValue: "Show",
                    comment: "Action to show navigator"
                ) : String(
                    localized: "view-commands.navigator.hide",
                    defaultValue: "Hide",
                    comment: "Action to hide navigator"
                )
                return String(
                    localized: "view-commands.navigator.toggle",
                    defaultValue: "\(action) Navigator",
                    comment: "Button to toggle navigator visibility"
                )
            }()) {
                windowController?.toggleFirstPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("0", modifiers: [.command])

            Button({
                let action = inspectorCollapsed ? String(
                    localized: "view-commands.inspector.show",
                    defaultValue: "Show",
                    comment: "Action to show inspector"
                ) : String(
                    localized: "view-commands.inspector.hide",
                    defaultValue: "Hide",
                    comment: "Action to hide inspector"
                )
                return String(
                    localized: "view-commands.inspector.toggle",
                    defaultValue: "\(action) Inspector",
                    comment: "Button to toggle inspector visibility"
                )
            }()) {
                windowController?.toggleLastPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("i", modifiers: [.control, .command])

            Button({
                let action = utilityAreaCollapsed ? String(
                    localized: "view-commands.utility-area.show",
                    defaultValue: "Show",
                    comment: "Action to show utility area"
                ) : String(
                    localized: "view-commands.utility-area.hide",
                    defaultValue: "Hide",
                    comment: "Action to hide utility area"
                )
                return String(
                    localized: "view-commands.utility-area.toggle",
                    defaultValue: "\(action) Utility Area",
                    comment: "Button to toggle utility area visibility"
                )
            }()) {
                CommandManager.shared.executeCommand("open.drawer")
            }
            .disabled(windowController == nil)
            .keyboardShortcut("y", modifiers: [.shift, .command])

            Button({
                let action = toolbarCollapsed ? String(
                    localized: "view-commands.toolbar.show",
                    defaultValue: "Show",
                    comment: "Action to show toolbar"
                ) : String(
                    localized: "view-commands.toolbar.hide",
                    defaultValue: "Hide",
                    comment: "Action to hide toolbar"
                )
                return String(
                    localized: "view-commands.toolbar.toggle",
                    defaultValue: "\(action) Toolbar",
                    comment: "Button to toggle toolbar visibility"
                )
            }()) {
                windowController?.toggleToolbar()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("t", modifiers: [.option, .command])

            Button({
                let action = isInterfaceHidden ? String(
                    localized: "view-commands.interface.show",
                    defaultValue: "Show",
                    comment: "Action to show interface"
                ) : String(
                    localized: "view-commands.interface.hide",
                    defaultValue: "Hide",
                    comment: "Action to hide interface"
                )
                return String(
                    localized: "view-commands.interface.toggle",
                    defaultValue: "\(action) Interface",
                    comment: "Button to toggle interface visibility"
                )
            }()) {
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
                localized: "view-commands.navigators",
                defaultValue: "Navigators",
                comment: "Menu title for navigators"
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
