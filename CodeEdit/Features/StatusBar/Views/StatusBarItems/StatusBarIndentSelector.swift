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
                Text(String(
                    localized: "status-bar.indent-selector.use-tabs",
                    defaultValue: "Use Tabs",
                    comment: "Menu option to use tabs for indentation"
                ))
            }.disabled(true)

            Button {} label: {
                Text(String(
                    localized: "status-bar.indent-selector.use-spaces",
                    defaultValue: "Use Spaces",
                    comment: "Menu option to use spaces for indentation"
                ))
            }.disabled(true)

            Divider()

            Picker(String(
                localized: "status-bar.indent-selector.tab-width",
                defaultValue: "Tab Width",
                comment: "Section label for tab width options in indent selector"
            ), selection: $defaultTabWidth) {
                ForEach(2..<9) { index in
                    Text(String(format: String(
                        localized: "status-bar.indent-selector.index-spaces",
                        defaultValue: "%d Spaces",
                        comment: "Menu option showing indentation width in spaces"
                    ), index))
                        .tag(index)
                }
            }
        } label: {
            Text(String(format: String(
                localized: "status-bar.indent-selector.default-tab-width-spaces",
                defaultValue: "%d Spaces",
                comment: "Menu option showing default tab width in spaces"
            ), defaultTabWidth))
        }
        .menuStyle(StatusBarMenuStyle())
        .onHover { isHovering($0) }
    }
}
