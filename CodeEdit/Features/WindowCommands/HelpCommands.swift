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
            Button("help.whats_new", comment: "What's New menu item") {

            }
            .disabled(true)

            Button("help.release_notes", comment: "Release Notes menu item") {
            }
            .disabled(true)

            Button("help.report_issue", comment: "Report an Issue menu item") {
                NSApp.sendAction(#selector(AppDelegate.openFeedback(_:)), to: nil, from: nil)
            }
        }
    }
}
