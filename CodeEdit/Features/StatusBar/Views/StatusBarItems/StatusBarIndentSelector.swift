//
//  StatusBarIndentSelector.swift
//  CodeEditModules/StatusBar
//
//  Created by Lukas Pistrol on 22.03.22.
//

import SwiftUI

struct StatusBarIndentSelector: View {
    @AppSettings(\.textEditing.defaultTabWidth)
    var defaultTabWidth

    var body: some View {
        Menu {
            Button {} label: {
                Text("String(localized: "use_tabs", comment: "Menu option to use tabs for indentation")")
            }.disabled(true)

            Button {} label: {
                Text("String(localized: "use_spaces", comment: "Menu option to use spaces for indentation")")
            }.disabled(true)

            Divider()

            Picker("Tab Width", selection: $defaultTabWidth) {
                ForEach(2..<9) { index in
                    Text("String(localized: "spaces_count", comment: "Menu option showing number of spaces for indentation")")
                        .tag(index)
                }
            }
        } label: {
            Text("String(localized: "default_spaces_count", comment: "Status bar label showing default number of spaces")")
        }
        .menuStyle(StatusBarMenuStyle())
        .onHover { isHovering($0) }
    }
}
