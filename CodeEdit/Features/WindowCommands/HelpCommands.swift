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
            Button(String(localized: "menu.help.whats-new", defaultValue: "What's New in CodeEdit", comment: "Help menu item for what's new")) {

            }
            .disabled(true)

            Button(String(localized: "menu.help.release-notes", defaultValue: "Release Notes", comment: "Help menu item for release notes")) {
            }
            .disabled(true)

            Button(String(localized: "menu.help.report-issue", defaultValue: "Report an Issue", comment: "Help menu item for reporting issues")) {
                NSApp.sendAction(#selector(AppDelegate.openFeedback(_:)), to: nil, from: nil)
            }
        }
    }
}
