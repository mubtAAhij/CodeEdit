//
//  AddCETaskView.swift
//  CodeEdit
//
//  Created by Tommy Ludwig on 01.07.24.
//

import SwiftUI

struct AddCETaskView: View {
    @Environment(\.dismiss)
    var dismiss

    @EnvironmentObject var workspaceSettingsManager: CEWorkspaceSettings
    @StateObject var newTask: CETask

    init() {
        self._newTask = StateObject(wrappedValue: CETask(target: String(localized: "task.target.my-mac", defaultValue: "My Mac", comment: "Default task target (local machine)")))
    }
    var body: some View {
        VStack(spacing: 0) {
            CETaskFormView(task: newTask)
            Divider()
            HStack {
                Button {
                    dismiss()
                } label: {
                    Text(String(localized: "task.add.cancel", defaultValue: "Cancel", comment: "Cancel button in add task view"))
                        .frame(minWidth: 56)
                }
                Spacer()
                Button {
                    workspaceSettingsManager.settings.tasks.append(newTask)
                    try? workspaceSettingsManager.savePreferences()
                    dismiss()
                } label: {
                    Text(String(localized: "task.add.save", defaultValue: "Save", comment: "Save button in add task view"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
                .disabled(newTask.isInvalid)
            }
            .padding()
        }
        .accessibilityIdentifier("AddTaskView")
    }

}

#Preview {
    AddCETaskView()
}
