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
        super.init(title: String(localized: "options", defaultValue: "Options", comment: "Options menu title", os_id: "102161"))
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
        let showInFinder = menuItem(String(localized: "show-in-finder", defaultValue: "Show in Finder", comment: "Show in Finder menu item", os_id: "101974"), action: #selector(showInFinder))

        let openInTab = menuItem(String(localized: "open-in-tab", defaultValue: "Open in Tab", comment: "Open in tab menu item", os_id: "102162"), action: #selector(openInTab))
        let openInNewWindow = menuItem(String(localized: "open-in-new-window", defaultValue: "Open in New Window", comment: "Open in new window menu item"), action: nil)
        let openExternalEditor = menuItem(String(localized: "open-with-external-editor", defaultValue: "Open with External Editor", comment: "Open with external editor menu item", os_id: "102163"), action: #selector(openWithExternalEditor))
        let openAs = menuItem(String(localized: "open-as", defaultValue: "Open As", comment: "Open as menu item"), action: nil)

        let copyPath = menuItem(String(localized: "copy-path", defaultValue: "Copy Path", comment: "Copy path menu item", os_id: "101972"), action: #selector(copyPath))
        let copyRelativePath = menuItem(String(localized: "copy-relative-path", defaultValue: "Copy Relative Path", comment: "Copy relative path menu item", os_id: "101973"), action: #selector(copyRelativePath))

        let showFileInspector = menuItem(String(localized: "show-file-inspector", defaultValue: "Show File Inspector", comment: "Show file inspector menu item", os_id: "102165"), action: nil)

        let newFile = menuItem(String(localized: "new-file", defaultValue: "New File...", comment: "New file menu item", os_id: "102166"), action: #selector(newFile))
        let newFileFromClipboard = menuItem(
            String(localized: "new-file-from-clipboard", defaultValue: "New File from Clipboard", comment: "New file from clipboard menu item", os_id: "102167"),
            action: #selector(newFileFromClipboard),
            key: "v"
        )
        newFileFromClipboard.keyEquivalentModifierMask = [.command]
        let newFolder = menuItem(String(localized: "new-folder", defaultValue: "New Folder", comment: "New folder menu item", os_id: "102168"), action: #selector(newFolder))

        let rename = menuItem(String(localized: "rename", defaultValue: "Rename", comment: "Rename menu item"), action: #selector(renameFile))

        let trash = menuItem(String(localized: "move-to-trash", defaultValue: "Move to Trash", comment: "Move to trash menu item", os_id: "102170"), action:
                                item.url != workspace?.workspaceFileManager?.folderUrl
                              ? #selector(trash) : nil)

        // trash has to be the previous menu item for delete.isAlternate to work correctly
        let delete = menuItem(String(localized: "delete-immediately", defaultValue: "Delete Immediately...", comment: "Delete immediately menu item", os_id: "102171"), action:
                                item.url != workspace?.workspaceFileManager?.folderUrl
                              ? #selector(delete) : nil)
        delete.keyEquivalentModifierMask = .option
        delete.isAlternate = true

        let duplicate = menuItem(String(format: String(localized: "duplicate-item", defaultValue: "Duplicate %@", comment: "Duplicate item menu item", os_id: "102172"), item.isFolder ? String(localized: "folder", defaultValue: "Folder", comment: "Folder label", os_id: "102173") : String(localized: "file", defaultValue: "File", comment: "File label", os_id: "102174")), action: #selector(duplicate))

        let sortByName = menuItem(String(localized: "sort-by-name", defaultValue: "Sort by Name", comment: "Sort by name menu item"), action: nil)
        sortByName.isEnabled = item.isFolder

        let sortByType = menuItem(String(localized: "sort-by-type", defaultValue: "Sort by Type", comment: "Sort by type menu item", os_id: "102176"), action: nil)
        sortByType.isEnabled = item.isFolder

        let sourceControl = menuItem(String(localized: "source-control", defaultValue: "Source Control", comment: "Source control menu item"), action: nil)

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
            items.append(menuItem(String(localized: "new-folder-from-selection", defaultValue: "New Folder from Selection", comment: "New folder from selection menu item", os_id: "102177"), action: #selector(newFolderFromSelection)))
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
        let openAsMenu = NSMenu(title: String(localized: "open-as", defaultValue: "Open As", comment: "Open as submenu title", os_id: "102164"))
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
                primaryItems.append(NSMenuItem(title: String(localized: "asset-catalog-document", defaultValue: "Asset Catalog Document", comment: "Asset catalog document menu item", os_id: "102178"), action: nil, keyEquivalent: ""))
            }
            if type.conforms(to: UTType(filenameExtension: "xib")!) {
                primaryItems.append(NSMenuItem(title: String(localized: "interface-builder-xib", defaultValue: "Interface Builder XIB Document", comment: "Interface builder XIB document menu item", os_id: "102179"), action: nil, keyEquivalent: ""))
            }
            if type.conforms(to: UTType(filenameExtension: "xcodeproj")!) {
                primaryItems.append(NSMenuItem(title: String(localized: "xcode-project", defaultValue: "Xcode Project", comment: "Xcode project menu item", os_id: "102180"), action: nil, keyEquivalent: ""))
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
        let sourceControlMenu = NSMenu(title: String(localized: "source-control", defaultValue: "Source Control", comment: "Source control submenu title"))
        sourceControlMenu.addItem(
            withTitle: String(format: String(localized: "commit-file", defaultValue: "Commit \"%@\"...", comment: "Commit file menu item", os_id: "102181"), String(describing: item.fileName())),
            action: nil,
            keyEquivalent: ""
        )
        sourceControlMenu.addItem(.separator())
        sourceControlMenu.addItem(withTitle: String(localized: "discard-changes", defaultValue: "Discard Changes...", comment: "Discard changes menu item", os_id: "102182"), action: nil, keyEquivalent: "")
        sourceControlMenu.addItem(.separator())
        sourceControlMenu.addItem(withTitle: String(localized: "add-selected-files", defaultValue: "Add Selected Files", comment: "Add selected files menu item", os_id: "102183"), action: nil, keyEquivalent: "")
        sourceControlMenu.addItem(withTitle: String(localized: "mark-files-resolved", defaultValue: "Mark Selected Files as Resolved", comment: "Mark selected files as resolved menu item", os_id: "102184"), action: nil, keyEquivalent: "")

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
        let item = NSMenuItem(title: String(localized: "none-option", defaultValue: "<None>", comment: "None option menu item", os_id: "102185"), action: nil, keyEquivalent: "")
        item.isEnabled = false
        return item
    }

    fileprivate static func sourceCode() -> NSMenuItem {
        NSMenuItem(title: String(localized: "source-code", defaultValue: "Source Code", comment: "Source code menu item", os_id: "102186"), action: nil, keyEquivalent: "")
    }

    fileprivate static func propertyList() -> NSMenuItem {
        NSMenuItem(title: String(localized: "property-list", defaultValue: "Property List", comment: "Property list menu item", os_id: "102187"), action: nil, keyEquivalent: "")
    }

    fileprivate static func asciiPropertyList() -> NSMenuItem {
        NSMenuItem(title: String(localized: "ascii-property-list", defaultValue: "ASCII Property List", comment: "ASCII property list menu item", os_id: "102188"), action: nil, keyEquivalent: "")
    }

    fileprivate static func hex() -> NSMenuItem {
        NSMenuItem(title: String(localized: "hex", defaultValue: "Hex", comment: "Hex menu item", os_id: "102189"), action: nil, keyEquivalent: "")
    }

    fileprivate static func quickLook() -> NSMenuItem {
        NSMenuItem(title: String(localized: "quick-look", defaultValue: "Quick Look", comment: "Quick look menu item", os_id: "102190"), action: nil, keyEquivalent: "")
    }
}
