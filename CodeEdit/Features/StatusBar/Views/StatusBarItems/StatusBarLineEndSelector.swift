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
            Text("String(localized: "lf_line_ending", comment: "LF line ending type label")")
        }
        .menuStyle(StatusBarMenuStyle())
        .onHover { isHovering($0) }
    }
}
