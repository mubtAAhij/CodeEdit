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
                Text(String(localized: "status-bar.indent.use-tabs", defaultValue: "Use Tabs", comment: "Menu option to use tabs for indentation"))
            }.disabled(true)

            Button {} label: {
                Text(String(localized: "status-bar.indent.use-spaces", defaultValue: "Use Spaces", comment: "Menu option to use spaces for indentation"))
            }.disabled(true)

            Divider()

            Picker(String(localized: "status-bar.indent.tab-width", defaultValue: "Tab Width", comment: "Submenu title for selecting tab width"), selection: $defaultTabWidth) {
                ForEach(2..<9) { index in
                    Text("\(index) Spaces")
                        .tag(index)
                }
            }
        } label: {
            Text("\(defaultTabWidth) Spaces")
        }
        .menuStyle(StatusBarMenuStyle())
        .onHover { isHovering($0) }
    }
}
