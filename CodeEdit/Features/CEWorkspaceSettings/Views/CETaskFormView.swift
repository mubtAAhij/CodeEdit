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
                    Text(String(localized: "task.name", defaultValue: "Name", comment: "Label for task name field"))
                }
                .accessibilityLabel(String(localized: "task.name-accessibility", defaultValue: "Task Name", comment: "Accessibility label for task name field"))
                Picker(String(localized: "task.target", defaultValue: "Target", comment: "Label for task target picker"), selection: $task.target) {
                    Text(String(localized: "task.target.my-mac", defaultValue: "My Mac", comment: "Task target option for local Mac"))
                        .tag("My Mac")

                    Text(String(localized: "task.target.ssh", defaultValue: "SSH", comment: "Task target option for SSH"))
                        .tag("SSH")

                    Text(String(localized: "task.target.docker", defaultValue: "Docker", comment: "Task target option for Docker"))
                        .tag("Docker")

                    Text(String(localized: "task.target.docker-compose", defaultValue: "Docker Compose", comment: "Task target option for Docker Compose"))
                        .tag("Docker Compose")
                }
                .disabled(true)
            }

            Section {
                TextField(text: $task.command) {
                    Text(String(localized: "task.command", defaultValue: "Task", comment: "Label for task command field"))
                }
                .accessibilityLabel(String(localized: "task.command-accessibility", defaultValue: "Task Command", comment: "Accessibility label for task command field"))
                TextField(text: $task.workingDirectory) {
                    Text(String(localized: "task.working-directory", defaultValue: "Working Directory", comment: "Label for task working directory field"))
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
                        Text(String(localized: "task.no-environment-variables", defaultValue: "No environment variables", comment: "Message when no environment variables are set"))
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
                Text(String(localized: "task.environment-variables", defaultValue: "Environment Variables", comment: "Section header for environment variables"))
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
