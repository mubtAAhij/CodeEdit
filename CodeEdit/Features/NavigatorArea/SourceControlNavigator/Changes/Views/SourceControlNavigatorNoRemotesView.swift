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
                        Text(String(localized: "no_remotes", comment: "Label text when no git remotes are configured"))
                    }, icon: {
                        Image(systemName: "network")
                            .foregroundColor(.secondary)
                    }
                )
                Spacer()
                Button(String(localized: "add", comment: "Button text to add a new git remote")) {
                    sourceControlManager.addExistingRemoteSheetIsPresented = true
                }
            }
        }
    }
}
