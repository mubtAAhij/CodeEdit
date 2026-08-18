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
                Text(String(localized: "status-bar.indent-selector.use-tabs", defaultValue: "Use Tabs", comment: "Menu action to configure indentation with tabs"))
            }.disabled(true)

            Button {} label: {
                Text(String(localized: "status-bar.indent-selector.use-spaces", defaultValue: "Use Spaces", comment: "Menu action to configure indentation with spaces"))
            }.disabled(true)

            Divider()

            Picker(String(localized: "status-bar.indent-selector.tab-width", defaultValue: "Tab Width", comment: "Section header for tab width selection"), selection: $defaultTabWidth) {
                ForEach(2..<9) { index in
                    Text(String(format: String(localized: "status-bar.indent-selector.index-spaces", defaultValue: "%d Spaces", comment: "Menu item showing a selectable space indentation width"), index))
                        .tag(index)
                }
            }
        } label: {
            Text(String(format: String(localized: "status-bar.indent-selector.default-spaces", defaultValue: "%d Spaces", comment: "Current default space indentation width label"), defaultTabWidth))
        }
        .menuStyle(StatusBarMenuStyle())
        .onHover { isHovering($0) }
    }
}
