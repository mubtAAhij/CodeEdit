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
        super.init(title: String(
            localized: "navigator.project.context-menu.options",
            defaultValue: "Options",
            comment: "Project navigator context menu section title for options"
        ))
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
        let showInFinder = menuItem(String(
            localized: "navigator.project.context-menu.show-in-finder",
            defaultValue: "Show in Finder",
            comment: "Context menu action to reveal item in Finder"
        ), action: #selector(showInFinder))

        let openInTab = menuItem(String(
            localized: "navigator.project.context-menu.open-in-tab",
            defaultValue: "Open in Tab",
            comment: "Context menu action to open selected item in a new tab"
        ), action: #selector(openInTab))
        let openInNewWindow = menuItem(String(
            localized: "navigator.project.context-menu.open-in-new-window",
            defaultValue: "Open in New Window",
            comment: "Context menu action to open selected item in a new window"
        ), action: nil)
        let openExternalEditor = menuItem(String(
            localized: "navigator.project.context-menu.open-with-external-editor",
            defaultValue: "Open with External Editor",
            comment: "Context menu action to open selected item with external editor"
        ), action: #selector(openWithExternalEditor))
        let openAs = menuItem(String(
            localized: "navigator.project.context-menu.open-as",
            defaultValue: "Open As",
            comment: "Context menu submenu title for opening item as specific type"
        ), action: nil)

        let copyPath = menuItem(String(
            localized: "navigator.project.context-menu.copy-path",
            defaultValue: "Copy Path",
            comment: "Context menu action to copy absolute path"
        ), action: #selector(copyPath))
        let copyRelativePath = menuItem(String(
            localized: "navigator.project.context-menu.copy-relative-path",
            defaultValue: "Copy Relative Path",
            comment: "Context menu action to copy path relative to workspace"
        ), action: #selector(copyRelativePath))

        let showFileInspector = menuItem(String(
            localized: "navigator.project.context-menu.show-file-inspector",
            defaultValue: "Show File Inspector",
            comment: "Context menu action to reveal file inspector"
        ), action: nil)

        let newFile = menuItem(String(
            localized: "navigator.project.context-menu.new-file",
            defaultValue: "New File...",
            comment: "Context menu action to create a new file"
        ), action: #selector(newFile))
        let newFileFromClipboard = menuItem(
            String(
                localized: "navigator.project.context-menu.new-file-from-clipboard",
                defaultValue: "New File from Clipboard",
                comment: "Context menu action to create a file from clipboard contents"
            ),
            action: #selector(newFileFromClipboard),
            key: "v"
        )
        newFileFromClipboard.keyEquivalentModifierMask = [.command]
        let newFolder = menuItem(String(
            localized: "navigator.project.context-menu.new-folder",
            defaultValue: "New Folder",
            comment: "Context menu action to create a new folder"
        ), action: #selector(newFolder))

        let rename = menuItem(String(
            localized: "navigator.project.context-menu.rename",
            defaultValue: "Rename",
            comment: "Context menu action to rename selected item"
        ), action: #selector(renameFile))

        let trash = menuItem(String(
            localized: "navigator.project.context-menu.move-to-trash",
            defaultValue: "Move to Trash",
            comment: "Context menu action to move selected item to trash"
        ), action:
                                item.url != workspace?.workspaceFileManager?.folderUrl
                              ? #selector(trash) : nil)

        // trash has to be the previous menu item for delete.isAlternate to work correctly
        let delete = menuItem(String(
            localized: "navigator.project.context-menu.delete-immediately",
            defaultValue: "Delete Immediately...",
            comment: "Context menu action to permanently delete selected item"
        ), action:
                                item.url != workspace?.workspaceFileManager?.folderUrl
                              ? #selector(delete) : nil)
        delete.keyEquivalentModifierMask = .option
        delete.isAlternate = true

        let duplicate = menuItem(String(format: String(
            localized: "navigator.project.context-menu.duplicate-item",
            defaultValue: "Duplicate %@",
            comment: "Context menu action to duplicate selected folder or file"
        ), (item.isFolder ? String(
            localized: "navigator.project.context-menu.duplicate-item.folder",
            defaultValue: "Folder",
            comment: "Noun used in duplicate action for folders"
        ) : String(
            localized: "navigator.project.context-menu.duplicate-item.file",
            defaultValue: "File",
            comment: "Noun used in duplicate action for files"
        ))), action: #selector(duplicate))

        let sortByName = menuItem(String(
            localized: "navigator.project.context-menu.sort-by-name",
            defaultValue: "Sort by Name",
            comment: "Context menu action to sort items by name"
        ), action: nil)
        sortByName.isEnabled = item.isFolder

        let sortByType = menuItem(String(
            localized: "navigator.project.context-menu.sort-by-type",
            defaultValue: "Sort by Type",
            comment: "Context menu action to sort items by type"
        ), action: nil)
        sortByType.isEnabled = item.isFolder

        let sourceControl = menuItem(String(
            localized: "navigator.project.context-menu.source-control",
            defaultValue: "Source Control",
            comment: "Project navigator context menu section title for source control actions"
        ), action: nil)

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
            items.append(menuItem(String(
                localized: "navigator.project.context-menu.new-folder-from-selection",
                defaultValue: "New Folder from Selection",
                comment: "Context menu action to create a folder from selected items"
            ), action: #selector(newFolderFromSelection)))
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
        let openAsMenu = NSMenu(title: String(
            localized: "navigator.project.context-menu.open-as-secondary",
            defaultValue: "Open As",
            comment: "Context menu submenu title for opening item as a specific type in secondary menu"
        ))
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
                primaryItems.append(NSMenuItem(title: String(
                    localized: "navigator.project.context-menu.open-as.asset-catalog-document",
                    defaultValue: "Asset Catalog Document",
                    comment: "Open As submenu option for Asset Catalog document"
                ), action: nil, keyEquivalent: ""))
            }
            if type.conforms(to: UTType(filenameExtension: "xib")!) {
                primaryItems.append(NSMenuItem(title: String(
                    localized: "navigator.project.context-menu.open-as.interface-builder-xib-document",
                    defaultValue: "Interface Builder XIB Document",
                    comment: "Open As submenu option for Interface Builder XIB document"
                ), action: nil, keyEquivalent: ""))
            }
            if type.conforms(to: UTType(filenameExtension: "xcodeproj")!) {
                primaryItems.append(NSMenuItem(title: String(
                    localized: "navigator.project.context-menu.open-as.xcode-project",
                    defaultValue: "Xcode Project",
                    comment: "Open As submenu option for Xcode project"
                ), action: nil, keyEquivalent: ""))
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
        let sourceControlMenu = NSMenu(title: String(
            localized: "navigator.project.context-menu.source-control-secondary",
            defaultValue: "Source Control",
            comment: "Project navigator context menu source control section title in secondary menu"
        ))
        sourceControlMenu.addItem(
            withTitle: String(format: String(
                localized: "navigator.project.context-menu.source-control.commit-file",
                defaultValue: "Commit \"%@\"...",
                comment: "Source control action to commit selected file by name"
            ), String(describing: item.fileName())),
            action: nil,
            keyEquivalent: ""
        )
        sourceControlMenu.addItem(.separator())
        sourceControlMenu.addItem(withTitle: String(
            localized: "navigator.project.context-menu.source-control.discard-changes",
            defaultValue: "Discard Changes...",
            comment: "Source control action to discard changes"
        ), action: nil, keyEquivalent: "")
        sourceControlMenu.addItem(.separator())
        sourceControlMenu.addItem(withTitle: String(
            localized: "navigator.project.context-menu.source-control.add-selected-files",
            defaultValue: "Add Selected Files",
            comment: "Source control action to add selected files"
        ), action: nil, keyEquivalent: "")
        sourceControlMenu.addItem(withTitle: String(
            localized: "navigator.project.context-menu.source-control.mark-selected-files-resolved",
            defaultValue: "Mark Selected Files as Resolved",
            comment: "Source control action to mark selected files as resolved"
        ), action: nil, keyEquivalent: "")

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
        let item = NSMenuItem(title: String(
            localized: "navigator.project.context-menu.open-as.none",
            defaultValue: "<None>",
            comment: "Open As submenu option for no explicit file type"
        ), action: nil, keyEquivalent: "")
        item.isEnabled = false
        return item
    }

    fileprivate static func sourceCode() -> NSMenuItem {
        NSMenuItem(title: String(
            localized: "navigator.project.context-menu.open-as.source-code",
            defaultValue: "Source Code",
            comment: "Open As submenu option for source code"
        ), action: nil, keyEquivalent: "")
    }

    fileprivate static func propertyList() -> NSMenuItem {
        NSMenuItem(title: String(
            localized: "navigator.project.context-menu.open-as.property-list",
            defaultValue: "Property List",
            comment: "Open As submenu option for property list"
        ), action: nil, keyEquivalent: "")
    }

    fileprivate static func asciiPropertyList() -> NSMenuItem {
        NSMenuItem(title: String(
            localized: "navigator.project.context-menu.open-as.ascii-property-list",
            defaultValue: "ASCII Property List",
            comment: "Open As submenu option for ASCII property list"
        ), action: nil, keyEquivalent: "")
    }

    fileprivate static func hex() -> NSMenuItem {
        NSMenuItem(title: String(
            localized: "navigator.project.context-menu.open-as.hex",
            defaultValue: "Hex",
            comment: "Open As submenu option for hex view"
        ), action: nil, keyEquivalent: "")
    }

    fileprivate static func quickLook() -> NSMenuItem {
        NSMenuItem(title: String(
            localized: "navigator.project.context-menu.open-as.quick-look",
            defaultValue: "Quick Look",
            comment: "Open As submenu option for Quick Look preview"
        ), action: nil, keyEquivalent: "")
    }
}
