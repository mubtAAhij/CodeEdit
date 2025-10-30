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
                Button(String(localized: "menu.file.new", defaultValue: "New", comment: "Menu item to create new file")) {
                    NSDocumentController.shared.newDocument(nil)
                }
                .keyboardShortcut("n")

                Button(String(localized: "menu.file.open", defaultValue: "Open...", comment: "Menu item to open file")) {
                    NSDocumentController.shared.openDocument(nil)
                }
                .keyboardShortcut("o")

                // Leave this empty, is done through a hidden API in WindowCommands/Utils/CommandsFixes.swift
                // We set this with a custom NSMenu. See WindowCommands/Utils/RecentProjectsMenu.swift
                Menu(String(localized: "menu.file.open-recent.menu", defaultValue: "Open Recent", comment: "Open recent menu title")) { }

                Button(String(localized: "menu.file.open-quickly", defaultValue: "Open Quickly", comment: "Menu item to open quickly")) {
                    NSApp.sendAction(#selector(CodeEditWindowController.openQuickly(_:)), to: nil, from: nil)
                }
                .keyboardShortcut("o", modifiers: [.command, .shift])
            }
        }

        CommandGroup(replacing: .saveItem) {
            Button(String(localized: "menu.file.close-tab", defaultValue: "Close Tab", comment: "Menu item to close tab")) {
                if NSApp.target(forAction: #selector(CodeEditWindowController.closeCurrentTab(_:))) != nil {
                    NSApp.sendAction(#selector(CodeEditWindowController.closeCurrentTab(_:)), to: nil, from: nil)
                } else {
                    NSApp.sendAction(#selector(NSWindow.performClose(_:)), to: NSApp.keyWindow, from: nil)
                }
            }
            .keyboardShortcut("w")

            Button(String(localized: "menu.file.close-editor", defaultValue: "Close Editor", comment: "Menu item to close editor")) {
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

            Button(String(localized: "menu.file.close-window", defaultValue: "Close Window", comment: "Menu item to close window")) {
                NSApp.sendAction(#selector(NSWindow.performClose(_:)), to: NSApp.keyWindow, from: nil)
            }
            .keyboardShortcut("w", modifiers: [.shift, .command])

            Button(String(localized: "menu.file.close-workspace", defaultValue: "Close Workspace", comment: "Menu item to close workspace")) {
                NSApp.sendAction(#selector(NSWindow.performClose(_:)), to: NSApp.keyWindow, from: nil)
            }
            .keyboardShortcut("w", modifiers: [.control, .option, .command])
            .disabled(!(NSApplication.shared.keyWindow?.windowController is CodeEditWindowController))

            if let utilityAreaViewModel {
                Button(String(localized: "menu.file.close-terminal", defaultValue: "Close Terminal", comment: "Menu item to close terminal")) {
                    utilityAreaViewModel.removeTerminals(utilityAreaViewModel.selectedTerminals)
                }
                .keyboardShortcut(.delete)
            }

            Divider()

            Button(String(localized: "menu.file.workspace-settings", defaultValue: "Workspace Settings", comment: "Menu item to open workspace settings")) {
                NSApp.sendAction(#selector(CodeEditWindowController.openWorkspaceSettings(_:)), to: nil, from: nil)
            }
            .disabled(windowController?.workspace == nil)

            Divider()

            Button(String(localized: "menu.file.save", defaultValue: "Save", comment: "Menu item to save file")) {
                NSApp.sendAction(#selector(CodeEditWindowController.saveDocument(_:)), to: nil, from: nil)
            }
            .keyboardShortcut("s")
        }
    }
}
