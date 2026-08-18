//
//  SourceControlNavigatorNoRemotesView.swift
//  CodeEdit
//
//  Created by Austin Condiff on 11/17/23.
//

import SwiftUI

struct SourceControlNavigatorNoRemotesView: View {
    @EnvironmentObject var sourceControlManager: SourceControlManager

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Label(
                    title: {
                        Text(String(
                            localized: "source-control.navigator.no-remotes.title",
                            defaultValue: "No remotes",
                            comment: "Title shown when there are no remotes configured"
                        ))
                    }, icon: {
                        Image(systemName: "network")
                            .foregroundColor(.secondary)
                    }
                )
                Spacer()
                Button(String(
                    localized: "source-control.navigator.no-remotes.add",
                    defaultValue: "Add",
                    comment: "Button title to add a remote"
                )) {
                    sourceControlManager.addExistingRemoteSheetIsPresented = true
                }
            }
        }
    }
}
