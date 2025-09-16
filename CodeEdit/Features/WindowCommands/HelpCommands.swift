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
            Button(String(localized: "whats_new_in_codeedit", comment: "Menu item for What's New feature")) {

            }
            .disabled(true)

            Button(String(localized: "release_notes", comment: "Menu item for Release Notes")) {
            }
            .disabled(true)

            Button(String(localized: "report_an_issue", comment: "Menu item for reporting issues")) {
                NSApp.sendAction(#selector(AppDelegate.openFeedback(_:)), to: nil, from: nil)
            }
        }
    }
}
