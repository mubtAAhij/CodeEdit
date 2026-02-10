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
                    Text(String(localized: "task.name", defaultValue: "Name", comment: "Task name field label"))
                }
                .accessibilityLabel(String(localized: "task.name-accessibility", defaultValue: "Task Name", comment: "Task name accessibility label"))
                Picker(String(localized: "task.target", defaultValue: "Target", comment: "Task target picker label"), selection: $task.target) {
                    Text(String(localized: "task.target.my-mac", defaultValue: "My Mac", comment: "My Mac target option"))
                        .tag(String(localized: "task.target.my-mac", defaultValue: "My Mac", comment: "My Mac target option"))

                    Text("SSH")
                        .tag("SSH")

                    Text(String(localized: "task.target.docker", defaultValue: "Docker", comment: "Docker target option"))
                        .tag(String(localized: "task.target.docker", defaultValue: "Docker", comment: "Docker target option"))

                    Text(String(localized: "task.target.docker-compose", defaultValue: "Docker Compose", comment: "Docker Compose target option"))
                        .tag(String(localized: "task.target.docker-compose", defaultValue: "Docker Compose", comment: "Docker Compose target option"))
                }
                .disabled(true)
            }

            Section {
                TextField(text: $task.command) {
                    Text(String(localized: "task.task", defaultValue: "Task", comment: "Task command field label"))
                }
                .accessibilityLabel(String(localized: "task.command-accessibility", defaultValue: "Task Command", comment: "Task command accessibility label"))
                TextField(text: $task.workingDirectory) {
                    Text(String(localized: "task.working-directory", defaultValue: "Working Directory", comment: "Working directory field label"))
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
                        Text(String(localized: "task.no-environment-variables", defaultValue: "No environment variables", comment: "Empty state message for environment variables"))
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
                Text(String(localized: "task.environment-variables", defaultValue: "Environment Variables", comment: "Environment variables section header"))
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
