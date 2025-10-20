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
        super.init(title: String(localized: "projectNavigatorMenu.options", comment: "Context menu title"))
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
        let showInFinder = menuItem(String(localized: "projectNavigatorMenu.showInFinder", comment: "Context menu item"), action: #selector(showInFinder))

        let openInTab = menuItem(String(localized: "projectNavigatorMenu.openInTab", comment: "Context menu item"), action: #selector(openInTab))
        let openInNewWindow = menuItem(String(localized: "projectNavigatorMenu.openInNewWindow", comment: "Context menu item"), action: nil)
        let openExternalEditor = menuItem(String(localized: "projectNavigatorMenu.openWithExternalEditor", comment: "Context menu item"), action: #selector(openWithExternalEditor))
        let openAs = menuItem(String(localized: "projectNavigatorMenu.openAs", comment: "Context menu item"), action: nil)

        let copyPath = menuItem(String(localized: "projectNavigatorMenu.copyPath", comment: "Context menu item"), action: #selector(copyPath))
        let copyRelativePath = menuItem(String(localized: "projectNavigatorMenu.copyRelativePath", comment: "Context menu item"), action: #selector(copyRelativePath))

        let showFileInspector = menuItem(String(localized: "projectNavigatorMenu.showFileInspector", comment: "Context menu item"), action: nil)

        let newFile = menuItem(String(localized: "projectNavigatorMenu.newFile", comment: "Context menu item"), action: #selector(newFile))
        let newFileFromClipboard = menuItem(
            String(localized: "projectNavigatorMenu.newFileFromClipboard", comment: "Context menu item"),
            action: #selector(newFileFromClipboard),
            key: "v"
        )
        newFileFromClipboard.keyEquivalentModifierMask = [.command]
        let newFolder = menuItem(String(localized: "projectNavigatorMenu.newFolder", comment: "Context menu item"), action: #selector(newFolder))

        let rename = menuItem(String(localized: "projectNavigatorMenu.rename", comment: "Context menu item"), action: #selector(renameFile))

        let trash = menuItem(String(localized: "projectNavigatorMenu.moveToTrash", comment: "Context menu item"), action:
                                item.url != workspace?.workspaceFileManager?.folderUrl
                              ? #selector(trash) : nil)

        // trash has to be the previous menu item for delete.isAlternate to work correctly
        let delete = menuItem(String(localized: "projectNavigatorMenu.deleteImmediately", comment: "Context menu item"), action:
                                item.url != workspace?.workspaceFileManager?.folderUrl
                              ? #selector(delete) : nil)
        delete.keyEquivalentModifierMask = .option
        delete.isAlternate = true

        let itemType = item.isFolder ? String(localized: "projectNavigatorMenu.folder", comment: "Item type") : String(localized: "projectNavigatorMenu.file", comment: "Item type")
        let duplicate = menuItem(String(localized: "projectNavigatorMenu.duplicate", comment: "Context menu item", arguments: itemType), action: #selector(duplicate))

        let sortByName = menuItem(String(localized: "projectNavigatorMenu.sortByName", comment: "Context menu item"), action: nil)
        sortByName.isEnabled = item.isFolder

        let sortByType = menuItem(String(localized: "projectNavigatorMenu.sortByType", comment: "Context menu item"), action: nil)
        sortByType.isEnabled = item.isFolder

        let sourceControl = menuItem(String(localized: "projectNavigatorMenu.sourceControl", comment: "Context menu item"), action: nil)

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
            items.append(menuItem(String(localized: "projectNavigatorMenu.newFolderFromSelection", comment: "Context menu item"), action: #selector(newFolderFromSelection)))
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
        let openAsMenu = NSMenu(title: String(localized: "projectNavigatorMenu.openAs", comment: "Context menu item"))
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
                primaryItems.append(NSMenuItem(title: String(localized: "projectNavigatorMenu.assetCatalogDocument", comment: "Context menu item"), action: nil, keyEquivalent: ""))
            }
            if type.conforms(to: UTType(filenameExtension: "xib")!) {
                primaryItems.append(NSMenuItem(title: String(localized: "projectNavigatorMenu.interfaceBuilderXIB", comment: "Context menu item"), action: nil, keyEquivalent: ""))
            }
            if type.conforms(to: UTType(filenameExtension: "xcodeproj")!) {
                primaryItems.append(NSMenuItem(title: String(localized: "projectNavigatorMenu.xcodeProject", comment: "Context menu item"), action: nil, keyEquivalent: ""))
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
        let sourceControlMenu = NSMenu(title: String(localized: "projectNavigatorMenu.sourceControl", comment: "Context menu item"))
        sourceControlMenu.addItem(
            withTitle: String(localized: "projectNavigatorMenu.commitFile", comment: "Context menu item", arguments: String(describing: item.fileName())),
            action: nil,
            keyEquivalent: ""
        )
        sourceControlMenu.addItem(.separator())
        sourceControlMenu.addItem(withTitle: String(localized: "projectNavigatorMenu.discardChanges", comment: "Context menu item"), action: nil, keyEquivalent: "")
        sourceControlMenu.addItem(.separator())
        sourceControlMenu.addItem(withTitle: String(localized: "projectNavigatorMenu.addSelectedFiles", comment: "Context menu item"), action: nil, keyEquivalent: "")
        sourceControlMenu.addItem(withTitle: String(localized: "projectNavigatorMenu.markSelectedFilesResolved", comment: "Context menu item"), action: nil, keyEquivalent: "")

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
        let item = NSMenuItem(title: String(localized: "projectNavigatorMenu.none", comment: "Context menu item"), action: nil, keyEquivalent: "")
        item.isEnabled = false
        return item
    }

    fileprivate static func sourceCode() -> NSMenuItem {
        NSMenuItem(title: String(localized: "projectNavigatorMenu.sourceCode", comment: "Context menu item"), action: nil, keyEquivalent: "")
    }

    fileprivate static func propertyList() -> NSMenuItem {
        NSMenuItem(title: String(localized: "projectNavigatorMenu.propertyList", comment: "Context menu item"), action: nil, keyEquivalent: "")
    }

    fileprivate static func asciiPropertyList() -> NSMenuItem {
        NSMenuItem(title: String(localized: "projectNavigatorMenu.asciiPropertyList", comment: "Context menu item"), action: nil, keyEquivalent: "")
    }

    fileprivate static func hex() -> NSMenuItem {
        NSMenuItem(title: String(localized: "projectNavigatorMenu.hex", comment: "Context menu item"), action: nil, keyEquivalent: "")
    }

    fileprivate static func quickLook() -> NSMenuItem {
        NSMenuItem(title: String(localized: "projectNavigatorMenu.quickLook", comment: "Context menu item"), action: nil, keyEquivalent: "")
    }
}
