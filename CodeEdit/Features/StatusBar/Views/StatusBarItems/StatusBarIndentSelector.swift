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
                Text(String(localized: "editor.use-tabs", defaultValue: "Use Tabs", comment: "Use tabs option"))
            }.disabled(true)

            Button {} label: {
                Text(String(localized: "editor.use-spaces", defaultValue: "Use Spaces", comment: "Use spaces option"))
            }.disabled(true)

            Divider()

            Picker("Tab Width", selection: $defaultTabWidth) {
                ForEach(2..<9) { index in
                    Text(String(format: String(localized: "editor.n-spaces", defaultValue: "%d Spaces", comment: "Number of spaces"), index))
                        .tag(index)
                }
            }
        } label: {
            Text(String(format: String(localized: "editor.n-spaces", defaultValue: "%d Spaces", comment: "Number of spaces"), defaultTabWidth))
        }
        .menuStyle(StatusBarMenuStyle())
        .onHover { isHovering($0) }
    }
}
