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
                    Text(String(localized: "name", defaultValue: "Name", comment: "Name text field label"))
                }
                .accessibilityLabel(String(localized: "task-name", defaultValue: "Task Name", comment: "Task name accessibility label", os_id: "101909"))
                Picker(String(localized: "target", defaultValue: "Target", comment: "Target picker label", os_id: "101910"), selection: $task.target) {
                    Text(String(localized: "my-mac-tag", defaultValue: "My Mac", comment: "My Mac tag option"))
                        .tag(String(localized: "my-mac", defaultValue: "My Mac", comment: "My Mac option", os_id: "101906"))

                    Text(String(localized: "ssh-tag", defaultValue: "SSH", comment: "SSH tag option", os_id: "101911"))
                        .tag(String(localized: "ssh", defaultValue: "SSH", comment: "SSH option"))

                    Text(String(localized: "docker-tag", defaultValue: "Docker", comment: "Docker tag option", os_id: "101912"))
                        .tag(String(localized: "docker", defaultValue: "Docker", comment: "Docker option"))

                    Text(String(localized: "docker-compose-tag", defaultValue: "Docker Compose", comment: "Docker Compose tag option", os_id: "101913"))
                        .tag(String(localized: "docker-compose", defaultValue: "Docker Compose", comment: "Docker Compose option"))
                }
                .disabled(true)
            }

            Section {
                TextField(text: $task.command) {
                    Text(String(localized: "task", defaultValue: "Task", comment: "Task text field label", os_id: "101914"))
                }
                .accessibilityLabel(String(localized: "task-command", defaultValue: "Task Command", comment: "Task command accessibility label", os_id: "101915"))
                TextField(text: $task.workingDirectory) {
                    Text(String(localized: "working-directory", defaultValue: "Working Directory", comment: "Working directory text field label", os_id: "101916"))
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
                        Text(String(localized: "no-environment-variables", defaultValue: "No environment variables", comment: "No environment variables message", os_id: "101917"))
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
                Text(String(localized: "environment-variables", defaultValue: "Environment Variables", comment: "Environment variables section header", os_id: "101918"))
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
