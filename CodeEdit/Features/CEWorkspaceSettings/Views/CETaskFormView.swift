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
                    Text("taskForm.name", comment: "Label text")
                }
                .accessibilityLabel(String(localized: "taskForm.taskName", comment: "Accessibility label"))
                Picker(String(localized: "taskForm.target", comment: "Label text"), selection: $task.target) {
                    Text("My Mac")
                        .tag("My Mac")

                    Text("SSH")
                        .tag("SSH")

                    Text("Docker")
                        .tag("Docker")

                    Text("taskForm.dockerCompose", comment: "Target option")
                        .tag("Docker Compose")
                }
                .disabled(true)
            }

            Section {
                TextField(text: $task.command) {
                    Text("taskForm.task", comment: "Label text")
                }
                .accessibilityLabel(String(localized: "taskForm.taskCommand", comment: "Accessibility label"))
                TextField(text: $task.workingDirectory) {
                    Text("taskForm.workingDirectory", comment: "Label text")
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
                        Text("taskForm.noEnvironmentVariables", comment: "Empty state message")
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
                Text("taskForm.environmentVariables", comment: "Section title")
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
