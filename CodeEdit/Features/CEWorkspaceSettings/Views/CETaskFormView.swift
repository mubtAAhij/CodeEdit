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
                    Text(String(localized: "ce-workspace.task-form.name", defaultValue: "Name", comment: "Label for task name field"))
                }
                .accessibilityLabel(String(localized: "ce-workspace.task-form.task-name-placeholder", defaultValue: "Task Name", comment: "Placeholder for task name input"))
                Picker(String(localized: "ce-workspace.task-form.target", defaultValue: "Target", comment: "Label for task execution target selection"), selection: $task.target) {
                    Text(String(localized: "ce-workspace.task-form.target.my-mac.title", defaultValue: "My Mac", comment: "Target option title for running task on local machine"))
                        .tag(String(localized: "ce-workspace.task-form.target.my-mac.value", defaultValue: "My Mac", comment: "Target option value text for local machine target"))

                    Text(String(localized: "ce-workspace.task-form.target.ssh.title", defaultValue: "SSH", comment: "Target option title for SSH execution target"))
                        .tag(String(localized: "ce-workspace.task-form.target.ssh.value", defaultValue: "SSH", comment: "Target option value text for SSH target"))

                    Text(String(localized: "ce-workspace.task-form.target.docker.title", defaultValue: "Docker", comment: "Target option title for Docker execution target"))
                        .tag(String(localized: "ce-workspace.task-form.target.docker.value", defaultValue: "Docker", comment: "Target option value text for Docker target"))

                    Text(String(localized: "ce-workspace.task-form.target.docker-compose", defaultValue: "Docker Compose", comment: "Target option label for Docker Compose execution target"))
                        .tag(String(localized: "ce-workspace.task-form.target.docker-compose.value", defaultValue: "Docker Compose", comment: "Target option value text for Docker Compose target"))
                }
                .disabled(true)
            }

            Section {
                TextField(text: $task.command) {
                    Text(String(localized: "ce-workspace.task-form.task", defaultValue: "Task", comment: "Section title for task configuration fields"))
                }
                .accessibilityLabel(String(localized: "ce-workspace.task-form.task-command", defaultValue: "Task Command", comment: "Label for command to execute in task"))
                TextField(text: $task.workingDirectory) {
                    Text(String(localized: "ce-workspace.task-form.working-directory", defaultValue: "Working Directory", comment: "Label for task working directory field"))
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
                        Text(String(localized: "ce-workspace.task-form.no-environment-variables", defaultValue: "No environment variables", comment: "Placeholder text shown when no environment variables are configured"))
                            .foregroundStyle(Color(.secondaryLabelColor))
                    }
                }
                .actionBar {
                    Button {
                          self.task.environmentVariables.append(CETask.EnvironmentVariable())
                    } label: {
                        Image(systemName: "plus")
                    }
                    Divider()
                    Button {
                        removeSelectedEnv()
                    } label: {
                        Image(systemName: "minus")
                    }
                    .disabled(selectedEnvID == nil)
                }
                .onDeleteCommand {
                    removeSelectedEnv()
                }
            } header: {
                Text(String(localized: "ce-workspace.task-form.environment-variables", defaultValue: "Environment Variables", comment: "Section title for environment variables list"))
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
