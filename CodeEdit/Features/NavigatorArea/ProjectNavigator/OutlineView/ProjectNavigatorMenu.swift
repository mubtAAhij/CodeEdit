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
        super.init(title: String(localized: "project-navigator.options", defaultValue: "Options", comment: "Options menu title"))
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
        let showInFinder = menuItem(String(localized: "project-navigator.show-in-finder", defaultValue: "Show in Finder", comment: "Show in Finder menu item"), action: #selector(showInFinder))

        let openInTab = menuItem(String(localized: "project-navigator.open-in-tab", defaultValue: "Open in Tab", comment: "Open in tab menu item"), action: #selector(openInTab))
        let openInNewWindow = menuItem(String(localized: "project-navigator.open-in-new-window", defaultValue: "Open in New Window", comment: "Open in new window menu item"), action: nil)
        let openExternalEditor = menuItem(String(localized: "project-navigator.open-with-external-editor", defaultValue: "Open with External Editor", comment: "Open with external editor menu item"), action: #selector(openWithExternalEditor))
        let openAs = menuItem(String(localized: "project-navigator.open-as", defaultValue: "Open As", comment: "Open as menu item"), action: nil)

        let copyPath = menuItem(String(localized: "project-navigator.copy-path", defaultValue: "Copy Path", comment: "Copy path menu item"), action: #selector(copyPath))
        let copyRelativePath = menuItem(String(localized: "project-navigator.copy-relative-path", defaultValue: "Copy Relative Path", comment: "Copy relative path menu item"), action: #selector(copyRelativePath))

        let showFileInspector = menuItem(String(localized: "project-navigator.show-file-inspector", defaultValue: "Show File Inspector", comment: "Show file inspector menu item"), action: nil)

        let newFile = menuItem(String(localized: "project-navigator.new-file", defaultValue: "New File...", comment: "New file menu item"), action: #selector(newFile))
        let newFileFromClipboard = menuItem(
            String(localized: "project-navigator.new-file-from-clipboard", defaultValue: "New File from Clipboard", comment: "New file from clipboard menu item"),
            action: #selector(newFileFromClipboard),
            key: "v"
        )
        newFileFromClipboard.keyEquivalentModifierMask = [.command]
        let newFolder = menuItem(String(localized: "project-navigator.new-folder", defaultValue: "New Folder", comment: "New folder menu item"), action: #selector(newFolder))

        let rename = menuItem(String(localized: "project-navigator.rename", defaultValue: "Rename", comment: "Rename menu item"), action: #selector(renameFile))

        let trash = menuItem(String(localized: "project-navigator.move-to-trash", defaultValue: "Move to Trash", comment: "Move to trash menu item"), action:
                                item.url != workspace?.workspaceFileManager?.folderUrl
                              ? #selector(trash) : nil)

        // trash has to be the previous menu item for delete.isAlternate to work correctly
        let delete = menuItem(String(localized: "project-navigator.delete-immediately", defaultValue: "Delete Immediately...", comment: "Delete immediately menu item"), action:
                                item.url != workspace?.workspaceFileManager?.folderUrl
                              ? #selector(delete) : nil)
        delete.keyEquivalentModifierMask = .option
        delete.isAlternate = true

        let itemType = item.isFolder ? String(localized: "project-navigator.folder", defaultValue: "Folder", comment: "Folder type") : String(localized: "project-navigator.file", defaultValue: "File", comment: "File type")
        let duplicate = menuItem(String(format: NSLocalizedString("project-navigator.duplicate-item", comment: "Duplicate item menu"), itemType), action: #selector(duplicate))

        let sortByName = menuItem(String(localized: "project-navigator.sort-by-name", defaultValue: "Sort by Name", comment: "Sort by name menu item"), action: nil)
        sortByName.isEnabled = item.isFolder

        let sortByType = menuItem(String(localized: "project-navigator.sort-by-type", defaultValue: "Sort by Type", comment: "Sort by type menu item"), action: nil)
        sortByType.isEnabled = item.isFolder

        let sourceControl = menuItem(String(localized: "project-navigator.source-control", defaultValue: "Source Control", comment: "Source control menu item"), action: nil)

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
            items.append(menuItem(String(localized: "project-navigator.new-folder-from-selection", defaultValue: "New Folder from Selection", comment: "New folder from selection menu item"), action: #selector(newFolderFromSelection)))
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
        let openAsMenu = NSMenu(title: String(localized: "project-navigator.open-as", defaultValue: "Open As", comment: "Open as menu item"))
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
                primaryItems.append(NSMenuItem(title: String(localized: "project-navigator.asset-catalog-document", defaultValue: "Asset Catalog Document", comment: "Asset catalog document type"), action: nil, keyEquivalent: ""))
            }
            if type.conforms(to: UTType(filenameExtension: "xib")!) {
                primaryItems.append(NSMenuItem(title: String(localized: "project-navigator.interface-builder-xib", defaultValue: "Interface Builder XIB Document", comment: "Interface Builder XIB document type"), action: nil, keyEquivalent: ""))
            }
            if type.conforms(to: UTType(filenameExtension: "xcodeproj")!) {
                primaryItems.append(NSMenuItem(title: String(localized: "project-navigator.xcode-project", defaultValue: "Xcode Project", comment: "Xcode project type"), action: nil, keyEquivalent: ""))
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
        let sourceControlMenu = NSMenu(title: String(localized: "project-navigator.source-control", defaultValue: "Source Control", comment: "Source control menu item"))
        sourceControlMenu.addItem(
            withTitle: String(format: NSLocalizedString("project-navigator.commit-file", comment: "Commit file menu item"), String(describing: item.fileName())),
            action: nil,
            keyEquivalent: ""
        )
        sourceControlMenu.addItem(.separator())
        sourceControlMenu.addItem(withTitle: String(localized: "project-navigator.discard-changes", defaultValue: "Discard Changes...", comment: "Discard changes menu item"), action: nil, keyEquivalent: "")
        sourceControlMenu.addItem(.separator())
        sourceControlMenu.addItem(withTitle: String(localized: "project-navigator.add-selected-files", defaultValue: "Add Selected Files", comment: "Add selected files menu item"), action: nil, keyEquivalent: "")
        sourceControlMenu.addItem(withTitle: String(localized: "project-navigator.mark-files-resolved", defaultValue: "Mark Selected Files as Resolved", comment: "Mark selected files as resolved menu item"), action: nil, keyEquivalent: "")

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
        let item = NSMenuItem(title: String(localized: "project-navigator.none", defaultValue: "<None>", comment: "None option"), action: nil, keyEquivalent: "")
        item.isEnabled = false
        return item
    }

    fileprivate static func sourceCode() -> NSMenuItem {
        NSMenuItem(title: String(localized: "project-navigator.source-code", defaultValue: "Source Code", comment: "Source code file type"), action: nil, keyEquivalent: "")
    }

    fileprivate static func propertyList() -> NSMenuItem {
        NSMenuItem(title: String(localized: "project-navigator.property-list", defaultValue: "Property List", comment: "Property list file type"), action: nil, keyEquivalent: "")
    }

    fileprivate static func asciiPropertyList() -> NSMenuItem {
        NSMenuItem(title: String(localized: "project-navigator.ascii-property-list", defaultValue: "ASCII Property List", comment: "ASCII property list file type"), action: nil, keyEquivalent: "")
    }

    fileprivate static func hex() -> NSMenuItem {
        NSMenuItem(title: String(localized: "project-navigator.hex", defaultValue: "Hex", comment: "Hex file type"), action: nil, keyEquivalent: "")
    }

    fileprivate static func quickLook() -> NSMenuItem {
        NSMenuItem(title: String(localized: "project-navigator.quick-look", defaultValue: "Quick Look", comment: "Quick look file type"), action: nil, keyEquivalent: "")
    }
}
