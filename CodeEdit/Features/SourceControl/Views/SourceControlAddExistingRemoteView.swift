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
                Section(String(localized: "source-control.add-remote.title", defaultValue: "Add Remote", comment: "Title for add remote dialog")) {
                    TextField(String(localized: "source-control.add-remote.name", defaultValue: "Remote Name", comment: "Text field placeholder for remote name"), value: $name, formatter: RegexFormatter(pattern: "[^a-zA-Z0-9_-]"))
                        .focused($focusedField, equals: .name)
                    TextField(String(localized: "source-control.add-remote.location", defaultValue: "Location", comment: "Text field placeholder for remote location"), value: $location, formatter: TrimWhitespaceFormatter())
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
                    Text(String(localized: "source-control.add-remote.cancel", defaultValue: "Cancel", comment: "Cancel button in add remote dialog"))
                        .frame(minWidth: 56)
                }
                Button {
                    submit()
                } label: {
                    Text(String(localized: "source-control.add-remote.add", defaultValue: "Add", comment: "Add button in add remote dialog"))
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
                await sourceControlManager.showAlertForError(title: String(localized: "source-control.add-remote.error", defaultValue: "Failed to add remote", comment: "Error title when adding remote fails"), error: error)
            }
        }
    }
}
