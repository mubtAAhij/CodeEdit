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
                Text("editor.use_tabs", comment: "Use tabs for indentation")
            }.disabled(true)

            Button {} label: {
                Text("editor.use_spaces", comment: "Use spaces for indentation")
            }.disabled(true)

            Divider()

            Picker("Tab Width", selection: $defaultTabWidth) {
                ForEach(2..<9) { index in
                    Text("editor.spaces_count \(index)", comment: "Number of spaces for indentation")
                        .tag(index)
                }
            }
        } label: {
            Text("editor.default_spaces \(defaultTabWidth)", comment: "Default number of spaces")
        }
        .menuStyle(StatusBarMenuStyle())
        .onHover { isHovering($0) }
    }
}
