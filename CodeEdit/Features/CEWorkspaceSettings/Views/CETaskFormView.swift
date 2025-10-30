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
                    Text(String(localized: "workspace-settings.task-form.name", defaultValue: "Name", comment: "Text field label for task name"))
                }
                .accessibilityLabel(String(localized: "workspace-settings.task-form.name-accessibility", defaultValue: "Task Name", comment: "Accessibility label for task name field"))
                Picker(String(localized: "workspace-settings.task-form.target", defaultValue: "Target", comment: "Label for task target picker"), selection: $task.target) {
                    Text("My Mac")
                        .tag("My Mac")

                    Text("SSH")
                        .tag("SSH")

                    Text("Docker")
                        .tag("Docker")

                    Text(String(localized: "workspace-settings.task-form.docker-compose", defaultValue: "Docker Compose", comment: "Docker Compose target option"))
                        .tag(String(localized: "workspace-settings.task-form.docker-compose", defaultValue: "Docker Compose", comment: "Docker Compose target option"))
                }
                .disabled(true)
            }

            Section {
                TextField(text: $task.command) {
                    Text(String(localized: "workspace-settings.task-form.task", defaultValue: "Task", comment: "Text field label for task command"))
                }
                .accessibilityLabel(String(localized: "workspace-settings.task-form.task-accessibility", defaultValue: "Task Command", comment: "Accessibility label for task command field"))
                TextField(text: $task.workingDirectory) {
                    Text(String(localized: "workspace-settings.task-form.working-directory", defaultValue: "Working Directory", comment: "Text field label for working directory"))
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
                        Text(String(localized: "workspace-settings.task-form.no-env-vars", defaultValue: "No environment variables", comment: "Message shown when there are no environment variables"))
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
                Text(String(localized: "workspace-settings.task-form.env-vars-title", defaultValue: "Environment Variables", comment: "Section title for environment variables"))
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
