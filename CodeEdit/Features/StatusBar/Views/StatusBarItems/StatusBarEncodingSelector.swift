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
            Text(String(localized: "UTF 8", comment: "Label text"))
        }
        .menuStyle(StatusBarMenuStyle())
        .onHover { isHovering($0) }
    }
}
