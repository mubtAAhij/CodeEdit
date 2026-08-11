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
            Button(String(localized: "window.commands.view.show-command-palette", defaultValue: "Show Command Palette", comment: "Command title to open command palette")) {
                NSApp.sendAction(#selector(CodeEditWindowController.openCommandPalette(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("p", modifiers: [.shift, .command])

            Button(String(localized: "window.commands.view.open-search-navigator", defaultValue: "Open Search Navigator", comment: "Command title to open search navigator")) {
                NSApp.sendAction(#selector(CodeEditWindowController.openSearchNavigator(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("f", modifiers: [.shift, .command])

            Menu(String(localized: "window.commands.view.font-size", defaultValue: "Font Size", comment: "Submenu title for font size commands")) {
                Button(String(localized: "window.commands.view.font-size.increase", defaultValue: "Increase", comment: "Command title to increase editor font size")) {
                    if editorFontSize < 288 {
                        editorFontSize += 1
                    }
                    if terminalFontSize < 288 {
                        terminalFontSize += 1
                    }
                }
                .keyboardShortcut("+")

                Button(String(localized: "window.commands.view.font-size.decrease", defaultValue: "Decrease", comment: "Command title to decrease editor font size")) {
                    if editorFontSize > 1 {
                        editorFontSize -= 1
                    }
                    if terminalFontSize > 1 {
                        terminalFontSize -= 1
                    }
                }
                .keyboardShortcut("-")

                Divider()

                Button(String(localized: "window.commands.view.font-size.reset", defaultValue: "Reset", comment: "Command title to reset editor font size")) {
                    editorFontSize = 12
                    terminalFontSize = 12
                }
                .keyboardShortcut("0", modifiers: [.command, .control])
            }
            .disabled(windowController == nil)

            Button(String(localized: "window.commands.view.customize-toolbar", defaultValue: "Customize Toolbar...", comment: "Command title to customize toolbar")) {

            }
            .disabled(true)

            Divider()

            HideCommands()

            Divider()

            Button(String(format: String(localized: "window.commands.view.toggle-jump-bar", defaultValue: "%@ Jump Bar", comment: "Command title to toggle jump bar visibility"), (showEditorJumpBar ? String(localized: "window.commands.view.verb.hide", defaultValue: "Hide", comment: "Verb used in view toggle command labels") : String(localized: "window.commands.view.verb.show", defaultValue: "Show", comment: "Verb used in view toggle command labels")))) {
                showEditorJumpBar.toggle()
            }

            Toggle(String(localized: "window.commands.view.dim-editors-without-focus", defaultValue: "Dim editors without focus", comment: "Command title to dim unfocused editors"), isOn: $dimEditorsWithoutFocus)

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
            Button(String(format: String(localized: "window.commands.view.toggle-navigator", defaultValue: "%@ Navigator", comment: "Command title to toggle navigator visibility"), (navigatorCollapsed ? String(localized: "window.commands.view.verb.show", defaultValue: "Show", comment: "Verb used in view toggle command labels") : String(localized: "window.commands.view.verb.hide", defaultValue: "Hide", comment: "Verb used in view toggle command labels")))) {
                windowController?.toggleFirstPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("0", modifiers: [.command])

            Button(String(format: String(localized: "window.commands.view.toggle-inspector", defaultValue: "%@ Inspector", comment: "Command title to toggle inspector visibility"), (inspectorCollapsed ? String(localized: "window.commands.view.verb.show", defaultValue: "Show", comment: "Verb used in view toggle command labels") : String(localized: "window.commands.view.verb.hide", defaultValue: "Hide", comment: "Verb used in view toggle command labels")))) {
                windowController?.toggleLastPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("i", modifiers: [.control, .command])

            Button(String(format: String(localized: "window.commands.view.toggle-utility-area", defaultValue: "%@ Utility Area", comment: "Command title to toggle utility area visibility"), (utilityAreaCollapsed ? String(localized: "window.commands.view.verb.show", defaultValue: "Show", comment: "Verb used in view toggle command labels") : String(localized: "window.commands.view.verb.hide", defaultValue: "Hide", comment: "Verb used in view toggle command labels")))) {
                CommandManager.shared.executeCommand("open.drawer")
            }
            .disabled(windowController == nil)
            .keyboardShortcut("y", modifiers: [.shift, .command])

            Button(String(format: String(localized: "window.commands.view.toggle-toolbar", defaultValue: "%@ Toolbar", comment: "Command title to toggle toolbar visibility"), (toolbarCollapsed ? String(localized: "window.commands.view.verb.show", defaultValue: "Show", comment: "Verb used in view toggle command labels") : String(localized: "window.commands.view.verb.hide", defaultValue: "Hide", comment: "Verb used in view toggle command labels")))) {
                windowController?.toggleToolbar()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("t", modifiers: [.option, .command])

            Button(String(format: String(localized: "window.commands.view.toggle-interface", defaultValue: "%@ Interface", comment: "Command title to toggle full interface visibility"), (isInterfaceHidden ? String(localized: "window.commands.view.verb.show", defaultValue: "Show", comment: "Verb used in view toggle command labels") : String(localized: "window.commands.view.verb.hide", defaultValue: "Hide", comment: "Verb used in view toggle command labels")))) {
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
            Menu(String(localized: "window.commands.view.navigators", defaultValue: "Navigators", comment: "Submenu title for navigator visibility commands"), content: {
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
