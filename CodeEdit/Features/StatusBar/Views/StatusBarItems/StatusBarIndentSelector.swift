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
                Text(String(localized: "status-bar.indent-selector.use-tabs", defaultValue: "Use Tabs", comment: "Menu option to use tabs for indentation"))
            }.disabled(true)

            Button {} label: {
                Text(String(localized: "status-bar.indent-selector.use-spaces", defaultValue: "Use Spaces", comment: "Menu option to use spaces for indentation"))
            }.disabled(true)

            Divider()

            Picker(String(localized: "status-bar.indent-selector.tab-width", defaultValue: "Tab Width", comment: "Menu section title for selecting tab width"), selection: $defaultTabWidth) {
                ForEach(2..<9) { index in
                    Text(String(format: String(localized: "status-bar.indent-selector.index-spaces", defaultValue: "%d Spaces", comment: "Menu option showing indentation width in spaces for each selectable index"), index))
                        .tag(index)
                }
            }
        } label: {
            Text(String(format: String(localized: "status-bar.indent-selector.default-spaces", defaultValue: "%d Spaces", comment: "Current default indentation width displayed in spaces"), defaultTabWidth))
        }
        .menuStyle(StatusBarMenuStyle())
        .onHover { isHovering($0) }
    }
}
