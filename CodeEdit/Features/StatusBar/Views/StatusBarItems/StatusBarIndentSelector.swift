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
                Text("Use Tabs", comment: "Menu item")
            }.disabled(true)

            Button {} label: {
                Text("Use Spaces", comment: "Menu item")
            }.disabled(true)

            Divider()

            Picker("Tab Width", selection: $defaultTabWidth) {
                ForEach(2..<9) { index in
                    Text("\(index) Spaces", comment: "Menu item")
                        .tag(index)
                }
            }
        } label: {
            Text("\(defaultTabWidth) Spaces", comment: "Button label")
        }
        .menuStyle(StatusBarMenuStyle())
        .onHover { isHovering($0) }
    }
}
