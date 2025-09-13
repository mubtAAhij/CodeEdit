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
        super.init(title: String(localized: "options_menu_title", comment: "Context menu title"))
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
        let showInFinder = menuItem("Show in Finder", action: #selector(showInFinder))

        let openInTab = menuItem(String(localized: "open_in_tab", comment: "Menu item to open file in tab"), action: #selector(openInTab))
        let openInNewWindow = menuItem(String(localized: "open_in_new_window", comment: "Menu item to open file in new window"), action: nil)
        let openExternalEditor = menuItem(String(localized: "open_with_external_editor", comment: "Context menu option to open file with external editor"), action: #selector(openWithExternalEditor))
        let openAs = menuItem(String(localized: "open_as", comment: "Context menu option to open file in different format"), action: nil)

        let copyPath = menuItem("Copy Path", action: #selector(copyPath))
        let copyRelativePath = menuItem(String(localized: "copy_relative_path", comment: "Context menu option to copy relative path to file"), action: #selector(copyRelativePath))

        let showFileInspector = menuItem(String(localized: "show_file_inspector", comment: "Context menu option to show file inspector panel"), action: nil)

        let newFile = menuItem(String(localized: "new_file", comment: "Context menu option to create a new file"), action: #selector(newFile))
        let newFileFromClipboard = menuItem(
            String(localized: "new_file_from_clipboard", comment: "Context menu option to create a new file from clipboard content"),
            action: #selector(newFileFromClipboard),
            key: "v"
        )
        newFileFromClipboard.keyEquivalentModifierMask = [.command]
        let newFolder = menuItem(String(localized: "new_folder", comment: "Context menu option to create a new folder"), action: #selector(newFolder))

        let rename = menuItem(String(localized: "rename", comment: "Context menu option to rename file or folder"), action: #selector(renameFile))

        let trash = menuItem(String(localized: "move_to_trash", comment: "Context menu option to move file to trash"), action:
                                item.url != workspace?.workspaceFileManager?.folderUrl
                              ? #selector(trash) : nil)

        // trash has to be the previous menu item for delete.isAlternate to work correctly
        let delete = menuItem(String(localized: "delete_immediately", comment: "Context menu option to delete file permanently"), action:
                                item.url != workspace?.workspaceFileManager?.folderUrl
                              ? #selector(delete) : nil)
        delete.keyEquivalentModifierMask = .option
        delete.isAlternate = true

        let duplicate = menuItem(String(localized: "duplicate_\(item.isString(localized: "folder", comment: "Generic term for folder") ? "folder" : "file")", comment: "Context menu option to duplicate folder or file"), action: #selector(duplicate))

        let sortByName = menuItem(String(localized: "sort_by_name", comment: "Context menu option to sort files by name"), action: nil)
        sortByName.isEnabled = item.isFolder

        let sortByType = menuItem(String(localized: "sort_by_type", comment: "Context menu option to sort files by type"), action: nil)
        sortByType.isEnabled = item.isFolder

        let sourceControl = menuItem(String(localized: "source_control", comment: "Context menu section for source control options"), action: nil)

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
            items.append(menuItem(String(localized: "new_folder_from_selection", comment: "Context menu option to create folder from selected items"), action: #selector(newFolderFromSelection)))
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
        let openAsMenu = NSMenu(title: String(localized: "open_as", comment: "Submenu title for opening file in different formats"))
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
                primaryItems.append(NSMenuItem(title: String(localized: "asset_catalog_document", comment: "File type option for opening as asset catalog"), action: nil, keyEquivalent: ""))
            }
            if type.conforms(to: UTType(filenameExtension: "xib")!) {
                primaryItems.append(NSMenuItem(title: String(localized: "interface_builder_xib_document", comment: "File type option for opening as XIB document"), action: nil, keyEquivalent: ""))
            }
            if type.conforms(to: UTType(filenameExtension: "xcodeproj")!) {
                primaryItems.append(NSMenuItem(title: String(localized: "xcode_project", comment: "Menu item for opening as Xcode project"), action: nil, keyEquivalent: ""))
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
        let sourceControlMenu = NSMenu(title: String(localized: "source_control", comment: "Source control menu title"))
        sourceControlMenu.addItem(
            withTitle: String(localized: "commit_file", comment: "Commit specific file menu item").replacingOccurrences(of: "{filename}", with: "\(String(describing: item.fileName()))"),
            action: nil,
            keyEquivalent: ""
        )
        sourceControlMenu.addItem(.separator())
        sourceControlMenu.addItem(withTitle: String(localized: "discard_changes", comment: "Discard changes menu item"), action: nil, keyEquivalent: "")
        sourceControlMenu.addItem(.separator())
        sourceControlMenu.addItem(withTitle: String(localized: "add_selected_files", comment: "Add selected files to source control"), action: nil, keyEquivalent: "")
        sourceControlMenu.addItem(withTitle: String(localized: "mark_files_resolved", comment: "Mark selected files as resolved in source control"), action: nil, keyEquivalent: "")

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
        let item = NSMenuItem(title: String(localized: "none", comment: "No selection placeholder"), action: nil, keyEquivalent: "")
        item.isEnabled = false
        return item
    }

    fileprivate static func sourceCode() -> NSMenuItem {
        NSMenuItem(title: String(localized: "source_code", comment: "Source code file type"), action: nil, keyEquivalent: "")
    }

    fileprivate static func propertyList() -> NSMenuItem {
        NSMenuItem(title: String(localized: "property_list", comment: "Property list file type"), action: nil, keyEquivalent: "")
    }

    fileprivate static func asciiPropertyList() -> NSMenuItem {
        NSMenuItem(title: String(localized: "ascii_property_list", comment: "ASCII property list file type"), action: nil, keyEquivalent: "")
    }

    fileprivate static func hex() -> NSMenuItem {
        NSMenuItem(title: String(localized: "hex", comment: "Hex viewer option in Open As menu"), action: nil, keyEquivalent: "")
    }

    fileprivate static func quickLook() -> NSMenuItem {
        NSMenuItem(title: String(localized: "quick_look", comment: "Quick Look option in Open As menu"), action: nil, keyEquivalent: "")
    }
}
