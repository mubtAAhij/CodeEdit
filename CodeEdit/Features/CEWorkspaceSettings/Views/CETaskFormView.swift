//
//  CETaskFormView.swift
//  CodeEdit
//
//  Created by Tommy Ludwig on 01.07.24.
//

import SwiftUI

struct CETaskFormView: View {
    @EnvironmentObject var workspaceSettingsManager: CEWorkspaceSettings
    @ObservedObject var task: CETask
    @State private var selectedEnvID: UUID?

    var body: some View {
        Form {
            Section {
                TextField(text: $task.name) {
                    Text(String(localized: "task-form.name.label", defaultValue: "Name", comment: "Label for task name field"))
                }
                .accessibilityLabel(String(localized: "task-form.name.accessibility", defaultValue: "Task Name", comment: "Accessibility label for task name field"))
                Picker(String(localized: "task-form.target.label", defaultValue: "Target", comment: "Label for target picker"), selection: $task.target) {
                    Text(String(localized: "task-form.target.my-mac", defaultValue: "My Mac", comment: "Target option for local Mac"))
                        .tag("My Mac")

                    Text(String(localized: "task-form.target.ssh", defaultValue: "SSH", comment: "Target option for SSH"))
                        .tag("SSH")

                    Text(String(localized: "task-form.target.docker", defaultValue: "Docker", comment: "Target option for Docker"))
                        .tag("Docker")

                    Text(String(localized: "task-form.target.docker-compose", defaultValue: "Docker Compose", comment: "Target option for Docker Compose"))
                        .tag("Docker Compose")
                }
                .disabled(true)
            }

            Section {
                TextField(text: $task.command) {
                    Text(String(localized: "task-form.command.label", defaultValue: "Task", comment: "Label for task command field"))
                }
                .accessibilityLabel(String(localized: "task-form.command.accessibility", defaultValue: "Task Command", comment: "Accessibility label for task command field"))
                TextField(text: $task.workingDirectory) {
                    Text(String(localized: "task-form.working-directory.label", defaultValue: "Working Directory", comment: "Label for working directory field"))
                }
            }

            Section {
                List(selection: $selectedEnvID) {
                    ForEach($task.environmentVariables, id: \.id) { env in
                        EnvironmentVariableListItem(
                            environmentVariable: env,
                            selectedEnvID: $selectedEnvID,
                            deleteHandler: removeEnv
                        )
                    }
                }
                .frame(minHeight: 56)
                .overlay {
                    if task.environmentVariables.isEmpty {
                        Text(String(localized: "task-form.env-variables.empty", defaultValue: "No environment variables", comment: "Empty state message for environment variables"))
                            .foregroundStyle(Color(.secondaryLabelColor))
                    }
                }
                .actionBar {
                    Button {
                          self.task.environmentVariables.append(CETask.EnvironmentVariable())
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel(String(localized: "task-form.env-variables.add", defaultValue: "Add environment variable", comment: "Accessibility label for add environment variable button"))
                    Divider()
                    Button {
                        removeSelectedEnv()
                    } label: {
                        Image(systemName: "minus")
                    }
                    .accessibilityLabel(String(localized: "task-form.env-variables.remove", defaultValue: "Remove environment variable", comment: "Accessibility label for remove environment variable button"))
                    .disabled(selectedEnvID == nil)
                }
                .onDeleteCommand {
                    removeSelectedEnv()
                }
            } header: {
                Text(String(localized: "task-form.env-variables.header", defaultValue: "Environment Variables", comment: "Header for environment variables section"))
            }
        }
        .formStyle(.grouped)
    }

    func removeSelectedEnv() {
        if let selectedItemId = selectedEnvID {
            removeEnv(id: selectedItemId)
        }
    }

    func removeEnv(id: UUID) {
        self.task.environmentVariables.removeAll(where: {
            $0.id == id
        })
    }
}
