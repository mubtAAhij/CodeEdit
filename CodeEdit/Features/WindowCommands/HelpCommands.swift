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
            Button(String(localized: "help.whats_new_in_codeedit", comment: "Menu item to show what's new in CodeEdit")) {

            }
            .disabled(true)

            Button(String(localized: "help.release_notes", comment: "Menu item to view release notes")) {
            }
            .disabled(true)

            Button(String(localized: "help.report_an_issue", comment: "Menu item to report an issue")) {
                NSApp.sendAction(#selector(AppDelegate.openFeedback(_:)), to: nil, from: nil)
            }
        }
    }
}
