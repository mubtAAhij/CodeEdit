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
        self._newTask = StateObject(wrappedValue: CETask(target: String(localized: "workspace.tasks.my-mac", defaultValue: "My Mac", comment: "Default target for new tasks")))
    }
    var body: some View {
        VStack(spacing: 0) {
            CETaskFormView(task: newTask)
            Divider()
            HStack {
                Button {
                    dismiss()
                } label: {
                    Text(String(localized: "workspace.tasks.cancel", defaultValue: "Cancel", comment: "Button to cancel adding a task"))
                        .frame(minWidth: 56)
                }
                Spacer()
                Button {
                    workspaceSettingsManager.settings.tasks.append(newTask)
                    try? workspaceSettingsManager.savePreferences()
                    dismiss()
                } label: {
                    Text(String(localized: "workspace.tasks.save", defaultValue: "Save", comment: "Button to save a new task"))
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
