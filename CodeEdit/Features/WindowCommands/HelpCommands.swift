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
            Button("help.whats_new", comment: "Menu item for What's New") {

            }
            .disabled(true)

            Button("help.release_notes", comment: "Menu item for Release Notes") {
            }
            .disabled(true)

            Button("help.report_issue", comment: "Menu item to report an issue") {
                NSApp.sendAction(#selector(AppDelegate.openFeedback(_:)), to: nil, from: nil)
            }
        }
    }
}
