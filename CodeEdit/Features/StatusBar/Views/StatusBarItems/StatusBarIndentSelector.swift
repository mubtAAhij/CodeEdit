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
                Text(String(localized: "statusbar.indent.use_tabs", defaultValue: "Use Tabs", comment: "Use tabs option"))
            }.disabled(true)

            Button {} label: {
                Text(String(localized: "statusbar.indent.use_spaces", defaultValue: "Use Spaces", comment: "Use spaces option"))
            }.disabled(true)

            Divider()

            Picker(String(localized: "statusbar.indent.tab_width", defaultValue: "Tab Width", comment: "Tab width picker label"), selection: $defaultTabWidth) {
                ForEach(2..<9) { index in
                    Text(String(
                        format: String(localized: "statusbar.indent.spaces_count", defaultValue: "%d Spaces", comment: "Number of spaces label"),
                        index
                    ))
                        .tag(index)
                }
            }
        } label: {
            Text(String(
                format: String(localized: "statusbar.indent.spaces_count", defaultValue: "%d Spaces", comment: "Number of spaces label"),
                defaultTabWidth
            ))
        }
        .menuStyle(StatusBarMenuStyle())
        .onHover { isHovering($0) }
    }
}
