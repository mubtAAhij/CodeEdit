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
                Text(String(localized: "use_tabs", comment: "Option to use tabs for indentation"))
            }.disabled(true)

            Button {} label: {
                Text(String(localized: "use_spaces", comment: "Option to use spaces for indentation"))
            }.disabled(true)

            Divider()

            Picker("Tab Width", selection: $defaultTabWidth) {
                ForEach(2..<9) { index in
                    Text(String(localized: "indent_spaces_count", defaultValue: "\(index) Spaces", comment: "Number of spaces for indentation"))
                        .tag(index)
                }
            }
        } label: {
            Text(String(localized: "default_tab_width_spaces", defaultValue: "\(defaultTabWidth) Spaces", comment: "Default tab width in spaces"))
        }
        .menuStyle(StatusBarMenuStyle())
        .onHover { isHovering($0) }
    }
}
