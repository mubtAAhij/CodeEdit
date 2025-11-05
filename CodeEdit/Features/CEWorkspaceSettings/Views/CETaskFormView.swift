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
                    Text(String(localized: "task.name-label", defaultValue: "Name", comment: "Label for task name field"))
                }
                .accessibilityLabel(String(localized: "accessibility.task-name", defaultValue: "Task Name", comment: "Accessibility label for task name field"))
                Picker(String(localized: "task.target", defaultValue: "Target", comment: "Picker label for task target"), selection: $task.target) {
                    Text("My Mac")
                        .tag("My Mac")

                    Text("SSH")
                        .tag("SSH")

                    Text("Docker")
                        .tag("Docker")

                    Text(String(localized: "task.docker-compose", defaultValue: "Docker Compose", comment: "Docker Compose target option"))
                        .tag(String(localized: "task.docker-compose", defaultValue: "Docker Compose", comment: "Docker Compose target option"))
                }
                .disabled(true)
            }

            Section {
                TextField(text: $task.command) {
                    Text(String(localized: "task.task-label", defaultValue: "Task", comment: "Label for task command field"))
                }
                .accessibilityLabel(String(localized: "accessibility.task-command", defaultValue: "Task Command", comment: "Accessibility label for task command field"))
                TextField(text: $task.workingDirectory) {
                    Text(String(localized: "task.working-directory", defaultValue: "Working Directory", comment: "Label for working directory field"))
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
                        Text(String(localized: "task.no-env-variables", defaultValue: "No environment variables", comment: "Empty state message when no environment variables are configured"))
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
