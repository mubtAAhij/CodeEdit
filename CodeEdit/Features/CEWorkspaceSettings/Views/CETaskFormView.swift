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
                    Text(String(
                        localized: "ce-workspace-settings.task-form.name-label",
                        defaultValue: "Name",
                        comment: "Label for task name field"
                    ))
                }
                .accessibilityLabel(String(
                    localized: "ce-workspace-settings.task-form.task-name-placeholder",
                    defaultValue: "Task Name",
                    comment: "Placeholder for task name input"
                ))
                Picker(String(
                    localized: "ce-workspace-settings.task-form.target-label",
                    defaultValue: "Target",
                    comment: "Label for task target selector"
                ), selection: $task.target) {
                    Text(String(
                        localized: "ce-workspace-settings.task-form.target.my-mac",
                        defaultValue: "My Mac",
                        comment: "Target option for running task on local machine"
                    ))
                        .tag("My Mac")

                    Text(String(
                        localized: "ce-workspace-settings.task-form.target.ssh",
                        defaultValue: "SSH",
                        comment: "Target option for running task over SSH"
                    ))
                        .tag("SSH")

                    Text(String(
                        localized: "ce-workspace-settings.task-form.target.docker",
                        defaultValue: "Docker",
                        comment: "Target option for running task in Docker container"
                    ))
                        .tag("Docker")

                    Text(String(
                        localized: "ce-workspace-settings.task-form.target.docker-compose",
                        defaultValue: "Docker Compose",
                        comment: "Target option for running task with Docker Compose"
                    ))
                        .tag("Docker Compose")
                }
                .disabled(true)
            }

            Section {
                TextField(text: $task.command) {
                    Text(String(
                        localized: "ce-workspace-settings.task-form.task-section-title",
                        defaultValue: "Task",
                        comment: "Section title for task command configuration"
                    ))
                }
                .accessibilityLabel(String(
                    localized: "ce-workspace-settings.task-form.task-command-placeholder",
                    defaultValue: "Task Command",
                    comment: "Placeholder for task command input"
                ))
                TextField(text: $task.workingDirectory) {
                    Text(String(
                        localized: "ce-workspace-settings.task-form.working-directory-placeholder",
                        defaultValue: "Working Directory",
                        comment: "Placeholder for task working directory input"
                    ))
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
                        Text(String(
                            localized: "ce-workspace-settings.task-form.environment-variables.empty-state",
                            defaultValue: "No environment variables",
                            comment: "Empty state text when no environment variables are configured"
                        ))
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
                Text(String(
                    localized: "ce-workspace-settings.task-form.environment-variables.section-title",
                    defaultValue: "Environment Variables",
                    comment: "Section title for task environment variables"
                ))
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
