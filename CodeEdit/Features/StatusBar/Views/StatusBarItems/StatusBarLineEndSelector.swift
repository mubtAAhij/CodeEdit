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
            Text(String(localized: "features.status-bar.line-end-selector.option-lf", defaultValue: "LF", comment: "Line ending selector option label for LF"))
        }
        .menuStyle(StatusBarMenuStyle())
        .onHover { isHovering($0) }
    }
}
