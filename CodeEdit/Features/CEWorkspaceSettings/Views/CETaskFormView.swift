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
                        localized: "workspace-settings.task-form.name.label",
                        defaultValue: "Name",
                        comment: "Label for task name field"
                    ))
                }
                .accessibilityLabel(String(
                    localized: "workspace-settings.task-form.task-name.placeholder",
                    defaultValue: "Task Name",
                    comment: "Placeholder for task name input"
                ))
                Picker(String(
                    localized: "workspace-settings.task-form.target.label",
                    defaultValue: "Target",
                    comment: "Label for task execution target picker"
                ), selection: $task.target) {
                    Text(String(
                        localized: "workspace-settings.task-form.target.my-mac",
                        defaultValue: "My Mac",
                        comment: "Target option for running task on local machine"
                    ))
                        .tag("My Mac")

                    Text(String(
                        localized: "workspace-settings.task-form.target.ssh",
                        defaultValue: "SSH",
                        comment: "Target option for running task over SSH"
                    ))
                        .tag("SSH")

                    Text(String(
                        localized: "workspace-settings.task-form.target.docker",
                        defaultValue: "Docker",
                        comment: "Target option for running task in Docker"
                    ))
                        .tag("Docker")

                    Text(String(
                        localized: "workspace-settings.task-form.target.docker-compose",
                        defaultValue: "Docker Compose",
                        comment: "Target option for running task in Docker Compose"
                    ))
                        .tag("Docker Compose")
                }
                .disabled(true)
            }

            Section {
                TextField(text: $task.command) {
                    Text(String(
                        localized: "workspace-settings.task-form.task.section-title",
                        defaultValue: "Task",
                        comment: "Section title for task command configuration"
                    ))
                }
                .accessibilityLabel(String(
                    localized: "workspace-settings.task-form.task-command.label",
                    defaultValue: "Task Command",
                    comment: "Label for task command input"
                ))
                TextField(text: $task.workingDirectory) {
                    Text(String(
                        localized: "workspace-settings.task-form.working-directory.label",
                        defaultValue: "Working Directory",
                        comment: "Label for working directory input"
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
                            localized: "workspace-settings.task-form.environment.no-variables",
                            defaultValue: "No environment variables",
                            comment: "Placeholder text when no environment variables are configured"
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
                    localized: "workspace-settings.task-form.environment.section-title",
                    defaultValue: "Environment Variables",
                    comment: "Section title for environment variables configuration"
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
