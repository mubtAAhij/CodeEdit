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
                    Text("String(localized: "name", comment: "Label for task name field")")
                }
                .accessibilityLabel("String(localized: "task_name", comment: "Accessibility label for task name field")")
                Picker("String(localized: "target", comment: "Label for task target picker")", selection: $task.target) {
                    Text("My Mac")
                        .tag("My Mac")

                    Text("String(localized: "ssh", comment: "SSH target option for tasks")")
                        .tag("SSH")

                    Text("String(localized: "docker", comment: "Docker target option for tasks")")
                        .tag("Docker")

                    Text("String(localized: "docker_compose", comment: "Docker Compose target option for tasks")")
                        .tag("Docker Compose")
                }
                .disabled(true)
            }

            Section {
                TextField(text: $task.command) {
                    Text("String(localized: "task", comment: "Label for task command field")")
                }
                .accessibilityLabel("String(localized: "task_command", comment: "Accessibility label for task command field")")
                TextField(text: $task.workingDirectory) {
                    Text("String(localized: "working_directory", comment: "Label for task working directory field")")
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
                        Text("String(localized: "no_environment_variables", comment: "Message shown when no environment variables are configured")")
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
                Text("String(localized: "environment_variables", comment: "Section header for environment variables")")
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
