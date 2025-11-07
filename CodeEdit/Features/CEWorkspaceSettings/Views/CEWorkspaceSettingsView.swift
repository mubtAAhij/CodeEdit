//
//  CEWorkspaceSettingsView.swift
//  CodeEdit
//
//  Created by Tommy Ludwig on 01.07.24.
//

import SwiftUI

struct CEWorkspaceSettingsView: View {
    var dismiss: () -> Void

    @EnvironmentObject var workspaceSettingsManager: CEWorkspaceSettings
    @EnvironmentObject var workspace: WorkspaceDocument

    @State var selectedTaskID: UUID?
    @State var showAddTaskSheet: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            Form {
                Section {
                    TextField(
                        String(
                            localized: "workspace-settings.name",
                            defaultValue: "Name",
                            comment: "Label for workspace name text field"
                        ),
                        text: $workspaceSettingsManager.settings.project.projectName
                    )
                    .accessibilityLabel(String(
                        localized: "workspace-settings.workspace-name",
                        defaultValue: "Workspace Name",
                        comment: "Accessibility label for workspace name field"
                    ))
                } header: {
                    Text(String(
                        localized: "workspace-settings.workspace",
                        defaultValue: "Workspace",
                        comment: "Section header for workspace settings"
                    ))
                        .accessibilityHidden(true)
                }

                Section {
                    CEWorkspaceSettingsTaskListView(
                        settings: workspaceSettingsManager.settings,
                        selectedTaskID: $selectedTaskID,
                        showAddTaskSheet: $showAddTaskSheet
                    )
                } header: {
                    Text(String(
                        localized: "workspace-settings.tasks",
                        defaultValue: "Tasks",
                        comment: "Section header for tasks settings"
                    ))
                } footer: {
                    HStack {
                        Spacer()
                        Button {
                            selectedTaskID = nil
                            showAddTaskSheet = true
                        } label: {
                            Text(String(
                                localized: "workspace-settings.add-task",
                                defaultValue: "Add Task...",
                                comment: "Button to add a new task"
                            ))
                        }
                    }
                }
            }
            .formStyle(.grouped)
            .scrollContentBackground(.hidden)

            Divider()
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text(String(
                        localized: "workspace-settings.done",
                        defaultValue: "Done",
                        comment: "Button to close workspace settings"
                    ))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .sheet(isPresented: $showAddTaskSheet) {
            if let selectedTaskIndex = workspaceSettingsManager.settings.tasks.firstIndex(where: {
                $0.id == selectedTaskID
            }) {
                EditCETaskView(
                    task: workspaceSettingsManager.settings.tasks[selectedTaskIndex],
                    selectedTaskIndex: selectedTaskIndex
                )
            } else {
                AddCETaskView()
            }
        }
    }
}

#Preview {
    CEWorkspaceSettingsView(dismiss: { print("Dismiss") })
}
