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
                Button(String(localized: "file.menu.new", comment: "Menu item for creating new file")) {
                    NSDocumentController.shared.newDocument(nil)
                }
                .keyboardShortcut("n")

                Button(String(localized: "file.menu.open", comment: "Menu item for opening file")) {
                    NSDocumentController.shared.openDocument(nil)
                }
                .keyboardShortcut("o")

                // Leave this empty, is done through a hidden API in WindowCommands/Utils/CommandsFixes.swift
                // We set this with a custom NSMenu. See WindowCommands/Utils/RecentProjectsMenu.swift
                Menu(String(localized: "file.menu.open_recent", comment: "Menu item for opening recent files")) { }

                Button(String(localized: "file.menu.open_quickly", comment: "Menu item for quick open")) {
                    NSApp.sendAction(#selector(CodeEditWindowController.openQuickly(_:)), to: nil, from: nil)
                }
                .keyboardShortcut("o", modifiers: [.command, .shift])
            }
        }

        CommandGroup(replacing: .saveItem) {
            Button(String(localized: "file.menu.close_tab", comment: "Menu item for closing current tab")) {
                if NSApp.target(forAction: #selector(CodeEditWindowController.closeCurrentTab(_:))) != nil {
                    NSApp.sendAction(#selector(CodeEditWindowController.closeCurrentTab(_:)), to: nil, from: nil)
                } else {
                    NSApp.sendAction(#selector(NSWindow.performClose(_:)), to: NSApp.keyWindow, from: nil)
                }
            }
            .keyboardShortcut("w")

            Button(String(localized: "file.menu.close_editor", comment: "Menu item for closing current editor")) {
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
            .keyboardShortcut("w", modifiers: [.control, .shift, .command])

            Button(String(localized: "file.menu.close_window", comment: "Menu item for closing current window")) {
                NSApp.sendAction(#selector(NSWindow.performClose(_:)), to: NSApp.keyWindow, from: nil)
            }
            .keyboardShortcut("w", modifiers: [.shift, .command])

            Button(String(localized: "file.menu.close_workspace", comment: "Menu item for closing current workspace")) {
                NSApp.sendAction(#selector(NSWindow.performClose(_:)), to: NSApp.keyWindow, from: nil)
            }
            .keyboardShortcut("w", modifiers: [.control, .option, .command])
            .disabled(!(NSApplication.shared.keyWindow?.windowController is CodeEditWindowController))

            if let utilityAreaViewModel {
                Button(String(localized: "file.menu.close_terminal", comment: "Menu item for closing terminal")) {
                    utilityAreaViewModel.removeTerminals(utilityAreaViewModel.selectedTerminals)
                }
                .keyboardShortcut(.delete)
            }

            Divider()

            Button(String(localized: "file.menu.workspace_settings", comment: "Menu item for opening workspace settings")) {
                NSApp.sendAction(#selector(CodeEditWindowController.openWorkspaceSettings(_:)), to: nil, from: nil)
            }
            .disabled(windowController?.workspace == nil)

            Divider()

            Button(String(localized: "file.menu.save", comment: "Menu item for saving file")) {
                NSApp.sendAction(#selector(CodeEditWindowController.saveDocument(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("s")
        }
    }
}
