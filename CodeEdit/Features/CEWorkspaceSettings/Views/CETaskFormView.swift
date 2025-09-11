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
                    Text(String(localized: "name_label", comment: "Name field label"))
                }
                .accessibilityLabel(String(localized: "task_name_accessibility", comment: "Accessibility label for task name field"))
                Picker(String(localized: "target_label", comment: "Target field label"), selection: $task.target) {
                    Text("My Mac")
                        .tag("My Mac")

                    Text(String(localized: "ssh_option", comment: "SSH target option"))
                        .tag("SSH")

                    Text(String(localized: "docker_option", comment: "Docker target option"))
                        .tag("Docker")

                    Text(String(localized: "docker_compose", comment: "Docker Compose deployment target option"))
                        .tag("Docker Compose")
                }
                .disabled(true)
            }

            Section {
                TextField(text: $task.command) {
                    Text(String(localized: "task", comment: "Task command input field placeholder"))
                }
                .accessibilityLabel(String(localized: "task_command", comment: "Task command accessibility label"))
                TextField(text: $task.workingDirectory) {
                    Text(String(localized: "working_directory", comment: "Working directory input field placeholder"))
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
                        Text(String(localized: "no_environment_variables", comment: "Message shown when there are no environment variables"))
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
                Text(String(localized: "environment_variables", comment: "Environment variables section header"))
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
