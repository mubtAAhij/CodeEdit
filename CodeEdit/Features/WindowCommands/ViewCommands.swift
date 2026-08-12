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
            Button(String(localized: "windowcommands.view.show-command-palette", defaultValue: "Show Command Palette", comment: "Menu item title to show the command palette")) {
                NSApp.sendAction(#selector(CodeEditWindowController.openCommandPalette(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("p", modifiers: [.shift, .command])

            Button(String(localized: "windowcommands.view.open-search-navigator", defaultValue: "Open Search Navigator", comment: "Menu item title to open the search navigator")) {
                NSApp.sendAction(#selector(CodeEditWindowController.openSearchNavigator(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("f", modifiers: [.shift, .command])

            Menu(String(localized: "windowcommands.view.font-size", defaultValue: "Font Size", comment: "Submenu title for font size commands")) {
                Button(String(localized: "windowcommands.view.font-size.increase", defaultValue: "Increase", comment: "Menu item title to increase editor font size")) {
                    if editorFontSize < 288 {
                        editorFontSize += 1
                    }
                    if terminalFontSize < 288 {
                        terminalFontSize += 1
                    }
                }
                .keyboardShortcut("+")

                Button(String(localized: "windowcommands.view.font-size.decrease", defaultValue: "Decrease", comment: "Menu item title to decrease editor font size")) {
                    if editorFontSize > 1 {
                        editorFontSize -= 1
                    }
                    if terminalFontSize > 1 {
                        terminalFontSize -= 1
                    }
                }
                .keyboardShortcut("-")

                Divider()

                Button(String(localized: "windowcommands.view.font-size.reset", defaultValue: "Reset", comment: "Menu item title to reset editor font size")) {
                    editorFontSize = 12
                    terminalFontSize = 12
                }
                .keyboardShortcut("0", modifiers: [.command, .control])
            }
            .disabled(windowController == nil)

            Button(String(localized: "windowcommands.view.customize-toolbar", defaultValue: "Customize Toolbar...", comment: "Menu item title to open toolbar customization")) {}
                .disabled(true)

            Divider()

            HideCommands()

            Divider()

            Button(String(format: String(localized: "windowcommands.view.jump-bar.visibility-toggle", defaultValue: "%@ Jump Bar", comment: "Menu item title to show or hide the editor jump bar"), showEditorJumpBar ? String(localized: "windowcommands.view.jump-bar.hide", defaultValue: "Hide", comment: "Verb for hiding the jump bar") : String(localized: "windowcommands.view.jump-bar.show", defaultValue: "Show", comment: "Verb for showing the jump bar"))) {
                showEditorJumpBar.toggle()
            }

            Toggle(String(localized: "windowcommands.view.dim-editors-without-focus", defaultValue: "Dim editors without focus", comment: "Menu item title to dim unfocused editors"), isOn: $dimEditorsWithoutFocus)

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
            Button(String(format: String(localized: "windowcommands.view.navigator.visibility-toggle", defaultValue: "%@ Navigator", comment: "Menu item title to show or hide the navigator"), navigatorCollapsed ? String(localized: "windowcommands.view.navigator.show", defaultValue: "Show", comment: "Verb for showing the navigator") : String(localized: "windowcommands.view.navigator.hide", defaultValue: "Hide", comment: "Verb for hiding the navigator"))) {
                windowController?.toggleFirstPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("0", modifiers: [.command])

            Button(String(format: String(localized: "windowcommands.view.inspector.visibility-toggle", defaultValue: "%@ Inspector", comment: "Menu item title to show or hide the inspector"), inspectorCollapsed ? String(localized: "windowcommands.view.inspector.show", defaultValue: "Show", comment: "Verb for showing the inspector") : String(localized: "windowcommands.view.inspector.hide", defaultValue: "Hide", comment: "Verb for hiding the inspector"))) {
                windowController?.toggleLastPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("i", modifiers: [.control, .command])

            Button(String(format: String(localized: "windowcommands.view.utility-area.visibility-toggle", defaultValue: "%@ Utility Area", comment: "Menu item title to show or hide the utility area"), utilityAreaCollapsed ? String(localized: "windowcommands.view.utility-area.show", defaultValue: "Show", comment: "Verb for showing the utility area") : String(localized: "windowcommands.view.utility-area.hide", defaultValue: "Hide", comment: "Verb for hiding the utility area"))) {
                CommandManager.shared.executeCommand("open.drawer")
            }
            .disabled(windowController == nil)
            .keyboardShortcut("y", modifiers: [.shift, .command])

            Button(String(format: String(localized: "windowcommands.view.toolbar.visibility-toggle", defaultValue: "%@ Toolbar", comment: "View menu item title to show or hide the toolbar based on current state"), toolbarCollapsed ? String(localized: "windowcommands.view.toolbar.show", defaultValue: "Show", comment: "Verb for showing the toolbar in the view menu") : String(localized: "windowcommands.view.toolbar.hide", defaultValue: "Hide", comment: "Verb for hiding the toolbar in the view menu"))) {
                windowController?.toggleToolbar()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("t", modifiers: [.option, .command])

            Button(String(format: String(localized: "windowcommands.view.interface.visibility-toggle", defaultValue: "%@ Interface", comment: "View menu item title to show or hide the interface based on current state"), isInterfaceHidden ? String(localized: "windowcommands.view.interface.show", defaultValue: "Show", comment: "Verb for showing the interface in the view menu") : String(localized: "windowcommands.view.interface.hide", defaultValue: "Hide", comment: "Verb for hiding the interface in the view menu"))) {
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
            Menu(String(localized: "windowcommands.view.navigators.title", defaultValue: "Navigators", comment: "Title of the navigators submenu in the view menu"), content: {
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
