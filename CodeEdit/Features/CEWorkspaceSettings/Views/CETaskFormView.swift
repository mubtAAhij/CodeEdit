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
                    Text(String(localized: "workspace-settings.task-form.name", defaultValue: "Name", comment: "Label for task name field"))
                }
                .accessibilityLabel(String(localized: "workspace-settings.task-form.task-name", defaultValue: "Task Name", comment: "Placeholder text for task name input"))
                Picker(String(localized: "workspace-settings.task-form.target", defaultValue: "Target", comment: "Label for execution target picker"), selection: $task.target) {
                    Text(String(localized: "workspace-settings.task-form.target.my-mac.title", defaultValue: "My Mac", comment: "Picker title for local machine target"))
                        .tag(String(localized: "workspace-settings.task-form.target.my-mac.value", defaultValue: "My Mac", comment: "Picker value label for local machine target"))

                    Text(String(localized: "workspace-settings.task-form.target.ssh.title", defaultValue: "SSH", comment: "Picker title for SSH target"))
                        .tag(String(localized: "workspace-settings.task-form.target.ssh.value", defaultValue: "SSH", comment: "Picker value label for SSH target"))

                    Text(String(localized: "workspace-settings.task-form.target.docker.title", defaultValue: "Docker", comment: "Picker title for Docker target"))
                        .tag(String(localized: "workspace-settings.task-form.target.docker.value", defaultValue: "Docker", comment: "Picker value label for Docker target"))

                    Text(String(localized: "workspace-settings.task-form.target.docker-compose", defaultValue: "Docker Compose", comment: "Picker option label for Docker Compose target"))
                        .tag(String(localized: "workspace-settings.task-form.target.docker-compose.value", defaultValue: "Docker Compose", comment: "Picker value label for Docker Compose target"))
                }
                .disabled(true)
            }

            Section {
                TextField(text: $task.command) {
                    Text(String(localized: "workspace-settings.task-form.section.task", defaultValue: "Task", comment: "Section title for task configuration"))
                }
                .accessibilityLabel(String(localized: "workspace-settings.task-form.task-command", defaultValue: "Task Command", comment: "Label for task command input"))
                TextField(text: $task.workingDirectory) {
                    Text(String(localized: "workspace-settings.task-form.working-directory", defaultValue: "Working Directory", comment: "Label for working directory input"))
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
                        Text(String(localized: "workspace-settings.task-form.no-environment-variables", defaultValue: "No environment variables", comment: "Placeholder text when no environment variables are configured"))
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
                Text(String(localized: "workspace-settings.task-form.environment-variables", defaultValue: "Environment Variables", comment: "Section title for environment variable configuration"))
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
        task.environmentVariables.removeAll(where: {
            $0.id == id
        })
    }
}
