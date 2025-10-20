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
            Button(String(localized: "help.whatsNew", comment: "Menu item title")) {

            }
            .disabled(true)

            Button(String(localized: "help.releaseNotes", comment: "Menu item title")) {
            }
            .disabled(true)

            Button(String(localized: "help.reportIssue", comment: "Menu item title")) {
                NSApp.sendAction(#selector(AppDelegate.openFeedback(_:)), to: nil, from: nil)
            }
        }
    }
}
