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
                        String(localized: "name", comment: "Name field placeholder"),
                        text: $workspaceSettingsManager.settings.project.projectName
                    )
                    .accessibilityLabel(String(localized: "workspace_name", comment: "Accessibility label for workspace name field"))
                } header: {
                    Text(String(localized: "workspace", comment: "Section header for workspace settings"))
                        .accessibilityHidden(true)
                }

                Section {
                    CEWorkspaceSettingsTaskListView(
                        settings: workspaceSettingsManager.settings,
                        selectedTaskID: $selectedTaskID,
                        showAddTaskSheet: $showAddTaskSheet
                    )
                } header: {
                    Text(String(localized: "tasks", comment: "Section header for tasks settings"))
                } footer: {
                    HStack {
                        Spacer()
                        Button {
                            selectedTaskID = nil
                            showAddTaskSheet = true
                        } label: {
                            Text(String(localized: "add_task", comment: "Button to add a new task"))
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
                    Text(String(localized: "done", comment: "Button to finish and close settings"))
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
