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
                            localized: "ce-workspace-settings.view.name-label",
                            defaultValue: "Name",
                            comment: "Label for workspace name field"
                        ),
                        text: $workspaceSettingsManager.settings.project.projectName
                    )
                    .accessibilityLabel(String(
                        localized: "ce-workspace-settings.view.workspace-name-placeholder",
                        defaultValue: "Workspace Name",
                        comment: "Placeholder text for workspace name input"
                    ))
                } header: {
                    Text(String(
                        localized: "ce-workspace-settings.view.workspace-section",
                        defaultValue: "Workspace",
                        comment: "Section title for workspace settings"
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
                        localized: "ce-workspace-settings.view.tasks-section",
                        defaultValue: "Tasks",
                        comment: "Section title for workspace tasks settings"
                    ))
                } footer: {
                    HStack {
                        Spacer()
                        Button {
                            selectedTaskID = nil
                            showAddTaskSheet = true
                        } label: {
                            Text(String(
                                localized: "ce-workspace-settings.view.add-task",
                                defaultValue: "Add Task...",
                                comment: "Button title to add a task in workspace settings"
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
                        localized: "ce-workspace-settings.view.done",
                        defaultValue: "Done",
                        comment: "Button title to close workspace settings"
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
