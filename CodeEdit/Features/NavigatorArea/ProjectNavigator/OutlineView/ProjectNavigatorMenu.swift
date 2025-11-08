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
        super.init(title: String(localized: "project-navigator.menu.options", defaultValue: "Options", comment: "Title for project navigator context menu"))
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
        let showInFinder = menuItem(String(localized: "project-navigator.menu.show-in-finder", defaultValue: "Show in Finder", comment: "Menu item to show file in Finder"), action: #selector(showInFinder))

        let openInTab = menuItem(String(localized: "project-navigator.menu.open-in-tab", defaultValue: "Open in Tab", comment: "Menu item to open file in tab"), action: #selector(openInTab))
        let openInNewWindow = menuItem(String(localized: "project-navigator.menu.open-in-new-window", defaultValue: "Open in New Window", comment: "Menu item to open file in new window"), action: nil)
        let openExternalEditor = menuItem(String(localized: "project-navigator.menu.open-with-external-editor", defaultValue: "Open with External Editor", comment: "Menu item to open with external editor"), action: #selector(openWithExternalEditor))
        let openAs = menuItem(String(localized: "project-navigator.menu.open-as", defaultValue: "Open As", comment: "Menu item to open file as specific type"), action: nil)

        let copyPath = menuItem(String(localized: "project-navigator.menu.copy-path", defaultValue: "Copy Path", comment: "Menu item to copy file path"), action: #selector(copyPath))
        let copyRelativePath = menuItem(String(localized: "project-navigator.menu.copy-relative-path", defaultValue: "Copy Relative Path", comment: "Menu item to copy relative file path"), action: #selector(copyRelativePath))

        let showFileInspector = menuItem(String(localized: "project-navigator.menu.show-file-inspector", defaultValue: "Show File Inspector", comment: "Menu item to show file inspector"), action: nil)

        let newFile = menuItem(String(localized: "project-navigator.menu.new-file", defaultValue: "New File...", comment: "Menu item to create new file"), action: #selector(newFile))
        let newFileFromClipboard = menuItem(
            String(localized: "project-navigator.menu.new-file-from-clipboard", defaultValue: "New File from Clipboard", comment: "Menu item to create new file from clipboard"),
            action: #selector(newFileFromClipboard),
            key: "v"
        )
        newFileFromClipboard.keyEquivalentModifierMask = [.command]
        let newFolder = menuItem(String(localized: "project-navigator.menu.new-folder", defaultValue: "New Folder", comment: "Menu item to create new folder"), action: #selector(newFolder))

        let rename = menuItem(String(localized: "project-navigator.menu.rename", defaultValue: "Rename", comment: "Menu item to rename file"), action: #selector(renameFile))

        let trash = menuItem(String(localized: "project-navigator.menu.move-to-trash", defaultValue: "Move to Trash", comment: "Menu item to move file to trash"), action:
                                item.url != workspace?.workspaceFileManager?.folderUrl
                              ? #selector(trash) : nil)

        // trash has to be the previous menu item for delete.isAlternate to work correctly
        let delete = menuItem(String(localized: "project-navigator.menu.delete-immediately", defaultValue: "Delete Immediately...", comment: "Menu item to delete file immediately"), action:
                                item.url != workspace?.workspaceFileManager?.folderUrl
                              ? #selector(delete) : nil)
        delete.keyEquivalentModifierMask = .option
        delete.isAlternate = true

        let itemType = item.isFolder ? String(localized: "project-navigator.menu.folder", defaultValue: "Folder", comment: "Label for folder type") : String(localized: "project-navigator.menu.file", defaultValue: "File", comment: "Label for file type")
        let duplicate = menuItem(String(format: NSLocalizedString("project-navigator.menu.duplicate", comment: "Menu item to duplicate file or folder"), itemType), action: #selector(duplicate))

        let sortByName = menuItem(String(localized: "project-navigator.menu.sort-by-name", defaultValue: "Sort by Name", comment: "Menu item to sort by name"), action: nil)
        sortByName.isEnabled = item.isFolder

        let sortByType = menuItem(String(localized: "project-navigator.menu.sort-by-type", defaultValue: "Sort by Type", comment: "Menu item to sort by type"), action: nil)
        sortByType.isEnabled = item.isFolder

        let sourceControl = menuItem(String(localized: "project-navigator.menu.source-control", defaultValue: "Source Control", comment: "Menu item for source control"), action: nil)

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
            items.append(menuItem(String(localized: "project-navigator.menu.new-folder-from-selection", defaultValue: "New Folder from Selection", comment: "Menu item to create folder from selection"), action: #selector(newFolderFromSelection)))
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
        let openAsMenu = NSMenu(title: String(localized: "project-navigator.menu.open-as", defaultValue: "Open As", comment: "Menu item to open file as specific type"))
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
                primaryItems.append(NSMenuItem(title: String(localized: "project-navigator.menu.open-as.asset-catalog", defaultValue: "Asset Catalog Document", comment: "Open as asset catalog document"), action: nil, keyEquivalent: ""))
            }
            if type.conforms(to: UTType(filenameExtension: "xib")!) {
                primaryItems.append(NSMenuItem(title: String(localized: "project-navigator.menu.open-as.xib", defaultValue: "Interface Builder XIB Document", comment: "Open as XIB document"), action: nil, keyEquivalent: ""))
            }
            if type.conforms(to: UTType(filenameExtension: "xcodeproj")!) {
                primaryItems.append(NSMenuItem(title: String(localized: "project-navigator.menu.open-as.xcode-project", defaultValue: "Xcode Project", comment: "Open as Xcode project"), action: nil, keyEquivalent: ""))
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
        let sourceControlMenu = NSMenu(title: String(localized: "project-navigator.menu.source-control", defaultValue: "Source Control", comment: "Menu item for source control"))
        sourceControlMenu.addItem(
            withTitle: String(format: NSLocalizedString("project-navigator.menu.source-control.commit", comment: "Menu item to commit file"), String(describing: item.fileName())),
            action: nil,
            keyEquivalent: ""
        )
        sourceControlMenu.addItem(.separator())
        sourceControlMenu.addItem(withTitle: String(localized: "project-navigator.menu.source-control.discard-changes", defaultValue: "Discard Changes...", comment: "Menu item to discard changes"), action: nil, keyEquivalent: "")
        sourceControlMenu.addItem(.separator())
        sourceControlMenu.addItem(withTitle: String(localized: "project-navigator.menu.source-control.add-selected-files", defaultValue: "Add Selected Files", comment: "Menu item to add selected files"), action: nil, keyEquivalent: "")
        sourceControlMenu.addItem(withTitle: String(localized: "project-navigator.menu.source-control.mark-resolved", defaultValue: "Mark Selected Files as Resolved", comment: "Menu item to mark files as resolved"), action: nil, keyEquivalent: "")

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
        let item = NSMenuItem(title: String(localized: "project-navigator.menu.open-as.none", defaultValue: "<None>", comment: "No available open as options"), action: nil, keyEquivalent: "")
        item.isEnabled = false
        return item
    }

    fileprivate static func sourceCode() -> NSMenuItem {
        NSMenuItem(title: String(localized: "project-navigator.menu.open-as.source-code", defaultValue: "Source Code", comment: "Open as source code"), action: nil, keyEquivalent: "")
    }

    fileprivate static func propertyList() -> NSMenuItem {
        NSMenuItem(title: String(localized: "project-navigator.menu.open-as.property-list", defaultValue: "Property List", comment: "Open as property list"), action: nil, keyEquivalent: "")
    }

    fileprivate static func asciiPropertyList() -> NSMenuItem {
        NSMenuItem(title: String(localized: "project-navigator.menu.open-as.ascii-property-list", defaultValue: "ASCII Property List", comment: "Open as ASCII property list"), action: nil, keyEquivalent: "")
    }

    fileprivate static func hex() -> NSMenuItem {
        NSMenuItem(title: String(localized: "project-navigator.menu.open-as.hex", defaultValue: "Hex", comment: "Open as hex"), action: nil, keyEquivalent: "")
    }

    fileprivate static func quickLook() -> NSMenuItem {
        NSMenuItem(title: String(localized: "project-navigator.menu.open-as.quick-look", defaultValue: "Quick Look", comment: "Open with Quick Look"), action: nil, keyEquivalent: "")
    }
}
