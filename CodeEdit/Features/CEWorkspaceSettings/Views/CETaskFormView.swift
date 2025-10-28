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
                    Text("tasks.name", comment: "Field label")
                }
                .accessibilityLabel("tasks.name_accessibility", comment: "Accessibility label")
                Picker("tasks.target", comment: "Picker label", selection: $task.target) {
                    Text("My Mac")
                        .tag("My Mac")

                    Text("SSH")
                        .tag("SSH")

                    Text("Docker")
                        .tag("Docker")

                    Text("tasks.docker_compose", comment: "Target option")
                        .tag("Docker Compose")
                }
                .disabled(true)
            }

            Section {
                TextField(text: $task.command) {
                    Text("tasks.task", comment: "Field label")
                }
                .accessibilityLabel("tasks.task_command", comment: "Accessibility label")
                TextField(text: $task.workingDirectory) {
                    Text("tasks.working_directory", comment: "Field label")
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
                        Text("tasks.no_env_vars", comment: "Empty state message")
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
                Text("tasks.env_vars_header", comment: "Section header")
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
