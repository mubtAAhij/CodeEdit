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
                Section(String(localized: "source-control.add-existing-remote.title", defaultValue: "Add Remote", comment: "Title for add existing remote sheet")) {
                    TextField(String(localized: "source-control.add-existing-remote.remote-name", defaultValue: "Remote Name", comment: "Label or placeholder for remote name field"), value: $name, formatter: RegexFormatter(pattern: "[^a-zA-Z0-9_-]"))
                        .focused($focusedField, equals: .name)
                    TextField(String(localized: "source-control.add-existing-remote.location", defaultValue: "Location", comment: "Label or placeholder for remote location field"), value: $location, formatter: TrimWhitespaceFormatter())
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
                    Text(String(localized: "source-control.add-existing-remote.cancel", defaultValue: "Cancel", comment: "Cancel button title in add existing remote sheet"))
                        .frame(minWidth: 56)
                }
                Button {
                    submit()
                } label: {
                    Text(String(localized: "source-control.add-existing-remote.add", defaultValue: "Add", comment: "Confirm button title to add remote"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(width: 500)
        .onAppear {
            let originExists = sourceControlManager.remotes.contains { $0.name == "origin" }

            if !originExists {
                name = "origin"
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
                await sourceControlManager.showAlertForError(title: String(localized: "source-control.add-existing-remote.failed-to-add-remote", defaultValue: "Failed to add remote", comment: "Error title shown when adding remote fails"), error: error)
            }
        }
    }
}
