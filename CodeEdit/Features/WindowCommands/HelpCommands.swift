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
            Button(String(localized: "menu.whats-new", defaultValue: "What's New in CodeEdit", comment: "What's New menu item")) {

            }
            .disabled(true)

            Button(String(localized: "menu.release-notes", defaultValue: "Release Notes", comment: "Release Notes menu item")) {
            }
            .disabled(true)

            Button(String(localized: "menu.report-issue", defaultValue: "Report an Issue", comment: "Report an Issue menu item")) {
                NSApp.sendAction(#selector(AppDelegate.openFeedback(_:)), to: nil, from: nil)
            }
        }
    }
}
