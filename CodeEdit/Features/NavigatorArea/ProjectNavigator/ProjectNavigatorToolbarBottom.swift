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
                String(localized: "navigator.filter", comment: "Filter placeholder"),
                text: $workspace.navigatorFilter,
                leadingAccessories: {
                    FilterDropDownIconButton(menu: {
                        ForEach([(true, String(localized: "navigator.sort.folders_on_top", comment: "Sort option")), (false, String(localized: "navigator.sort.alphabetically", comment: "Sort option"))], id: \.0) { value, title in
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
                    .help("navigator.filter.help", comment: "Filter help text")
                },
                trailingAccessories: {
                    HStack(spacing: 0) {
                        Toggle(isOn: $recentsFilter) {
                            Image(systemName: "clock")
                        }
                        .help("navigator.filter.recent_files", comment: "Recent files filter help")
                        Toggle(isOn: $workspace.sourceControlFilter) {
                            Image(systemName: "plusminus.circle")
                        }
                        .help("navigator.filter.source_control", comment: "Source control filter help")
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

                let fileURL = NSURL.fileURL(withPathComponents: pathComponents)! as URL
                return fileURL
            }
        }

        return workspace.workspaceFileManager.unsafelyUnwrapped.folderUrl
    }

    private var addNewFileButton: some View {
        Menu {
            Button("navigator.add_file", comment: "Add file button") {
                let filePathURL = activeTabURL()
                guard let rootFile = workspace.workspaceFileManager?.getFile(filePathURL.path) else { return }
                do {
                    if let newFile = try workspace.workspaceFileManager?.addFile(
                        fileName: "untitled",
                        toFile: rootFile
                    ) {
                        workspace.listenerModel.highlightedFileItem = newFile
                        workspace.editorManager?.openTab(item: newFile)
                    }
                } catch {
                    let alert = NSAlert(error: error)
                    alert.addButton(withTitle: "Dismiss")
                    alert.runModal()
                }
            }

            Button("navigator.add_folder", comment: "Add folder button") {
                let filePathURL = activeTabURL()
                guard let rootFile = workspace.workspaceFileManager?.getFile(filePathURL.path) else { return }
                do {
                    if let newFolder = try workspace.workspaceFileManager?.addFolder(
                        folderName: "untitled",
                        toFile: rootFile
                    ) {
                        workspace.listenerModel.highlightedFileItem = newFolder
                    }
                } catch {
                    let alert = NSAlert(error: error)
                    alert.addButton(withTitle: "Dismiss")
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
        .accessibilityLabel("navigator.add_folder_or_file", comment: "Add folder or file accessibility label")
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
