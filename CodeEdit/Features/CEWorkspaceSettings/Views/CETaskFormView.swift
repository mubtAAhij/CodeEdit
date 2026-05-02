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
                    Text(String(localized: "task.form.name.label", defaultValue: "Name", comment: "Label for task name field"))
                }
                .accessibilityLabel(String(localized: "task.form.name.accessibility", defaultValue: "Task Name", comment: "Accessibility label for task name field"))
                Picker(String(localized: "task.form.target.label", defaultValue: "Target", comment: "Label for task target picker"), selection: $task.target) {
                    Text(String(localized: "task.form.target.my.mac", defaultValue: "My Mac", comment: "Task target option for local Mac"))
                        .tag(String(localized: "task.form.target.my.mac.tag", defaultValue: "My Mac", comment: "Tag value for My Mac task target"))

                    Text(String(localized: "task.form.target.ssh", defaultValue: "SSH", comment: "Task target option for SSH"))
                        .tag(String(localized: "task.form.target.ssh.tag", defaultValue: "SSH", comment: "Tag value for SSH task target"))

                    Text(String(localized: "task.form.target.docker", defaultValue: "Docker", comment: "Task target option for Docker"))
                        .tag(String(localized: "task.form.target.docker.tag", defaultValue: "Docker", comment: "Tag value for Docker task target"))

                    Text(String(localized: "task.form.target.docker.compose", defaultValue: "Docker Compose", comment: "Task target option for Docker Compose"))
                        .tag(String(localized: "task.form.target.docker.compose.tag", defaultValue: "Docker Compose", comment: "Tag value for Docker Compose task target"))
                }
                .disabled(true)
            }

            Section {
                TextField(text: $task.command) {
                    Text(String(localized: "task.form.command.label", defaultValue: "Task", comment: "Label for task command field"))
                }
                .accessibilityLabel(String(localized: "task.form.command.accessibility", defaultValue: "Task Command", comment: "Accessibility label for task command field"))
                TextField(text: $task.workingDirectory) {
                    Text(String(localized: "task.form.working.directory.label", defaultValue: "Working Directory", comment: "Label for task working directory field"))
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
                        Text(String(localized: "task.form.environment.variables.empty", defaultValue: "No environment variables", comment: "Message shown when task has no environment variables"))
                            .foregroundStyle(Color(.secondaryLabelColor))
                    }
                }
                .actionBar {
                    Button {
                          self.task.environmentVariables.append(CETask.EnvironmentVariable())
                    } label: {
                        Image(systemName: String(localized: "task.form.environment.variables.add.icon", defaultValue: "plus", comment: "System icon name for add environment variable button"))
                    }
                    Divider()
                    Button {
                        removeSelectedEnv()
                    } label: {
                        Image(systemName: String(localized: "task.form.environment.variables.remove.icon", defaultValue: "minus", comment: "System icon name for remove environment variable button"))
                    }
                    .disabled(selectedEnvID == nil)
                }
                .onDeleteCommand {
                    removeSelectedEnv()
                }
            } header: {
                Text(String(localized: "task.form.environment.variables.header", defaultValue: "Environment Variables", comment: "Section header for environment variables"))
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
