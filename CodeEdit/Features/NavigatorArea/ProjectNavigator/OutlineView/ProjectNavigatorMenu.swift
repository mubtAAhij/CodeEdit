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
        super.init(title: String(localized: "Options", comment: "Menu title for project navigator context menu"))
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
        let showInFinder = menuItem(String(localized: "Show in Finder", comment: "Menu item to reveal file in Finder"), action: #selector(showInFinder))

        let openInTab = menuItem(String(localized: "Open in Tab", comment: "Menu item to open file in a new tab"), action: #selector(openInTab))
        let openInNewWindow = menuItem(String(localized: "Open in New Window", comment: "Menu item to open file in a new window"), action: nil)
        let openExternalEditor = menuItem(String(localized: "Open with External Editor", comment: "Menu item to open file with external editor"), action: #selector(openWithExternalEditor))
        let openAs = menuItem(String(localized: "Open As", comment: "Menu item to open file as different type"), action: nil)

        let copyPath = menuItem(String(localized: "Copy Path", comment: "Menu item to copy absolute file path"), action: #selector(copyPath))
        let copyRelativePath = menuItem(String(localized: "Copy Relative Path", comment: "Menu item to copy relative file path"), action: #selector(copyRelativePath))

        let showFileInspector = menuItem(String(localized: "Show File Inspector", comment: "Menu item to show file inspector"), action: nil)

        let newFile = menuItem(String(localized: "New File...", comment: "Menu item to create a new file"), action: #selector(newFile))
        let newFileFromClipboard = menuItem(
            String(localized: "New File from Clipboard", comment: "Menu item to create a new file from clipboard contents"),
            action: #selector(newFileFromClipboard),
            key: "v"
        )
        newFileFromClipboard.keyEquivalentModifierMask = [.command]
        let newFolder = menuItem(String(localized: "New Folder", comment: "Menu item to create a new folder"), action: #selector(newFolder))

        let rename = menuItem(String(localized: "Rename", comment: "Menu item to rename file or folder"), action: #selector(renameFile))

        let trash = menuItem(String(localized: "Move to Trash", comment: "Menu item to move file to trash"), action:
                                item.url != workspace?.workspaceFileManager?.folderUrl
                              ? #selector(trash) : nil)

        // trash has to be the previous menu item for delete.isAlternate to work correctly
        let delete = menuItem(String(localized: "Delete Immediately...", comment: "Menu item to delete file immediately without moving to trash"), action:
                                item.url != workspace?.workspaceFileManager?.folderUrl
                              ? #selector(delete) : nil)
        delete.keyEquivalentModifierMask = .option
        delete.isAlternate = true

        let duplicate = menuItem(item.isFolder ? String(localized: "Duplicate Folder", comment: "Menu item to duplicate a folder") : String(localized: "Duplicate File", comment: "Menu item to duplicate a file"), action: #selector(duplicate))

        let sortByName = menuItem(String(localized: "Sort by Name", comment: "Menu item to sort items alphabetically by name"), action: nil)
        sortByName.isEnabled = item.isFolder

        let sortByType = menuItem(String(localized: "Sort by Type", comment: "Menu item to sort items by file type"), action: nil)
        sortByType.isEnabled = item.isFolder

        let sourceControl = menuItem(String(localized: "Source Control", comment: "Menu item for source control options"), action: nil)

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
            items.append(menuItem(String(localized: "New Folder from Selection", comment: "Menu item to create a new folder from selected files"), action: #selector(newFolderFromSelection)))
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
        let openAsMenu = NSMenu(title: String(localized: "Open As", comment: "Submenu title for open as options"))
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
                primaryItems.append(NSMenuItem(title: String(localized: "Asset Catalog Document", comment: "Menu item to open file as Asset Catalog"), action: nil, keyEquivalent: ""))
            }
            if type.conforms(to: UTType(filenameExtension: "xib")!) {
                primaryItems.append(NSMenuItem(title: String(localized: "Interface Builder XIB Document", comment: "Menu item to open file as Interface Builder XIB"), action: nil, keyEquivalent: ""))
            }
            if type.conforms(to: UTType(filenameExtension: "xcodeproj")!) {
                primaryItems.append(NSMenuItem(title: String(localized: "Xcode Project", comment: "Menu item to open file as Xcode Project"), action: nil, keyEquivalent: ""))
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
        let sourceControlMenu = NSMenu(title: String(localized: "Source Control", comment: "Submenu title for source control options"))
        sourceControlMenu.addItem(
            withTitle: String(localized: "Commit \"\(String(describing: item.fileName()))\"...", comment: "Menu item to commit a file with its name"),
            action: nil,
            keyEquivalent: ""
        )
        sourceControlMenu.addItem(.separator())
        sourceControlMenu.addItem(withTitle: String(localized: "Discard Changes...", comment: "Menu item to discard uncommitted changes"), action: nil, keyEquivalent: "")
        sourceControlMenu.addItem(.separator())
        sourceControlMenu.addItem(withTitle: String(localized: "Add Selected Files", comment: "Menu item to add selected files to source control"), action: nil, keyEquivalent: "")
        sourceControlMenu.addItem(withTitle: String(localized: "Mark Selected Files as Resolved", comment: "Menu item to mark selected files as resolved in source control"), action: nil, keyEquivalent: "")

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
        let item = NSMenuItem(title: String(localized: "<None>", comment: "Menu item placeholder for no selection"), action: nil, keyEquivalent: "")
        item.isEnabled = false
        return item
    }

    fileprivate static func sourceCode() -> NSMenuItem {
        NSMenuItem(title: String(localized: "Source Code", comment: "Menu item to open file as source code"), action: nil, keyEquivalent: "")
    }

    fileprivate static func propertyList() -> NSMenuItem {
        NSMenuItem(title: String(localized: "Property List", comment: "Menu item to open file as property list"), action: nil, keyEquivalent: "")
    }

    fileprivate static func asciiPropertyList() -> NSMenuItem {
        NSMenuItem(title: String(localized: "ASCII Property List", comment: "Menu item to open file as ASCII property list"), action: nil, keyEquivalent: "")
    }

    fileprivate static func hex() -> NSMenuItem {
        NSMenuItem(title: String(localized: "Hex", comment: "Menu item to open file as hexadecimal"), action: nil, keyEquivalent: "")
    }

    fileprivate static func quickLook() -> NSMenuItem {
        NSMenuItem(title: String(localized: "Quick Look", comment: "Menu item to open file with Quick Look"), action: nil, keyEquivalent: "")
    }
}
