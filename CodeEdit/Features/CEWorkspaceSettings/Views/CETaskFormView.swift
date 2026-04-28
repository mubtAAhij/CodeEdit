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
                    Text(String(localized: "task.form.name", defaultValue: "Name", comment: "Label for task name field"))
                }
                .accessibilityLabel(String(localized: "task.form.task-name", defaultValue: "Task Name", comment: "Accessibility label for task name field"))
                Picker(String(localized: "task.form.target", defaultValue: "Target", comment: "Label for task target picker"), selection: $task.target) {
                    Text(String(localized: "task.form.target.my-mac", defaultValue: "My Mac", comment: "Target option for local Mac"))
                        .tag(String(localized: "task.form.target.my-mac.tag", defaultValue: "My Mac", comment: "Tag value for My Mac target"))

                    Text(String(localized: "task.form.target.ssh", defaultValue: "SSH", comment: "Target option for SSH"))
                        .tag(String(localized: "task.form.target.ssh.tag", defaultValue: "SSH", comment: "Tag value for SSH target"))

                    Text(String(localized: "task.form.target.docker", defaultValue: "Docker", comment: "Target option for Docker"))
                        .tag(String(localized: "task.form.target.docker.tag", defaultValue: "Docker", comment: "Tag value for Docker target"))

                    Text(String(localized: "task.form.target.docker-compose", defaultValue: "Docker Compose", comment: "Target option for Docker Compose"))
                        .tag(String(localized: "task.form.target.docker-compose.tag", defaultValue: "Docker Compose", comment: "Tag value for Docker Compose target"))
                }
                .disabled(true)
            }

            Section {
                TextField(text: $task.command) {
                    Text(String(localized: "task.form.task", defaultValue: "Task", comment: "Label for task command field"))
                }
                .accessibilityLabel(String(localized: "task.form.task-command", defaultValue: "Task Command", comment: "Accessibility label for task command field"))
                TextField(text: $task.workingDirectory) {
                    Text(String(localized: "task.form.working-directory", defaultValue: "Working Directory", comment: "Label for working directory field"))
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
                        Text(String(localized: "task.form.no-env-vars", defaultValue: "No environment variables", comment: "Message when no environment variables exist"))
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
                Text(String(localized: "task.form.env-vars", defaultValue: "Environment Variables", comment: "Section header for environment variables"))
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
