//
//  EditCETaskView.swift
//  CodeEdit
//
//  Created by Tommy Ludwig on 01.07.24.
//

import SwiftUI

struct EditCETaskView: View {
    @Environment(\.dismiss)
    var dismiss

    @EnvironmentObject var workspaceSettingsManager: CEWorkspaceSettings
    @EnvironmentObject var taskManager: TaskManager
    @ObservedObject var task: CETask

    let selectedTaskIndex: Int

    var body: some View {
        VStack(spacing: 0) {
            CETaskFormView(task: task)
            Divider()
            HStack {
                Button(role: .destructive) {
                    do {
                        workspaceSettingsManager.settings.tasks.removeAll(where: {
                            $0.id == task.id
                        })
                        try workspaceSettingsManager.savePreferences()
                        taskManager.deleteTask(taskID: task.id)
                        self.dismiss()
                    } catch {
                        NSAlert(error: error).runModal()
                    }
                } label: {
                    Text(String(localized: "task.delete", comment: "Delete button for task"))
                        .foregroundStyle(.red)
                        .frame(minWidth: 56)
                }

                Spacer()

                Button {
                    do {
                        try workspaceSettingsManager.savePreferences()
                        self.dismiss()
                    } catch {
                        NSAlert(error: error).runModal()
                    }
                } label: {
                    Text(String(localized: "task.done", comment: "Done button for task editing"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
                .disabled(task.isInvalid)
            }
            .padding()
        }
    }
}

// #Preview {
    //    EditCETaskView()
// }
