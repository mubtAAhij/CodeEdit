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
                        Text(String(localized: "No remotes", comment: "Message when repository has no remotes"))
                    }, icon: {
                        Image(systemName: "network")
                            .foregroundColor(.secondary)
                    }
                )
                Spacer()
                Button(String(localized: "Add", comment: "Add button for adding remote")) {
                    sourceControlManager.addExistingRemoteSheetIsPresented = true
                }
            }
        }
    }
}
