//
//  StatusBarEncodingSelector.swift
//  CodeEditModules/StatusBar
//
//  Created by Lukas Pistrol on 22.03.22.
//

import SwiftUI

struct StatusBarEncodingSelector: View {

    var body: some View {
        Menu {
            // UTF 8, ASCII, ...
        } label: {
            Text(String(localized: "status-bar.encoding.utf8", defaultValue: "UTF 8", comment: "UTF-8 encoding label"))
        }
        .menuStyle(StatusBarMenuStyle())
        .onHover { isHovering($0) }
    }
}
