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
                    Text(String(localized: "task.name.label", defaultValue: "Name", comment: "Label for task name field"))
                }
                .accessibilityLabel(String(localized: "task.name.accessibility_label", defaultValue: "Task Name", comment: "Accessibility label for task name field"))
                Picker(String(localized: "task.target.label", defaultValue: "Target", comment: "Label for task target picker"), selection: $task.target) {
                    Text(String(localized: "task.target.my_mac", defaultValue: "My Mac", comment: "My Mac target option"))
                        .tag(String(localized: "task.target.my_mac", defaultValue: "My Mac", comment: "My Mac target option"))

                    Text(String(localized: "task.target.ssh", defaultValue: "SSH", comment: "SSH target option"))
                        .tag(String(localized: "task.target.ssh", defaultValue: "SSH", comment: "SSH target option"))

                    Text(String(localized: "task.target.docker", defaultValue: "Docker", comment: "Docker target option"))
                        .tag(String(localized: "task.target.docker", defaultValue: "Docker", comment: "Docker target option"))

                    Text(String(localized: "task.target.docker_compose", defaultValue: "Docker Compose", comment: "Docker Compose target option"))
                        .tag(String(localized: "task.target.docker_compose", defaultValue: "Docker Compose", comment: "Docker Compose target option"))
                }
                .disabled(true)
            }

            Section {
                TextField(text: $task.command) {
                    Text(String(localized: "task.command.label", defaultValue: "Task", comment: "Label for task command field"))
                }
                .accessibilityLabel(String(localized: "task.command.accessibility_label", defaultValue: "Task Command", comment: "Accessibility label for task command field"))
                TextField(text: $task.workingDirectory) {
                    Text(String(localized: "task.working_directory.label", defaultValue: "Working Directory", comment: "Label for working directory field"))
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
                        Text(String(localized: "task.environment_variables.empty", defaultValue: "No environment variables", comment: "Message shown when no environment variables are set"))
                            .foregroundStyle(Color(.secondaryLabelColor))
                    }
                }
                .actionBar {
                    Button {
                          self.task.environmentVariables.append(CETask.EnvironmentVariable())
                    } label: {
                        Image(systemName: String(localized: "task.environment_variables.add.icon", defaultValue: "plus", comment: "System icon name for add environment variable button"))
                    }
                    Divider()
                    Button {
                        removeSelectedEnv()
                    } label: {
                        Image(systemName: String(localized: "task.environment_variables.remove.icon", defaultValue: "minus", comment: "System icon name for remove environment variable button"))
                    }
                    .disabled(selectedEnvID == nil)
                }
                .onDeleteCommand {
                    removeSelectedEnv()
                }
            } header: {
                Text(String(localized: "task.environment_variables.header", defaultValue: "Environment Variables", comment: "Section header for environment variables"))
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
