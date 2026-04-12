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

            Menu("Font Size") {
                Button(String(localized: "view-commands.font-size-increase", defaultValue: "Increase", comment: "Menu item to increase font size")) {
                    if editorFontSize < 288 {
                        editorFontSize += 1
                    }
                    if terminalFontSize < 288 {
                        terminalFontSize += 1
                    }
                }
                .keyboardShortcut("+")

                Button(String(localized: "view-commands.font-size-decrease", defaultValue: "Decrease", comment: "Menu item to decrease font size")) {
                    if editorFontSize > 1 {
                        editorFontSize -= 1
                    }
                    if terminalFontSize > 1 {
                        terminalFontSize -= 1
                    }
                }
                .keyboardShortcut("-")

                Divider()

                Button(String(localized: "view-commands.font-size-reset", defaultValue: "Reset", comment: "Menu item to reset font size")) {
                    editorFontSize = 12
                    terminalFontSize = 12
                }
                .keyboardShortcut("0", modifiers: [.command, .control])
            }
            .disabled(windowController == nil)

            Button(String(localized: "view-commands.customize-toolbar", defaultValue: "Customize Toolbar...", comment: "Menu item to customize toolbar")) {

            }
            .disabled(true)

            Divider()

            HideCommands()

            Divider()

            Button(String(format: String(localized: "view-commands.toggle-jump-bar", defaultValue: "%@ Jump Bar", comment: "Menu item to toggle jump bar"), showEditorJumpBar ? String(localized: "view-commands.hide", defaultValue: "Hide", comment: "Hide action") : String(localized: "view-commands.show", defaultValue: "Show", comment: "Show action"))) {
                showEditorJumpBar.toggle()
            }

            Toggle(String(localized: "view-commands.dim-editors", defaultValue: "Dim editors without focus", comment: "Toggle to dim editors without focus"), isOn: $dimEditorsWithoutFocus)

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
            Button(String(format: String(localized: "view-commands.toggle-navigator", defaultValue: "%@ Navigator", comment: "Menu item to toggle navigator"), navigatorCollapsed ? String(localized: "view-commands.show-navigator", defaultValue: "Show", comment: "Show navigator action") : String(localized: "view-commands.hide-navigator", defaultValue: "Hide", comment: "Hide navigator action"))) {
                windowController?.toggleFirstPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("0", modifiers: [.command])

            Button(String(format: String(localized: "view-commands.toggle-inspector", defaultValue: "%@ Inspector", comment: "Menu item to toggle inspector"), inspectorCollapsed ? String(localized: "view-commands.show-inspector", defaultValue: "Show", comment: "Show inspector action") : String(localized: "view-commands.hide-inspector", defaultValue: "Hide", comment: "Hide inspector action"))) {
                windowController?.toggleLastPanel()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("i", modifiers: [.control, .command])

            Button(String(format: String(localized: "view-commands.toggle-utility-area", defaultValue: "%@ Utility Area", comment: "Menu item to toggle utility area"), utilityAreaCollapsed ? String(localized: "view-commands.show-utility", defaultValue: "Show", comment: "Show utility area action") : String(localized: "view-commands.hide-utility", defaultValue: "Hide", comment: "Hide utility area action"))) {
                CommandManager.shared.executeCommand("open.drawer")
            }
            .disabled(windowController == nil)
            .keyboardShortcut("y", modifiers: [.shift, .command])

            Button(String(format: String(localized: "view-commands.toggle-toolbar", defaultValue: "%@ Toolbar", comment: "Menu item to toggle toolbar"), toolbarCollapsed ? String(localized: "view-commands.show-toolbar", defaultValue: "Show", comment: "Show toolbar action") : String(localized: "view-commands.hide-toolbar", defaultValue: "Hide", comment: "Hide toolbar action"))) {
                windowController?.toggleToolbar()
            }
            .disabled(windowController == nil)
            .keyboardShortcut("t", modifiers: [.option, .command])

            Button(String(format: String(localized: "view-commands.toggle-interface", defaultValue: "%@ Interface", comment: "Menu item to toggle interface"), isInterfaceHidden ? String(localized: "view-commands.show-interface", defaultValue: "Show", comment: "Show interface action") : String(localized: "view-commands.hide-interface", defaultValue: "Hide", comment: "Hide interface action"))) {
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
            Menu(String(localized: "view-commands.navigators", defaultValue: "Navigators", comment: "Menu title for navigators"), content: {
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
