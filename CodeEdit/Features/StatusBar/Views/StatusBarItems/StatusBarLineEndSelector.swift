//
//  StatusBarLineEndSelector.swift
//  CodeEditModules/StatusBar
//
//  Created by Lukas Pistrol on 22.03.22.
//

import SwiftUI

struct StatusBarLineEndSelector: View {

    var body: some View {
        Menu {
            // LF, CRLF
        } label: {
            Text(String(localized: "status-bar.line-end.lf", defaultValue: "LF", comment: "Status bar abbreviation for line feed line endings"))
        }
        .menuStyle(StatusBarMenuStyle())
        .onHover { isHovering($0) }
    }
}
