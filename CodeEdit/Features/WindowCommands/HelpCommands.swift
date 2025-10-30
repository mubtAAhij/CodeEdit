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
            Button(String(localized: "menu.help.whats-new", defaultValue: "What's New in CodeEdit", comment: "Menu item for what's new in CodeEdit")) {

            }
            .disabled(true)

            Button(String(localized: "menu.help.release-notes", defaultValue: "Release Notes", comment: "Menu item for release notes")) {
            }
            .disabled(true)

            Button(String(localized: "menu.help.report-issue", defaultValue: "Report an Issue", comment: "Menu item to report an issue")) {
                NSApp.sendAction(#selector(AppDelegate.openFeedback(_:)), to: nil, from: nil)
            }
        }
    }
}
