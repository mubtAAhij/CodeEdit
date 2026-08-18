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
                comment: "View menu command title for showing the command palette"
            )) {
                NSApp.sendAction(#selector(CodeEditWindowController.openCommandPalette(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("p", modifiers: [.shift, .command])

            Button(String(
                localized: "window-commands.view.open-search-navigator",
                defaultValue: "Open Search Navigator",
                comment: "View menu command title for opening the search navigator"
            )) {
                NSApp.sendAction(#selector(CodeEditWindowController.openSearchNavigator(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("f", modifiers: [.shift, .command])

            Menu(String(
                localized: "window-commands.view.font-size",
                defaultValue: "Font Size",
                comment: "View menu section title for editor font size actions"
            )) {
                Button(String(
                    localized: "window-commands.view.font-size.increase",
                    defaultValue: "Increase",
                    comment: "Menu item title to increase editor font size"
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
                    comment: "Menu item title to decrease editor font size"
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
                    comment: "Menu item title to reset editor font size"
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
                comment: "View menu item title to open toolbar customization"
            )) {

            }
            .disabled(true)

            Divider()

            HideCommands()

            Divider()

            Button(String(format: String(
                localized: "window-commands.view.editor-jump-bar.toggle",
                defaultValue: "%@ Jump Bar",
                comment: "View menu item title for toggling editor jump bar visibility"
            ), (showEditorJumpBar ? String(
                localized: "window-commands.view.toggle.hide",
                defaultValue: String(
                    localized: "window-commands.view.visibility.hide",
                    defaultValue: "Hide",
                    comment: "Verb used for hidden state in visibility toggle menu items"
                ),
                comment: "Verb used in view menu toggle items when an element is currently visible"
            ) : String(
                localized: "window-commands.view.toggle.show",
                defaultValue: String(
                    localized: "window-commands.view.visibility.show",
                    defaultValue: "Show",
                    comment: "Verb used for shown state in visibility toggle menu items"
                ),
                comment: "Verb used in view menu toggle items when an element is currently hidden"
            )))) {
                showEditorJumpBar.toggle()
            }

            Toggle(String(
                localized: "window-commands.view.dim-editors-without-focus",
                defaultValue: "Dim editors without focus",
                comment: "View menu item title to dim unfocused editors"
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
            Button(String(format: String(
                localized: "window-commands.view.navigator.toggle",
                defaultValue: "%@ Navigator",
                comment: "View menu item title for toggling navigator visibility"
            ), (navigatorCollapsed ? String(
                localized: "window-commands.view.toggle.show",
                defaultValue: String(
                    localized: "window-commands.view.navigator.show",
                    defaultValue: "Show",
                    comment: "Verb for showing navigator in toggle menu item"
                ),
                comment: "Verb used in view menu toggle items when an element is currently hidden"
            ) : String(
                localized: "window-commands.view.toggle.hide",
                defaultValue: String(
                    localized: "window-commands.view.navigator.hide",
                    defaultValue: "Hide",
                    comment: "Verb for hiding navigator in toggle menu item"
                ),
                comment: "Verb used in view menu toggle items when an element is currently visible"
            )))) {
                windowController?.toggleFirstPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("0", modifiers: [.command])

            Button(String(format: String(
                localized: "window-commands.view.inspector.toggle",
                defaultValue: "%@ Inspector",
                comment: "View menu item title for toggling inspector visibility"
            ), (inspectorCollapsed ? String(
                localized: "window-commands.view.toggle.show",
                defaultValue: String(
                    localized: "window-commands.view.inspector.show",
                    defaultValue: "Show",
                    comment: "Verb for showing inspector in toggle menu item"
                ),
                comment: "Verb used in view menu toggle items when an element is currently hidden"
            ) : String(
                localized: "window-commands.view.toggle.hide",
                defaultValue: String(
                    localized: "window-commands.view.inspector.hide",
                    defaultValue: "Hide",
                    comment: "Verb for hiding inspector in toggle menu item"
                ),
                comment: "Verb used in view menu toggle items when an element is currently visible"
            )))) {
                windowController?.toggleLastPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("i", modifiers: [.control, .command])

            Button(String(format: String(
                localized: "window-commands.view.utility-area.toggle",
                defaultValue: "%@ Utility Area",
                comment: "View menu item title for toggling utility area visibility"
            ), (utilityAreaCollapsed ? String(
                localized: "window-commands.view.toggle.show",
                defaultValue: String(
                    localized: "window-commands.view.utility-area.show",
                    defaultValue: "Show",
                    comment: "Verb for showing utility area in toggle menu item"
                ),
                comment: "Verb used in view menu toggle items when an element is currently hidden"
            ) : String(
                localized: "window-commands.view.toggle.hide",
                defaultValue: String(
                    localized: "window-commands.view.utility-area.hide",
                    defaultValue: "Hide",
                    comment: "Verb for hiding utility area in toggle menu item"
                ),
                comment: "Verb used in view menu toggle items when an element is currently visible"
            )))) {
                CommandManager.shared.executeCommand("open.drawer")
            }
            .disabled(windowController == nil)
            .keyboardShortcut("y", modifiers: [.shift, .command])

            Button(String(format: String(
                localized: "window-commands.view.toolbar.toggle",
                defaultValue: "%@ Toolbar",
                comment: "View menu item title for toggling toolbar visibility"
            ), (toolbarCollapsed ? String(
                localized: "window-commands.view.toggle.show",
                defaultValue: String(
                    localized: "window-commands.view.toolbar.show",
                    defaultValue: "Show",
                    comment: "Verb for showing toolbar in toggle menu item"
                ),
                comment: "Verb used in view menu toggle items when an element is currently hidden"
            ) : String(
                localized: "window-commands.view.toggle.hide",
                defaultValue: String(
                    localized: "window-commands.view.toolbar.hide",
                    defaultValue: "Hide",
                    comment: "Verb for hiding toolbar in toggle menu item"
                ),
                comment: "Verb used in view menu toggle items when an element is currently visible"
            )))) {
                windowController?.toggleToolbar()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("t", modifiers: [.option, .command])

            Button(String(format: String(
                localized: "window-commands.view.interface.toggle",
                defaultValue: "%@ Interface",
                comment: "View menu item title for toggling full interface visibility"
            ), (isInterfaceHidden ? String(
                localized: "window-commands.view.toggle.show",
                defaultValue: String(
                    localized: "window-commands.view.interface.show",
                    defaultValue: "Show",
                    comment: "Verb for showing interface in toggle menu item"
                ),
                comment: "Verb used in view menu toggle items when an element is currently hidden"
            ) : String(
                localized: "window-commands.view.toggle.hide",
                defaultValue: String(
                    localized: "window-commands.view.interface.hide",
                    defaultValue: "Hide",
                    comment: "Verb for hiding interface in toggle menu item"
                ),
                comment: "Verb used in view menu toggle items when an element is currently visible"
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
                comment: "View menu section title for navigator-related commands"
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
