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
                        String(localized: "workspace-settings.name.placeholder", defaultValue: "Name", comment: "Text field placeholder for workspace name"),
                        text: $workspaceSettingsManager.settings.project.projectName
                    )
                    .accessibilityLabel(String(localized: "workspace-settings.name.accessibility", defaultValue: "Workspace Name", comment: "Accessibility label for workspace name field"))
                } header: {
                    Text(String(localized: "workspace-settings.workspace.title", defaultValue: "Workspace", comment: "Section title for workspace settings"))
                        .accessibilityHidden(true)
                }

                Section {
                    CEWorkspaceSettingsTaskListView(
                        settings: workspaceSettingsManager.settings,
                        selectedTaskID: $selectedTaskID,
                        showAddTaskSheet: $showAddTaskSheet
                    )
                } header: {
                    Text(String(localized: "workspace-settings.tasks.title", defaultValue: "Tasks", comment: "Section title for tasks in workspace settings"))
                } footer: {
                    HStack {
                        Spacer()
                        Button {
                            selectedTaskID = nil
                            showAddTaskSheet = true
                        } label: {
                            Text(String(localized: "workspace-settings.tasks.add-task-button", defaultValue: "Add Task...", comment: "Button to add a new task in workspace settings"))
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
                    Text(String(localized: "workspace-settings.done", defaultValue: "Done", comment: "Done button in workspace settings"))
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
