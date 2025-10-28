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
        self._newTask = StateObject(wrappedValue: CETask(target: "My Mac"))
    }
    var body: some View {
        VStack(spacing: 0) {
            CETaskFormView(task: newTask)
            Divider()
            HStack {
                Button {
                    dismiss()
                } label: {
                    Text("actions.cancel", comment: "Button to cancel action")
                        .frame(minWidth: 56)
                }
                Spacer()
                Button {
                    workspaceSettingsManager.settings.tasks.append(newTask)
                    try? workspaceSettingsManager.savePreferences()
                    dismiss()
                } label: {
                    Text("actions.save", comment: "Button to save task")
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
