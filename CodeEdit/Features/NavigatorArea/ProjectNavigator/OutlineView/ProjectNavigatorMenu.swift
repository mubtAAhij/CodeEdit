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
        super.init(title: String(localized: "navigator.project.context-menu.options.title", defaultValue: "Options", comment: "Title for project navigator context menu options submenu"))
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
        let showInFinder = menuItem(String(localized: "navigator.project.context-menu.show-in-finder.action", defaultValue: "Show in Finder", comment: "Context menu action to reveal selected item in Finder"), action: #selector(showInFinder))

        let openInTab = menuItem(String(localized: "navigator.project.context-menu.open-in-tab.action", defaultValue: "Open in Tab", comment: "Context menu action to open selected item in a tab"), action: #selector(openInTab))
        let openInNewWindow = menuItem(String(localized: "navigator.project.context-menu.open-in-new-window.action", defaultValue: "Open in New Window", comment: "Context menu action to open selected item in a new window"), action: nil)
        let openExternalEditor = menuItem(String(localized: "navigator.project.context-menu.open-with-external-editor.action", defaultValue: "Open with External Editor", comment: "Context menu action to open selected item with external editor"), action: #selector(openWithExternalEditor))
        let openAs = menuItem(String(localized: "navigator.project.context-menu.open-as.submenu", defaultValue: "Open As", comment: "Context menu submenu title for open-as actions"), action: nil)

        let copyPath = menuItem(String(localized: "navigator.project.context-menu.copy-path.action", defaultValue: "Copy Path", comment: "Context menu action to copy full file path"), action: #selector(copyPath))
        let copyRelativePath = menuItem(String(localized: "navigator.project.context-menu.copy-relative-path.action", defaultValue: "Copy Relative Path", comment: "Context menu action to copy relative file path"), action: #selector(copyRelativePath))

        let showFileInspector = menuItem(String(localized: "navigator.project.context-menu.show-file-inspector.action", defaultValue: "Show File Inspector", comment: "Context menu action to show file inspector"), action: nil)

        let newFile = menuItem(String(localized: "navigator.project.context-menu.new-file.action", defaultValue: "New File...", comment: "Context menu action to create a new file"), action: #selector(newFile))
        let newFileFromClipboard = menuItem(
            String(localized: "navigator.project.context-menu.new-file-from-clipboard.action", defaultValue: "New File from Clipboard", comment: "Context menu action to create new file from clipboard contents"),
            action: #selector(newFileFromClipboard),
            key: "v"
        )
        newFileFromClipboard.keyEquivalentModifierMask = [.command]
        let newFolder = menuItem(String(localized: "navigator.project.context-menu.new-folder.action", defaultValue: "New Folder", comment: "Context menu action to create a new folder"), action: #selector(newFolder))

        let rename = menuItem(String(localized: "navigator.project.context-menu.rename.action", defaultValue: "Rename", comment: "Context menu action to rename selected item"), action: #selector(renameFile))

        let trash = menuItem(String(localized: "navigator.project.context-menu.move-to-trash.action", defaultValue: "Move to Trash", comment: "Context menu action to move selected item to trash"), action:
                                item.url != workspace?.workspaceFileManager?.folderUrl
                              ? #selector(trash) : nil)

        // trash has to be the previous menu item for delete.isAlternate to work correctly
        let delete = menuItem(String(localized: "navigator.project.context-menu.delete-immediately.action", defaultValue: "Delete Immediately...", comment: "Context menu action to permanently delete selected item"), action:
                                item.url != workspace?.workspaceFileManager?.folderUrl
                              ? #selector(delete) : nil)
        delete.keyEquivalentModifierMask = .option
        delete.isAlternate = true

        let duplicate = menuItem(String(format: String(localized: "navigator.project.context-menu.duplicate-item.action", defaultValue: "Duplicate %@", comment: "Context menu action to duplicate selected folder or file"), (item.isFolder
            ? String(localized: "navigator.project.context-menu.duplicate-item.file-type.folder", defaultValue: String(localized: "navigator.project.context-menu.duplicate-folder.noun", defaultValue: "Folder", comment: "Noun used when duplicating a folder"), comment: "File type label for folder in duplicate-item action")
            : String(localized: "navigator.project.context-menu.duplicate-item.file-type.file", defaultValue: String(localized: "navigator.project.context-menu.duplicate-file.noun", defaultValue: "File", comment: "Noun used when duplicating a file"), comment: "File type label for file in duplicate-item action"))), action: #selector(duplicate))

        let sortByName = menuItem(String(localized: "navigator.project.context-menu.sort-by-name.action", defaultValue: "Sort by Name", comment: "Context menu action to sort items by name"), action: nil)
        sortByName.isEnabled = item.isFolder

        let sortByType = menuItem(String(localized: "navigator.project.context-menu.sort-by-type.action", defaultValue: "Sort by Type", comment: "Context menu action to sort items by type"), action: nil)
        sortByType.isEnabled = item.isFolder

        let sourceControl = menuItem(String(localized: "navigator.project.context-menu.source-control.submenu", defaultValue: "Source Control", comment: "Context menu submenu title for source control actions"), action: nil)

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
            items.append(menuItem(String(localized: "navigator.project.context-menu.new-folder-from-selection.action", defaultValue: "New Folder from Selection", comment: "Context menu action to create a new folder from selected items"), action: #selector(newFolderFromSelection)))
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
        let openAsMenu = NSMenu(title: String(localized: "navigator.project.context-menu.open-as.editor.submenu", defaultValue: "Open As", comment: "Context menu submenu title for opening file as a specific type"))
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
                primaryItems.append(NSMenuItem(title: String(localized: "navigator.project.context-menu.open-as.asset-catalog-document.option", defaultValue: "Asset Catalog Document", comment: "Open As option for asset catalog document type"), action: nil, keyEquivalent: ""))
            }
            if type.conforms(to: UTType(filenameExtension: "xib")!) {
                primaryItems.append(NSMenuItem(title: String(localized: "navigator.project.context-menu.open-as.interface-builder-xib-document.option", defaultValue: "Interface Builder XIB Document", comment: "Open As option for Interface Builder XIB document type"), action: nil, keyEquivalent: ""))
            }
            if type.conforms(to: UTType(filenameExtension: "xcodeproj")!) {
                primaryItems.append(NSMenuItem(title: String(localized: "navigator.project.context-menu.open-as.xcode-project.option", defaultValue: "Xcode Project", comment: "Open As option for Xcode project document type"), action: nil, keyEquivalent: ""))
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
        let sourceControlMenu = NSMenu(title: String(localized: "navigator.project.context-menu.file.source-control.submenu", defaultValue: "Source Control", comment: "File context menu submenu title for source control actions"))
        sourceControlMenu.addItem(
            withTitle: String(format: String(localized: "navigator.project.context-menu.file.source-control.commit-file.action", defaultValue: "Commit \"%@\"...", comment: "Source control action to commit the selected file"), String(describing: item.fileName())),
            action: nil,
            keyEquivalent: ""
        )
        sourceControlMenu.addItem(.separator())
        sourceControlMenu.addItem(withTitle: String(localized: "navigator.project.context-menu.file.source-control.discard-changes.action", defaultValue: "Discard Changes...", comment: "Source control action to discard changes in selected file"), action: nil, keyEquivalent: "")
        sourceControlMenu.addItem(.separator())
        sourceControlMenu.addItem(withTitle: String(localized: "navigator.project.context-menu.file.source-control.add-selected-files.action", defaultValue: "Add Selected Files", comment: "Source control action to add selected files"), action: nil, keyEquivalent: "")
        sourceControlMenu.addItem(withTitle: String(localized: "navigator.project.context-menu.file.source-control.mark-selected-files-resolved.action", defaultValue: "Mark Selected Files as Resolved", comment: "Source control action to mark selected files as resolved"), action: nil, keyEquivalent: "")

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
        let item = NSMenuItem(title: String(localized: "navigator.project.context-menu.open-as.none.option", defaultValue: "<None>", comment: "Open As option representing no explicit file type"), action: nil, keyEquivalent: "")
        item.isEnabled = false
        return item
    }

    fileprivate static func sourceCode() -> NSMenuItem {
        NSMenuItem(title: String(localized: "navigator.project.context-menu.open-as.source-code.option", defaultValue: "Source Code", comment: "Open As option for source code file type"), action: nil, keyEquivalent: "")
    }

    fileprivate static func propertyList() -> NSMenuItem {
        NSMenuItem(title: String(localized: "navigator.project.context-menu.open-as.property-list.option", defaultValue: "Property List", comment: "Open As option for property list file type"), action: nil, keyEquivalent: "")
    }

    fileprivate static func asciiPropertyList() -> NSMenuItem {
        NSMenuItem(title: String(localized: "navigator.project.context-menu.open-as.ascii-property-list.option", defaultValue: "ASCII Property List", comment: "Open As option for ASCII property list file type"), action: nil, keyEquivalent: "")
    }

    fileprivate static func hex() -> NSMenuItem {
        NSMenuItem(title: String(localized: "navigator.project.context-menu.open-as.hex.option", defaultValue: "Hex", comment: "Open As option for hex view"), action: nil, keyEquivalent: "")
    }

    fileprivate static func quickLook() -> NSMenuItem {
        NSMenuItem(title: String(localized: "navigator.project.context-menu.open-as.quick-look.option", defaultValue: "Quick Look", comment: "Open As option for quick look preview"), action: nil, keyEquivalent: "")
    }
}
