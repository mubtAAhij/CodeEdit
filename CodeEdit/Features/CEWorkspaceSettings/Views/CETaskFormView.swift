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
                    Text(String(localized: "workspace-settings.task.name", defaultValue: "Name", comment: "Label for task name field"))
                }
                .accessibilityLabel(String(localized: "workspace-settings.task.name-label", defaultValue: "Task Name", comment: "Accessibility label for task name field"))
                Picker(String(localized: "workspace-settings.task.target", defaultValue: "Target", comment: "Label for task target picker"), selection: $task.target) {
                    Text(String(localized: "workspace-settings.task.target.my-mac", defaultValue: "My Mac", comment: "Target option for running on local Mac"))
                        .tag("My Mac")

                    Text(String(localized: "workspace-settings.task.target.ssh", defaultValue: "SSH", comment: "Target option for running over SSH"))
                        .tag("SSH")

                    Text(String(localized: "workspace-settings.task.target.docker", defaultValue: "Docker", comment: "Target option for running in Docker"))
                        .tag("Docker")

                    Text(String(localized: "workspace-settings.task.target.docker-compose", defaultValue: "Docker Compose", comment: "Target option for running with Docker Compose"))
                        .tag("Docker Compose")
                }
                .disabled(true)
            }

            Section {
                TextField(text: $task.command) {
                    Text(String(localized: "workspace-settings.task.command-label", defaultValue: "Task", comment: "Label for task command field"))
                }
                .accessibilityLabel(String(localized: "workspace-settings.task.command-accessibility", defaultValue: "Task Command", comment: "Accessibility label for task command field"))
                TextField(text: $task.workingDirectory) {
                    Text(String(localized: "workspace-settings.task.working-directory", defaultValue: "Working Directory", comment: "Label for working directory field"))
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
                        Text(String(localized: "workspace-settings.task.no-env-vars", defaultValue: "No environment variables", comment: "Empty state message for environment variables list"))
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
                Text(String(localized: "workspace-settings.task.env-vars-header", defaultValue: "Environment Variables", comment: "Section header for environment variables"))
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
