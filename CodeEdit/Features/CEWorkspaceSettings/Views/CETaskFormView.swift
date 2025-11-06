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
                    Text(String(localized: "task-form.name", defaultValue: "Name", comment: "Task name field label"))
                }
                .accessibilityLabel(String(localized: "task-form.name-placeholder", defaultValue: "Task Name", comment: "Task name field placeholder"))
                Picker(String(localized: "task-form.target", defaultValue: "Target", comment: "Task target field label"), selection: $task.target) {
                    Text("My Mac")
                        .tag("My Mac")

                    Text("SSH")
                        .tag("SSH")

                    Text("Docker")
                        .tag("Docker")

                    Text(String(localized: "task-form.docker-compose", defaultValue: "Docker Compose", comment: "Docker Compose option in target picker"))
                        .tag(String(localized: "task-form.docker-compose", defaultValue: "Docker Compose", comment: "Docker Compose option in target picker"))
                }
                .disabled(true)
            }

            Section {
                TextField(text: $task.command) {
                    Text(String(localized: "task-form.task", defaultValue: "Task", comment: "Task command field label"))
                }
                .accessibilityLabel(String(localized: "task-form.task-command", defaultValue: "Task Command", comment: "Task command field placeholder"))
                TextField(text: $task.workingDirectory) {
                    Text(String(localized: "task-form.working-directory", defaultValue: "Working Directory", comment: "Working directory field label"))
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
                        Text(String(localized: "task-form.no-env-vars", defaultValue: "No environment variables", comment: "Message when no environment variables are set"))
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
                Text(String(localized: "task-form.environment-variables", defaultValue: "Environment Variables", comment: "Environment variables section label"))
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
