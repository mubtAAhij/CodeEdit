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
                Text(String(localized: "statusBar.useTabs", comment: "Menu item"))
            }.disabled(true)

            Button {} label: {
                Text(String(localized: "statusBar.useSpaces", comment: "Menu item"))
            }.disabled(true)

            Divider()

            Picker("Tab Width", selection: $defaultTabWidth) {
                ForEach(2..<9) { index in
                    Text(String(localized: "statusBar.indexSpaces", comment: "Menu item", defaultValue: "\(index) Spaces"))
                        .tag(index)
                }
            }
        } label: {
            Text(String(localized: "statusBar.defaultWidthSpaces", comment: "Label text", defaultValue: "\(defaultTabWidth) Spaces"))
        }
        .menuStyle(StatusBarMenuStyle())
        .onHover { isHovering($0) }
    }
}
