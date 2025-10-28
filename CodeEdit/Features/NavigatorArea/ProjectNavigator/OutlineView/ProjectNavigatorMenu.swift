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
        super.init(title: String(localized: "menu.options", comment: "Menu title"))
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
        let showInFinder = menuItem(String(localized: "menu.show_in_finder", comment: "Menu item"), action: #selector(showInFinder))

        let openInTab = menuItem(String(localized: "menu.open_in_tab", comment: "Menu item"), action: #selector(openInTab))
        let openInNewWindow = menuItem(String(localized: "menu.open_in_new_window", comment: "Menu item"), action: nil)
        let openExternalEditor = menuItem(String(localized: "menu.open_with_external_editor", comment: "Menu item"), action: #selector(openWithExternalEditor))
        let openAs = menuItem(String(localized: "menu.open_as", comment: "Menu item"), action: nil)

        let copyPath = menuItem(String(localized: "menu.copy_path", comment: "Menu item"), action: #selector(copyPath))
        let copyRelativePath = menuItem(String(localized: "menu.copy_relative_path", comment: "Menu item"), action: #selector(copyRelativePath))

        let showFileInspector = menuItem(String(localized: "menu.show_file_inspector", comment: "Menu item"), action: nil)

        let newFile = menuItem(String(localized: "menu.new_file", comment: "Menu item"), action: #selector(newFile))
        let newFileFromClipboard = menuItem(
            String(localized: "menu.new_file_from_clipboard", comment: "Menu item"),
            action: #selector(newFileFromClipboard),
            key: "v"
        )
        newFileFromClipboard.keyEquivalentModifierMask = [.command]
        let newFolder = menuItem(String(localized: "menu.new_folder", comment: "Menu item"), action: #selector(newFolder))

        let rename = menuItem(String(localized: "menu.rename", comment: "Menu item"), action: #selector(renameFile))

        let trash = menuItem(String(localized: "menu.move_to_trash", comment: "Menu item"), action:
                                item.url != workspace?.workspaceFileManager?.folderUrl
                              ? #selector(trash) : nil)

        // trash has to be the previous menu item for delete.isAlternate to work correctly
        let delete = menuItem(String(localized: "menu.delete_immediately", comment: "Menu item"), action:
                                item.url != workspace?.workspaceFileManager?.folderUrl
                              ? #selector(delete) : nil)
        delete.keyEquivalentModifierMask = .option
        delete.isAlternate = true

        let duplicate = menuItem(String(localized: "menu.duplicate \(item.isFolder ? "Folder" : "File")", comment: "Menu item"), action: #selector(duplicate))

        let sortByName = menuItem(String(localized: "menu.sort_by_name", comment: "Menu item"), action: nil)
        sortByName.isEnabled = item.isFolder

        let sortByType = menuItem(String(localized: "menu.sort_by_type", comment: "Menu item"), action: nil)
        sortByType.isEnabled = item.isFolder

        let sourceControl = menuItem(String(localized: "menu.source_control", comment: "Menu item"), action: nil)

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
            items.append(menuItem(String(localized: "menu.new_folder_from_selection", comment: "Menu item"), action: #selector(newFolderFromSelection)))
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
        let openAsMenu = NSMenu(title: String(localized: "menu.open_as", comment: "Menu title"))
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
                primaryItems.append(NSMenuItem(title: String(localized: "menu.asset_catalog_document", comment: "Menu item"), action: nil, keyEquivalent: ""))
            }
            if type.conforms(to: UTType(filenameExtension: "xib")!) {
                primaryItems.append(NSMenuItem(title: String(localized: "menu.interface_builder_xib_document", comment: "Menu item"), action: nil, keyEquivalent: ""))
            }
            if type.conforms(to: UTType(filenameExtension: "xcodeproj")!) {
                primaryItems.append(NSMenuItem(title: String(localized: "menu.xcode_project", comment: "Menu item"), action: nil, keyEquivalent: ""))
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
        let sourceControlMenu = NSMenu(title: String(localized: "menu.source_control", comment: "Menu title"))
        sourceControlMenu.addItem(
            withTitle: String(localized: "menu.commit \"\(String(describing: item.fileName()))\"", comment: "Menu item"),
            action: nil,
            keyEquivalent: ""
        )
        sourceControlMenu.addItem(.separator())
        sourceControlMenu.addItem(withTitle: String(localized: "menu.discard_changes", comment: "Menu item"), action: nil, keyEquivalent: "")
        sourceControlMenu.addItem(.separator())
        sourceControlMenu.addItem(withTitle: String(localized: "menu.add_selected_files", comment: "Menu item"), action: nil, keyEquivalent: "")
        sourceControlMenu.addItem(withTitle: String(localized: "menu.mark_selected_files_as_resolved", comment: "Menu item"), action: nil, keyEquivalent: "")

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
        let item = NSMenuItem(title: String(localized: "menu.none", comment: "Menu item"), action: nil, keyEquivalent: "")
        item.isEnabled = false
        return item
    }

    fileprivate static func sourceCode() -> NSMenuItem {
        NSMenuItem(title: String(localized: "menu.source_code", comment: "Menu item"), action: nil, keyEquivalent: "")
    }

    fileprivate static func propertyList() -> NSMenuItem {
        NSMenuItem(title: String(localized: "menu.property_list", comment: "Menu item"), action: nil, keyEquivalent: "")
    }

    fileprivate static func asciiPropertyList() -> NSMenuItem {
        NSMenuItem(title: String(localized: "menu.ascii_property_list", comment: "Menu item"), action: nil, keyEquivalent: "")
    }

    fileprivate static func hex() -> NSMenuItem {
        NSMenuItem(title: String(localized: "menu.hex", comment: "Menu item"), action: nil, keyEquivalent: "")
    }

    fileprivate static func quickLook() -> NSMenuItem {
        NSMenuItem(title: String(localized: "menu.quick_look", comment: "Menu item"), action: nil, keyEquivalent: "")
    }
}
