//
//  OutlineMenu.swift
//  CodeEdit
//
//  Created by Lukas Pistrol on 07.04.22.
//

import SwiftUI
import UniformTypeIdentifiers

/// A subclass of `NSMenu` implementing the contextual menu for the project navigator
final class ProjectNavigatorMenu: NSMenu {

    /// The item to show the contextual menu for
    var item: CEWorkspaceFile?

    /// The workspace, for opening the item
    var workspace: WorkspaceDocument?

    /// The  `ProjectNavigatorViewController` is being called from.
    /// By sending it, we can access it's variables and functions.
    var sender: ProjectNavigatorViewController

    init(_ sender: ProjectNavigatorViewController) {
        self.sender = sender
        super.init(title: String(localized: "project_navigator.options", comment: "Menu section title for options"))
    }

    @available(*, unavailable)
    required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Creates a `NSMenuItem` depending on the given arguments
    /// - Parameters:
    ///   - title: The title of the menu item
    ///   - action: A `Selector` or `nil` of the action to perform.
    ///   - key: A `keyEquivalent` of the menu item. Defaults to an empty `String`
    /// - Returns: A `NSMenuItem` which has the target `self`
    private func menuItem(_ title: String, action: Selector?, key: String = "") -> NSMenuItem {
        let mItem = NSMenuItem(title: title, action: action, keyEquivalent: key)
        mItem.target = self

        return mItem
    }

