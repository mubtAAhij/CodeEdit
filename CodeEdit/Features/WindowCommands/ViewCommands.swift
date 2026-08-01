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
            Button(String(localized: "view-commands.show-command-palette", defaultValue: "Show Command Palette", comment: "Menu item to show command palette")) {
                NSApp.sendAction(#selector(CodeEditWindowController.openCommandPalette(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("p", modifiers: [.shift, .command])

            Button(String(localized: "view-commands.open-search-navigator", defaultValue: "Open Search Navigator", comment: "Menu item to open search navigator")) {
                NSApp.sendAction(#selector(CodeEditWindowController.openSearchNavigator(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("f", modifiers: [.shift, .command])

            Menu(String(localized: "view-commands.font-size-menu", defaultValue: "Font Size", comment: "Font size menu title")) {
                Button(String(localized: "view-commands.font-size-increase", defaultValue: "Increase", comment: "Increase font size menu item")) {
                    if editorFontSize < 288 {
                        editorFontSize += 1
                    }
                    if terminalFontSize < 288 {
                        terminalFontSize += 1
                    }
                }
                .keyboardShortcut("+")

                Button(String(localized: "view-commands.font-size-decrease", defaultValue: "Decrease", comment: "Decrease font size menu item")) {
                    if editorFontSize > 1 {
                        editorFontSize -= 1
                    }
                    if terminalFontSize > 1 {
                        terminalFontSize -= 1
                    }
                }
                .keyboardShortcut("-")

                Divider()

                Button(String(localized: "view-commands.font-size-reset", defaultValue: "Reset", comment: "Reset font size menu item")) {
                    editorFontSize = 12
                    terminalFontSize = 12
                }
                .keyboardShortcut("0", modifiers: [.command, .control])
            }
            .disabled(windowController == nil)

            Button(String(localized: "view-commands.customize-toolbar", defaultValue: "Customize Toolbar...", comment: "Customize toolbar menu item")) {

            }
            .disabled(true)

            Divider()

            HideCommands()

            Divider()

            Button(showEditorJumpBar ? String(localized: "view-commands.hide-jump-bar", defaultValue: "Hide Jump Bar", comment: "Menu item to hide jump bar") : String(localized: "view-commands.show-jump-bar", defaultValue: "Show Jump Bar", comment: "Menu item to show jump bar")) {
                showEditorJumpBar.toggle()
            }

            Toggle(String(localized: "view-commands.dim-editors-without-focus", defaultValue: "Dim editors without focus", comment: "Toggle to dim editors without focus"), isOn: $dimEditorsWithoutFocus)

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
            Button(navigatorCollapsed ? String(localized: "view-commands.show-navigator", defaultValue: "Show Navigator", comment: "Menu item to show navigator") : String(localized: "view-commands.hide-navigator", defaultValue: "Hide Navigator", comment: "Menu item to hide navigator")) {
                windowController?.toggleFirstPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("0", modifiers: [.command])

            Button(inspectorCollapsed ? String(localized: "view-commands.show-inspector", defaultValue: "Show Inspector", comment: "Menu item to show inspector") : String(localized: "view-commands.hide-inspector", defaultValue: "Hide Inspector", comment: "Menu item to hide inspector")) {
                windowController?.toggleLastPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("i", modifiers: [.control, .command])

            Button(utilityAreaCollapsed ? String(localized: "view-commands.show-utility-area", defaultValue: "Show Utility Area", comment: "Menu item to show utility area") : String(localized: "view-commands.hide-utility-area", defaultValue: "Hide Utility Area", comment: "Menu item to hide utility area")) {
                CommandManager.shared.executeCommand("open.drawer")
            }
            .disabled(windowController == nil)
            .keyboardShortcut("y", modifiers: [.shift, .command])

            Button(toolbarCollapsed ? String(localized: "view-commands.show-toolbar", defaultValue: "Show Toolbar", comment: "Menu item to show toolbar") : String(localized: "view-commands.hide-toolbar", defaultValue: "Hide Toolbar", comment: "Menu item to hide toolbar")) {
                windowController?.toggleToolbar()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("t", modifiers: [.option, .command])

            Button(isInterfaceHidden ? String(localized: "view-commands.show-interface", defaultValue: "Show Interface", comment: "Menu item to show interface") : String(localized: "view-commands.hide-interface", defaultValue: "Hide Interface", comment: "Menu item to hide interface")) {
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
            Menu(String(localized: "view-commands.navigators-menu", defaultValue: "Navigators", comment: "Navigators menu title"), content: {
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
