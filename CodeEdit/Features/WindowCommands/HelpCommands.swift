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
            Button(String(localized: "help_menu.whats_new", comment: "What's New in CodeEdit menu item")) {

            }
            .disabled(true)

            Button(String(localized: "help_menu.release_notes", comment: "Release Notes menu item")) {
            }
            .disabled(true)

            Button(String(localized: "help_menu.report_issue", comment: "Report an Issue menu item")) {
                NSApp.sendAction(#selector(AppDelegate.openFeedback(_:)), to: nil, from: nil)
            }
        }
    }
}