    /// Configures the menu based on the current selection in the outline view.
    /// - Menu items get added depending on the amount of selected items.
    private func setupMenu() { // swiftlint:disable:this function_body_length
        guard let item else { return }
        let showInFinder = menuItem(String(localized: "project_navigator.show_in_finder", comment: "Context menu item to reveal file in Finder"), action: #selector(showInFinder))

        let openInTab = menuItem(String(localized: "project_navigator.open_in_tab", comment: "Context menu item to open file in new tab"), action: #selector(openInTab))
        let openInNewWindow = menuItem(String(localized: "project_navigator.open_in_new_window", comment: "Context menu item to open file in new window"), action: nil)
        let openExternalEditor = menuItem(String(localized: "project_navigator.open_with_external_editor", comment: "Context menu item to open file with external editor"), action: #selector(openWithExternalEditor))
        let openAs = menuItem(String(localized: "project_navigator.open_as", comment: "Context menu submenu title for open as options"), action: nil)

        let copyPath = menuItem(String(localized: "project_navigator.copy_path", comment: "Context menu item to copy full file path"), action: #selector(copyPath))
        let copyRelativePath = menuItem(String(localized: "project_navigator.copy_relative_path", comment: "Context menu item to copy relative file path"), action: #selector(copyRelativePath))

        let showFileInspector = menuItem(String(localized: "project_navigator.show_file_inspector", comment: "Context menu item to show file inspector panel"), action: nil)

        let newFile = menuItem(String(localized: "project_navigator.new_file", comment: "Context menu item to create new file"), action: #selector(newFile))
        let newFileFromClipboard = menuItem(
            String(localized: "project_navigator.new_file_from_clipboard", comment: "Context menu item to create file from clipboard content"),
            action: #selector(newFileFromClipboard),
            key: "v"
        )
        newFileFromClipboard.keyEquivalentModifierMask = [.command]
        let newFolder = menuItem(String(localized: "project_navigator.new_folder", comment: "Context menu item to create new folder"), action: #selector(newFolder))

        let rename = menuItem(String(localized: "project_navigator.menu.rename", comment: "Context menu item to rename a file or folder"), action: #selector(renameFile))

        let trash = menuItem(String(localized: "project_navigator.menu.move_to_trash", comment: "Context menu item to move file to trash"), action:
                                item.url != workspace?.workspaceFileManager?.folderUrl
                              ? #selector(trash) : nil)

        // trash has to be the previous menu item for delete.isAlternate to work correctly
        let delete = menuItem(String(localized: "project_navigator.menu.delete_immediately", comment: "Context menu item to permanently delete file"), action:
                                item.url != workspace?.workspaceFileManager?.folderUrl
                              ? #selector(delete) : nil)
        delete.keyEquivalentModifierMask = .option
        delete.isAlternate = true

        let duplicate = menuItem("Duplicate \(item.isFolder ? "Folder" : "File")", action: #selector(duplicate))

        let sortByName = menuItem(String(localized: "project_navigator.menu.sort_by_name", comment: "Context menu item to sort by name"), action: nil)
        sortByName.isEnabled = item.isFolder

        let sortByType = menuItem(String(localized: "project_navigator.menu.sort_by_type", comment: "Context menu item to sort by type"), action: nil)
        sortByType.isEnabled = item.isFolder

        let sourceControl = menuItem(String(localized: "project_navigator.menu.source_control", comment: "Context menu item for source control options"), action: nil)

        items = [
            showInFinder,
            NSMenuItem.separator(),
            openInTab,
            openInNewWindow,
            openExternalEditor,
            openAs,
            NSMenuItem.separator(),
            copyPath,
            copyRelativePath,
            NSMenuItem.separator(),
            showFileInspector,
            NSMenuItem.separator(),
            newFile,
            newFileFromClipboard,
            newFolder
        ]

        if canCreateFolderFromSelection() {
            items.append(menuItem(String(localized: "project_navigator.menu.new_folder_from_selection", comment: "Context menu item to create folder from selection"), action: #selector(newFolderFromSelection)))
        }
        items.append(NSMenuItem.separator())
        if selectedItems().count == 1 {
            items.append(rename)
        }

        items.append(
            contentsOf: [
                trash,
                delete,
                duplicate,
                NSMenuItem.separator(),
                sortByName,
                sortByType,
                NSMenuItem.separator(),
                sourceControl,
            ]
        )

        setSubmenu(openAsMenu(item: item), for: openAs)
        setSubmenu(sourceControlMenu(item: item), for: sourceControl)
    }

    /// Submenu for **Open As** menu item.
    private func openAsMenu(item: CEWorkspaceFile) -> NSMenu {
        let openAsMenu = NSMenu(title: String(localized: "project_navigator.open_as", comment: "Context menu submenu title for open as options"))
        func getMenusItems() -> ([NSMenuItem], [NSMenuItem]) {
            // Use UTType to distinguish between bundle file and user-browsable directory
            // The isDirectory property is not accurate on this.
            guard let type = item.contentType else { return ([.none()], []) }
            if type.conforms(to: .folder) {
                return ([.none()], [])
            }
            var primaryItems = [NSMenuItem]()
            if type.conforms(to: .sourceCode) {
                primaryItems.append(.sourceCode())
            }
            if type.conforms(to: .propertyList) {
                primaryItems.append(.propertyList())
            }
            if type.conforms(to: UTType(filenameExtension: "xcassets")!) {
                primaryItems.append(NSMenuItem(title: String(localized: "project_navigator.file_type.asset_catalog", comment: "File type for asset catalog documents"), action: nil, keyEquivalent: ""))
            }
            if type.conforms(to: UTType(filenameExtension: "xib")!) {
                primaryItems.append(NSMenuItem(title: String(localized: "project_navigator.file_type.xib_document", comment: "File type for XIB documents"), action: nil, keyEquivalent: ""))
            }
            if type.conforms(to: UTType(filenameExtension: "xcodeproj")!) {
                primaryItems.append(NSMenuItem(title: String(localized: "project_navigator.file_type.xcode_project", comment: "File type for Xcode projects"), action: nil, keyEquivalent: ""))
            }
            var secondaryItems = [NSMenuItem]()
            if type.conforms(to: .text) {
                secondaryItems.append(.asciiPropertyList())
                secondaryItems.append(.hex())
            }

            // FIXME: Update the quickLook condition
            if type.conforms(to: .data) {
                secondaryItems.append(.quickLook())
            }

            return (primaryItems, secondaryItems)
        }
        let (primaryItems, secondaryItems) = getMenusItems()
        for item in primaryItems {
            openAsMenu.addItem(item)
        }
        if !secondaryItems.isEmpty {
            openAsMenu.addItem(.separator())
        }
        for item in secondaryItems {
            openAsMenu.addItem(item)
        }
        return openAsMenu
    }

    /// Submenu for **Source Control** menu item.
    private func sourceControlMenu(item: CEWorkspaceFile) -> NSMenu {
        let sourceControlMenu = NSMenu(title: String(localized: "project_navigator.menu.source_control", comment: "Context menu item for source control options"))
        sourceControlMenu.addItem(
            withTitle: "Commit \"\(String(describing: item.fileName()))\"...",
            action: nil,
            keyEquivalent: ""
        )
        sourceControlMenu.addItem(.separator())
        sourceControlMenu.addItem(withTitle: String(localized: "project_navigator.menu.discard_changes", comment: "Context menu item to discard changes"), action: nil, keyEquivalent: "")
        sourceControlMenu.addItem(.separator())
        sourceControlMenu.addItem(withTitle: String(localized: "project_navigator.menu.add_selected_files", comment: "Context menu item to add selected files to source control"), action: nil, keyEquivalent: "")
        sourceControlMenu.addItem(withTitle: String(localized: "project_navigator.menu.mark_files_resolved", comment: "Context menu item to mark files as resolved"), action: nil, keyEquivalent: "")

        return sourceControlMenu
    }

    /// Updates the menu for the selected item and hides it if no item is provided.
    override func update() {
        removeAllItems()
        setupMenu()
    }
}

extension NSMenuItem {
    fileprivate static func none() -> NSMenuItem {
        let item = NSMenuItem(title: String(localized: "project_navigator.menu.none", comment: "Menu item indicating no options available"), action: nil, keyEquivalent: "")
        item.isEnabled = false
        return item
    }

    fileprivate static func sourceCode() -> NSMenuItem {
        NSMenuItem(title: String(localized: "project_navigator.open_as.source_code", comment: "Menu item to open as source code"), action: nil, keyEquivalent: "")
    }

    fileprivate static func propertyList() -> NSMenuItem {
        NSMenuItem(title: String(localized: "project_navigator.open_as.property_list", comment: "Menu item to open as property list"), action: nil, keyEquivalent: "")
    }

    fileprivate static func asciiPropertyList() -> NSMenuItem {
        NSMenuItem(title: String(localized: "project_navigator.open_as.ascii_property_list", comment: "Menu item to open as ASCII property list"), action: nil, keyEquivalent: "")
    }

    fileprivate static func hex() -> NSMenuItem {
        NSMenuItem(title: String(localized: "project_navigator.open_as.hex", comment: "Menu item to open in hex editor"), action: nil, keyEquivalent: "")
    }

    fileprivate static func quickLook() -> NSMenuItem {
        NSMenuItem(title: String(localized: "project_navigator.open_as.quick_look", comment: "Menu item to open with Quick Look"), action: nil, keyEquivalent: "")
    }
}
