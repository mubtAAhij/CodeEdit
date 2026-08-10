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
                Text(String(localized: "status-bar.indent-selector.use-tabs", defaultValue: "Use Tabs", comment: "Menu action to switch indentation mode to tabs."))
            }.disabled(true)

            Button {} label: {
                Text(String(localized: "status-bar.indent-selector.use-spaces", defaultValue: "Use Spaces", comment: "Menu action to switch indentation mode to spaces."))
            }.disabled(true)

            Divider()

            Picker(String(localized: "status-bar.indent-selector.tab-width", defaultValue: "Tab Width", comment: "Menu section title for choosing tab width."), selection: $defaultTabWidth) {
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
