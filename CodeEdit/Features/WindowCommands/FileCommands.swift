//
//  FileCommands.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 13/03/2023.
//

import SwiftUI

struct FileCommands: Commands {
    static let recentProjectsMenu = RecentProjectsMenu()

    @Environment(\.openWindow)
    private var openWindow

    @UpdatingWindowController var windowController

    @FocusedObject var utilityAreaViewModel: UtilityAreaViewModel?

    var body: some Commands {
        CommandGroup(replacing: .newItem) {
            Group {
                Button(String(localized: "file.commands.new", defaultValue: "New", comment: "Menu item to create a new document")) {
                    NSDocumentController.shared.newDocument(nil)
                }
                .keyboardShortcut(String(localized: "file.commands.new.shortcut", defaultValue: "n", comment: "Keyboard shortcut key for New command"))

                Button(String(localized: "file.commands.open", defaultValue: "Open...", comment: "Menu item to open a document")) {
                    NSDocumentController.shared.openDocument(nil)
                }
                .keyboardShortcut(String(localized: "file.commands.open.shortcut", defaultValue: "o", comment: "Keyboard shortcut key for Open command"))

                // Leave this empty, is done through a hidden API in WindowCommands/Utils/CommandsFixes.swift
                // We set this with a custom NSMenu. See WindowCommands/Utils/RecentProjectsMenu.swift
                Menu(String(localized: "file.commands.open.recent", defaultValue: "Open Recent", comment: "Menu item to open recent projects")) { }

                Button(String(localized: "file.commands.open.quickly", defaultValue: "Open Quickly", comment: "Menu item to open files quickly")) {
                    NSApp.sendAction(#selector(CodeEditWindowController.openQuickly(_:)), to: nil, from: nil)
                }
                .keyboardShortcut(String(localized: "file.commands.open.quickly.shortcut", defaultValue: "o", comment: "Keyboard shortcut key for Open Quickly command"), modifiers: [.command, .shift])
            }
        }

        CommandGroup(replacing: .saveItem) {
            Button(String(localized: "file.commands.close.tab", defaultValue: "Close Tab", comment: "Menu item to close the current tab")) {
                if NSApp.target(forAction: #selector(CodeEditWindowController.closeCurrentTab(_:))) != nil {
                    NSApp.sendAction(#selector(CodeEditWindowController.closeCurrentTab(_:)), to: nil, from: nil)
                } else {
                    NSApp.sendAction(#selector(NSWindow.performClose(_:)), to: NSApp.keyWindow, from: nil)
                }
            }
            .keyboardShortcut(String(localized: "file.commands.close.tab.shortcut", defaultValue: "w", comment: "Keyboard shortcut key for Close Tab command"))

            Button(String(localized: "file.commands.close.editor", defaultValue: "Close Editor", comment: "Menu item to close the current editor")) {
                if NSApp.target(forAction: #selector(CodeEditWindowController.closeActiveEditor(_:))) != nil {
                    NSApp.sendAction(
                        #selector(CodeEditWindowController.closeActiveEditor(_:)),
                        to: nil,
                        from: nil
                    )
                } else {
                    NSApp.sendAction(#selector(NSWindow.performClose(_:)), to: NSApp.keyWindow, from: nil)
                }
            }
            .keyboardShortcut(String(localized: "file.commands.close.editor.shortcut", defaultValue: "w", comment: "Keyboard shortcut key for Close Editor command"), modifiers: [.control, .shift, .command])

            Button(String(localized: "file.commands.close.window", defaultValue: "Close Window", comment: "Menu item to close the current window")) {
                NSApp.sendAction(#selector(NSWindow.performClose(_:)), to: NSApp.keyWindow, from: nil)
            }
            .keyboardShortcut(String(localized: "file.commands.close.window.shortcut", defaultValue: "w", comment: "Keyboard shortcut key for Close Window command"), modifiers: [.shift, .command])

            Button(String(localized: "file.commands.close.workspace", defaultValue: "Close Workspace", comment: "Menu item to close the current workspace")) {
                NSApp.sendAction(#selector(NSWindow.performClose(_:)), to: NSApp.keyWindow, from: nil)
            }
            .keyboardShortcut(String(localized: "file.commands.close.workspace.shortcut", defaultValue: "w", comment: "Keyboard shortcut key for Close Workspace command"), modifiers: [.control, .option, .command])
            .disabled(!(NSApplication.shared.keyWindow?.windowController is CodeEditWindowController))

            if let utilityAreaViewModel {
                Button(String(localized: "file.commands.close.terminal", defaultValue: "Close Terminal", comment: "Menu item to close selected terminals")) {
                    utilityAreaViewModel.removeTerminals(utilityAreaViewModel.selectedTerminals)
                }
                .keyboardShortcut(.delete)
            }

            Divider()

            Button(String(localized: "file.commands.workspace.settings", defaultValue: "Workspace Settings", comment: "Menu item to open workspace settings")) {
                NSApp.sendAction(#selector(CodeEditWindowController.openWorkspaceSettings(_:)), to: nil, from: nil)
            }
            .disabled(windowController?.workspace == nil)

            Divider()

            Button(String(localized: "file.commands.save", defaultValue: "Save", comment: "Menu item to save the current document")) {
                NSApp.sendAction(#selector(CodeEditWindowController.saveDocument(_:)), to: nil, from: nil)
            }
            .keyboardShortcut(String(localized: "file.commands.save.shortcut", defaultValue: "s", comment: "Keyboard shortcut key for Save command"))
        }
    }
}
