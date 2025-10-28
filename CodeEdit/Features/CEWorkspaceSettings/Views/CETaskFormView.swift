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
                    Text("task.name", comment: "Text field label")
                }
                .accessibilityLabel(String(localized: "accessibility.task_name", comment: "Accessibility label"))
                Picker("task.target", comment: "Picker label", selection: $task.target) {
                    Text("My Mac")
                        .tag("My Mac")

                    Text("SSH")
                        .tag("SSH")

                    Text("Docker")
                        .tag("Docker")

                    Text("task.target.docker_compose", comment: "Picker option")
                        .tag("Docker Compose")
                }
                .disabled(true)
            }

            Section {
                TextField(text: $task.command) {
                    Text("task.command", comment: "Text field label")
                }
                .accessibilityLabel(String(localized: "accessibility.task_command", comment: "Accessibility label"))
                TextField(text: $task.workingDirectory) {
                    Text("task.working_directory", comment: "Text field label")
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
                        Text("task.no_environment_variables", comment: "Placeholder text")
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
                Text("task.environment_variables", comment: "Section header")
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
