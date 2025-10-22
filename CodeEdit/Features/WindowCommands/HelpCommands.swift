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
            Button(String(localized: "What's New in CodeEdit", comment: "Menu item")) {

            }
            .disabled(true)

            Button(String(localized: "Release Notes", comment: "Menu item")) {
            }
            .disabled(true)

            Button(String(localized: "Report an Issue", comment: "Menu item")) {
                NSApp.sendAction(#selector(AppDelegate.openFeedback(_:)), to: nil, from: nil)
            }
        }
    }
}
