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
                Text("indent.use_tabs", comment: "Use tabs option")
            }.disabled(true)

            Button {} label: {
                Text("indent.use_spaces", comment: "Use spaces option")
            }.disabled(true)

            Divider()

            Picker("Tab Width", selection: $defaultTabWidth) {
                ForEach(2..<9) { index in
                    Text("indent.spaces \(index)", comment: "Number of spaces for indentation")
                        .tag(index)
                }
            }
        } label: {
            Text("indent.spaces \(defaultTabWidth)", comment: "Current indent setting")
        }
        .menuStyle(StatusBarMenuStyle())
        .onHover { isHovering($0) }
    }
}
