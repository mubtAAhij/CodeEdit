//
//  SourceControlAddExistingRemoteView.swift
//  CodeEdit
//
//  Created by Austin Condiff on 11/17/23.
//

import SwiftUI

struct SourceControlAddExistingRemoteView: View {
    @EnvironmentObject var sourceControlManager: SourceControlManager
    @Environment(\.dismiss)
    private var dismiss

    @State private var name: String = ""
    @State private var location: String = ""

    enum FocusedField {
        case name, location
    }

    @FocusState private var focusedField: FocusedField?

    var body: some View {
        VStack(spacing: 0) {
            Form {
                Section(String(localized: "sourcecontrol.remote.add", defaultValue: "Add Remote", comment: "Add Remote section header")) {
                    TextField(String(localized: "sourcecontrol.remote.name", defaultValue: "Remote Name", comment: "Remote Name text field label"), value: $name, formatter: RegexFormatter(pattern: String(localized: "sourcecontrol.remote.name.pattern", defaultValue: "[^a-zA-Z0-9_-]", comment: "Regex pattern for remote name validation")))
                        .focused($focusedField, equals: .name)
                    TextField(String(localized: "sourcecontrol.remote.location", defaultValue: "Location", comment: "Location text field label"), value: $location, formatter: TrimWhitespaceFormatter())
                        .focused($focusedField, equals: .location)
                }
            }
            .formStyle(.grouped)
            .scrollDisabled(true)
            .scrollContentBackground(.hidden)
            .onSubmit(submit)
            HStack {
                Spacer()
                Button {
                    dismiss()
                    name = ""
                    location = ""
                } label: {
                    Text(String(localized: "general.cancel", defaultValue: "Cancel", comment: "Cancel button"))
                        .frame(minWidth: 56)
                }
                Button {
                    submit()
                } label: {
                    Text(String(localized: "general.add", defaultValue: "Add", comment: "Add button"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(width: 500)
        .onAppear {
            let originExists = sourceControlManager.remotes.contains { $0.name == String(localized: "sourcecontrol.remote.default.name", defaultValue: "origin", comment: "Default remote name") }

            if !originExists {
                name = String(localized: "sourcecontrol.remote.default.name", defaultValue: "origin", comment: "Default remote name")
                focusedField = .location
            }
        }
    }

    func submit() {
        Task {
            do {
                try await sourceControlManager.addRemote(name: name, location: location)
                if sourceControlManager.pullSheetIsPresented || sourceControlManager.pushSheetIsPresented {
                    sourceControlManager.operationRemote = sourceControlManager.remotes.first(
                        where: { $0.name == name }
                    )
                }
                name = ""
                location = ""
                dismiss()
            } catch {
                await sourceControlManager.showAlertForError(title: String(localized: "sourcecontrol.remote.add.failed", defaultValue: "Failed to add remote", comment: "Failed to add remote error title"), error: error)
            }
        }
    }
}
