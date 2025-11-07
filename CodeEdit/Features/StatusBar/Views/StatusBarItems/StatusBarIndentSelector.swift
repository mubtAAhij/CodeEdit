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
                Text(String(localized: "status-bar.indent.use-tabs", defaultValue: "Use Tabs", comment: "Menu item to use tabs for indentation"))
            }.disabled(true)

            Button {} label: {
                Text(String(localized: "status-bar.indent.use-spaces", defaultValue: "Use Spaces", comment: "Menu item to use spaces for indentation"))
            }.disabled(true)

            Divider()

            Picker("Tab Width", selection: $defaultTabWidth) {
                ForEach(2..<9) { index in
                    let spaces = index
                    Text(String(localized: "status-bar.indent.spaces-count", defaultValue: "\(spaces) Spaces", comment: "Menu item showing number of spaces for indentation"))
                        .tag(index)
                }
            }
        } label: {
            let spaces = defaultTabWidth
            Text(String(localized: "status-bar.indent.current-spaces", defaultValue: "\(spaces) Spaces", comment: "Status bar label showing current indentation setting"))
        }
        .menuStyle(StatusBarMenuStyle())
        .onHover { isHovering($0) }
    }
}
