//
//  HelpCommands.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 14/03/2023.
//

import SwiftUI

struct HelpCommands: Commands {
    var body: some Commands {
        CommandGroup(after: .help) {
            Button("String(localized: "whats_new_in_codeedit", comment: "Help menu command to show what's new")") {

            }
            .disabled(true)

            Button("String(localized: "release_notes", comment: "Help menu command to show release notes")") {
            }
            .disabled(true)

            Button("String(localized: "report_an_issue", comment: "Help menu command to report an issue")") {
                NSApp.sendAction(#selector(AppDelegate.openFeedback(_:)), to: nil, from: nil)
            }
        }
    }
}
