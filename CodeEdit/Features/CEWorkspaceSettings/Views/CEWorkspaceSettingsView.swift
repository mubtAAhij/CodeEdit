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
                        String(localized: "workspace-settings.field.name.label", defaultValue: "Name", comment: "Label for workspace name field"),
                        text: $workspaceSettingsManager.settings.project.projectName
                    )
                    .accessibilityLabel(String(localized: "workspace-settings.field.workspace-name.placeholder", defaultValue: "Workspace Name", comment: "Placeholder for workspace name input"))
                } header: {
                    Text(String(localized: "workspace-settings.section.workspace", defaultValue: "Workspace", comment: "Section title for workspace settings"))
                        .accessibilityHidden(true)
                }

                Section {
                    CEWorkspaceSettingsTaskListView(
                        settings: workspaceSettingsManager.settings,
                        selectedTaskID: $selectedTaskID,
                        showAddTaskSheet: $showAddTaskSheet
                    )
                } header: {
                    Text(String(localized: "workspace-settings.section.tasks", defaultValue: "Tasks", comment: "Section title for workspace tasks list"))
                } footer: {
                    HStack {
                        Spacer()
                        Button {
                            selectedTaskID = nil
                            showAddTaskSheet = true
                        } label: {
                            Text(String(localized: "workspace-settings.tasks.add-task", defaultValue: "Add Task...", comment: "Menu/button title to add a new task"))
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
                    Text(String(localized: "workspace-settings.action.done", defaultValue: "Done", comment: "Button title to finish editing workspace settings"))
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
    CEWorkspaceSettingsView(dismiss: { print(String(localized: "workspace-settings.action.dismiss", defaultValue: "Dismiss", comment: "Button title to dismiss workspace settings view")) })
}
