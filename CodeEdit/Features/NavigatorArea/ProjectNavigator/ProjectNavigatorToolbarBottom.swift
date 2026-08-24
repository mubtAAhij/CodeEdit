//
//  ProjectNavigatorToolbarBottom.swift
//  CodeEdit
//
//  Created by TAY KAI QUAN on 23/7/22.
//

import SwiftUI

struct ProjectNavigatorToolbarBottom: View {
    @Environment(\.controlActiveState)
    private var activeState

    @Environment(\.colorScheme)
    private var colorScheme

    @EnvironmentObject var workspace: WorkspaceDocument
    @EnvironmentObject var editorManager: EditorManager

    @State var recentsFilter: Bool = false

    var body: some View {
        HStack(spacing: 5) {
            addNewFileButton
            PaneTextField(
                String(localized: "project_navigator.filter", defaultValue: "Filter", comment: "Label for project navigator filter menu"),
                text: $workspace.navigatorFilter,
                leadingAccessories: {
                    FilterDropDownIconButton(menu: {
                        ForEach([(true, String(localized: "project_navigator.sort.folders_on_top", defaultValue: "Folders on top", comment: "Sort option to show folders before files in project navigator")), (false, String(localized: "project_navigator.sort.alphabetically", defaultValue: "Alphabetically", comment: "Sort option to order items alphabetically in project navigator"))], id: \.0) { value, title in
                            Toggle(title, isOn: Binding(get: {
                                workspace.sortFoldersOnTop == value
                            }, set: { _ in
                                // Avoid calling the handleFilterChange method
                                if workspace.sortFoldersOnTop != value {
                                    workspace.sortFoldersOnTop = value
                                }
                            }))
                        }
                    }, isOn: !workspace.navigatorFilter.isEmpty)
                        .padding(.leading, 4)
                        .foregroundStyle(
                            workspace.navigatorFilter.isEmpty
                                ? Color(nsColor: .secondaryLabelColor)
                                : Color(nsColor: .controlAccentColor)
                        )
                        .help(String(localized: "project_navigator.filter.matching_name", defaultValue: "Show files with matching name", comment: "Filter option to show only files with names matching the query"))
                },
                trailingAccessories: {
                    HStack(spacing: 0) {
                        Toggle(isOn: $recentsFilter) {
                            Image(systemName: "clock")
                        }
                        .help(String(localized: "project_navigator.filter.recent_files", defaultValue: "Show only recent files", comment: "Filter option to show only recently opened files"))
                        Toggle(isOn: $workspace.sourceControlFilter) {
                            Image(systemName: "plusminus.circle")
                        }
                        .help(String(localized: "project_navigator.filter.source_control_status", defaultValue: "Show only files with source-control status", comment: "Filter option to show only files that have source control status"))
                    }
                    .toggleStyle(.icon(font: .system(size: 14), size: CGSize(width: 18, height: 20)))
                    .padding(.trailing, 2.5)
                },
                clearable: true,
                hasValue: !workspace.navigatorFilter.isEmpty || recentsFilter || workspace.sourceControlFilter
            )
        }
        .padding(.horizontal, 5)
        .frame(height: 28, alignment: .center)
        .frame(maxWidth: .infinity)
        .overlay(alignment: .top) {
            Divider()
        }
    }

    /// Retrieves the active tab URL from the underlying editor instance, if theres no
    /// active tab, fallbacks to the workspace's root directory
    private func activeTabURL() -> URL {
        if let selectedTab = editorManager.activeEditor.selectedTab {
            if selectedTab.file.isFolder {
                return selectedTab.file.url
            }

            // If the current active tab belongs to a file, pop the filename from
            // the path URL to retrieve the folder URL
            let activeTabFileURL = selectedTab.file.url

            if URLComponents(url: activeTabFileURL, resolvingAgainstBaseURL: false) != nil {
                var pathComponents = activeTabFileURL.pathComponents
                pathComponents.removeLast()

                return NSURL.fileURL(withPathComponents: pathComponents)! as URL
            }
        }

        return workspace.workspaceFileManager.unsafelyUnwrapped.folderUrl
    }

    private var addNewFileButton: some View {
        Menu {
            Button(String(localized: "project_navigator.add_file", defaultValue: "Add File", comment: "Action title to add a new file from project navigator")) {
                let filePathURL = activeTabURL()
                guard let rootFile = workspace.workspaceFileManager?.getFile(filePathURL.path) else { return }
                do {
                    if let newFile = try workspace.workspaceFileManager?.addFile(
                        fileName: String(localized: "project_navigator.new_file.default_name", defaultValue: "untitled", comment: "Default filename placeholder for new file creation"),
                        toFile: rootFile
                    ) {
                        workspace.listenerModel.highlightedFileItem = newFile
                        workspace.editorManager?.openTab(item: newFile)
                    }
                } catch {
                    let alert = NSAlert(error: error)
                    alert.addButton(withTitle: String(localized: "project_navigator.dismiss", defaultValue: "Dismiss", comment: "Button title to dismiss the add file popover"))
                    alert.runModal()
                }
            }

            Button(String(localized: "project_navigator.add_folder", defaultValue: "Add Folder", comment: "Action title to add a new folder from project navigator")) {
                let filePathURL = activeTabURL()
                guard let rootFile = workspace.workspaceFileManager?.getFile(filePathURL.path) else { return }
                do {
                    if let newFolder = try workspace.workspaceFileManager?.addFolder(
                        folderName: String(localized: "project_navigator.add_folder.default_name", defaultValue: "untitled", comment: "Default name placeholder for newly created folder in project navigator"),
                        toFile: rootFile
                    ) {
                        workspace.listenerModel.highlightedFileItem = newFolder
                    }
                } catch {
                    let alert = NSAlert(error: error)
                    alert.addButton(withTitle: String(localized: "project_navigator.add_folder.dismiss", defaultValue: "Dismiss", comment: "Button title to dismiss add folder prompt"))
                    alert.runModal()
                }
            }
        } label: {}
            .background {
                Image(systemName: "plus")
                    .accessibilityHidden(true)
            }
            .menuStyle(.borderlessButton)
            .menuIndicator(.hidden)
            .frame(maxWidth: 18, alignment: .center)
            .opacity(activeState == .inactive ? 0.45 : 1)
            .accessibilityLabel(String(localized: "project_navigator.add_folder_or_file", defaultValue: "Add Folder or File", comment: "Action title to add a folder or file from project navigator toolbar"))
            .accessibilityIdentifier("addButton")
    }

    /// We clear the text and remove the first responder which removes the cursor
    /// when the user clears the filter.
    private var clearFilterButton: some View {
        Button {
            workspace.navigatorFilter = ""
            NSApp.keyWindow?.makeFirstResponder(nil)
        } label: {
            Image(systemName: "xmark.circle.fill")
                .symbolRenderingMode(.hierarchical)
        }
        .buttonStyle(.plain)
        .opacity(activeState == .inactive ? 0.45 : 1)
    }
}

struct FilterDropDownIconButton<MenuView: View>: View {
    @Environment(\.controlActiveState)
    private var activeState

    var menu: () -> MenuView

    var isOn: Bool?

    var body: some View {
        Menu { menu() } label: {}
            .background {
                if isOn == true {
                    Image(ImageResource.line3HorizontalDecreaseChevronFilled)
                        .foregroundStyle(.tint)
                } else {
                    Image(ImageResource.line3HorizontalDecreaseChevron)
                }
            }
            .menuStyle(.borderlessButton)
            .menuIndicator(.hidden)
            .frame(width: 26, height: 13)
            .clipShape(.rect(cornerRadius: 6.5))
    }
}
