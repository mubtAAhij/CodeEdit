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
            Button(String(localized: "help_commands.whats_new", comment: "What's New in CodeEdit help menu item")) {

            }
            .disabled(true)

            Button(String(localized: "help_commands.release_notes", comment: "Release Notes help menu item")) {
            }
            .disabled(true)

            Button(String(localized: "help_commands.report_issue", comment: "Report an Issue help menu item")) {
                NSApp.sendAction(#selector(AppDelegate.openFeedback(_:)), to: nil, from: nil)
            }
        }
    }
}
