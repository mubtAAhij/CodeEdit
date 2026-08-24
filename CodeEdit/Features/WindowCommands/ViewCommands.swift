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
            Button(String(localized: "window-commands.view.show-command-palette", defaultValue: "Show Command Palette", comment: "View command to open the command palette")) {
                NSApp.sendAction(#selector(CodeEditWindowController.openCommandPalette(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("p", modifiers: [.shift, .command])

            Button(String(localized: "window-commands.view.open-search-navigator", defaultValue: "Open Search Navigator", comment: "View command to open the search navigator")) {
                NSApp.sendAction(#selector(CodeEditWindowController.openSearchNavigator(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("f", modifiers: [.shift, .command])

            Menu(String(localized: "window-commands.view.font-size", defaultValue: "Font Size", comment: "View menu title for font size controls")) {
                Button(String(localized: "window-commands.view.font-size.increase", defaultValue: "Increase", comment: "View command to increase font size")) {
                    if editorFontSize < 288 {
                        editorFontSize += 1
                    }
                    if terminalFontSize < 288 {
                        terminalFontSize += 1
                    }
                }
                .keyboardShortcut("+")

                Button(String(localized: "window-commands.view.font-size.decrease", defaultValue: "Decrease", comment: "View command to decrease font size")) {
                    if editorFontSize > 1 {
                        editorFontSize -= 1
                    }
                    if terminalFontSize > 1 {
                        terminalFontSize -= 1
                    }
                }
                .keyboardShortcut("-")

                Divider()

                Button(String(localized: "window-commands.view.font-size.reset", defaultValue: "Reset", comment: "View command to reset font size")) {
                    editorFontSize = 12
                    terminalFontSize = 12
                }
                .keyboardShortcut("0", modifiers: [.command, .control])
            }
            .disabled(windowController == nil)

            Button(String(localized: "window-commands.view.customize-toolbar", defaultValue: "Customize Toolbar...", comment: "View command title for customizing the toolbar")) {}
                .disabled(true)

            Divider()

            HideCommands()

            Divider()

            Button(showEditorJumpBar
                ? String(localized: "window-commands.view.jump-bar.hide", defaultValue: "Hide Jump Bar", comment: "View command to hide the editor jump bar")
                : String(localized: "window-commands.view.jump-bar.show", defaultValue: "Show Jump Bar", comment: "View command to show the editor jump bar"))
            {
                showEditorJumpBar.toggle()
            }

            Toggle(String(localized: "window-commands.view.dim-editors-without-focus", defaultValue: "Dim editors without focus", comment: "Toggle to dim editors that are not focused"), isOn: $dimEditorsWithoutFocus)

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
                ? String(localized: "window-commands.view.navigator.show", defaultValue: "Show Navigator", comment: "View command to show the navigator")
                : String(localized: "window-commands.view.navigator.hide", defaultValue: "Hide Navigator", comment: "View command to hide the navigator"))
            {
                windowController?.toggleFirstPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("0", modifiers: [.command])

            Button(inspectorCollapsed
                ? String(localized: "window-commands.view.inspector.show", defaultValue: "Show Inspector", comment: "View command to show the inspector")
                : String(localized: "window-commands.view.inspector.hide", defaultValue: "Hide Inspector", comment: "View command to hide the inspector"))
            {
                windowController?.toggleLastPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("i", modifiers: [.control, .command])

            Button(utilityAreaCollapsed
                ? String(localized: "window-commands.view.utility-area.show", defaultValue: "Show Utility Area", comment: "View command to show the utility area")
                : String(localized: "window-commands.view.utility-area.hide", defaultValue: "Hide Utility Area", comment: "View command to hide the utility area"))
            {
                CommandManager.shared.executeCommand("open.drawer")
            }
            .disabled(windowController == nil)
            .keyboardShortcut("y", modifiers: [.shift, .command])

            Button(toolbarCollapsed
                ? String(localized: "window-commands.view.toolbar.show", defaultValue: "Show Toolbar", comment: "View command to show the toolbar")
                : String(localized: "window-commands.view.toolbar.hide", defaultValue: "Hide Toolbar", comment: "View command to hide the toolbar"))
            {
                windowController?.toggleToolbar()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("t", modifiers: [.option, .command])

            Button(isInterfaceHidden
                ? String(localized: "window-commands.view.interface.show", defaultValue: "Show Interface", comment: "View command to show the interface")
                : String(localized: "window-commands.view.interface.hide", defaultValue: "Hide Interface", comment: "View command to hide the interface"))
            {
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
            Menu(String(localized: "window-commands.view.navigators.menu", defaultValue: "Navigators", comment: "View menu title for navigator tabs"), content: {
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
