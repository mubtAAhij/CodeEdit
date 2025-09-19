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
            Button(String(localized: "whats_new_in_codeedit", comment: "What's new in CodeEdit menu item")) {

            }
            .disabled(true)

            Button(String(localized: "release_notes", comment: "Release notes menu item")) {
            }
            .disabled(true)

            Button(String(localized: "report_an_issue", comment: "Help menu item to report bugs or issues")) {
                NSApp.sendAction(#selector(AppDelegate.openFeedback(_:)), to: nil, from: nil)
            }
        }
    }
}
