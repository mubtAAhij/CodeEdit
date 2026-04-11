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
                    Text(String(localized: "ce-task-form.name", defaultValue: "Name", comment: "Name field label"))
                }
                .accessibilityLabel(String(localized: "ce-task-form.task-name", defaultValue: "Task Name", comment: "Task name accessibility label"))
                Picker(String(localized: "ce-task-form.target", defaultValue: "Target", comment: "Target picker label"), selection: $task.target) {
                    Text(String(localized: "ce-task-form.my-mac-option", defaultValue: "My Mac", comment: "My Mac target option"))
                        .tag(String(localized: "ce-task-form.my-mac-tag", defaultValue: "My Mac", comment: "My Mac target tag"))

                    Text(String(localized: "ce-task-form.ssh-option", defaultValue: "SSH", comment: "SSH target option"))
                        .tag(String(localized: "ce-task-form.ssh-tag", defaultValue: "SSH", comment: "SSH target tag"))

                    Text(String(localized: "ce-task-form.docker-option", defaultValue: "Docker", comment: "Docker target option"))
                        .tag(String(localized: "ce-task-form.docker-tag", defaultValue: "Docker", comment: "Docker target tag"))

                    Text(String(localized: "ce-task-form.docker-compose-option", defaultValue: "Docker Compose", comment: "Docker Compose target option"))
                        .tag(String(localized: "ce-task-form.docker-compose-tag", defaultValue: "Docker Compose", comment: "Docker Compose target tag"))
                }
                .disabled(true)
            }

            Section {
                TextField(text: $task.command) {
                    Text(String(localized: "ce-task-form.task", defaultValue: "Task", comment: "Task field label"))
                }
                .accessibilityLabel(String(localized: "ce-task-form.task-command", defaultValue: "Task Command", comment: "Task command accessibility label"))
                TextField(text: $task.workingDirectory) {
                    Text(String(localized: "ce-task-form.working-directory", defaultValue: "Working Directory", comment: "Working directory field label"))
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
                        Text(String(localized: "ce-task-form.no-environment-variables", defaultValue: "No environment variables", comment: "No environment variables placeholder"))
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
                Text(String(localized: "ce-task-form.environment-variables", defaultValue: "Environment Variables", comment: "Environment variables section header"))
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
