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
            Button(String(localized: "window-commands.help.whats-new-in-codeedit", defaultValue: "What's New in CodeEdit", comment: "Help menu item title to show what's new in CodeEdit")) {

            }
            .disabled(true)

            Button(String(localized: "window-commands.help.release-notes", defaultValue: "Release Notes", comment: "Help menu item title to open release notes")) {
            }
            .disabled(true)

            Button(String(localized: "window-commands.help.report-an-issue", defaultValue: "Report an Issue", comment: "Help menu item title to report an issue")) {
                NSApp.sendAction(#selector(AppDelegate.openFeedback(_:)), to: nil, from: nil)
            }
        }
    }
}
