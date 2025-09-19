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
                Text(String(localized: "use_tabs", comment: "Use tabs for indentation option"))
            }.disabled(true)

            Button {} label: {
                Text(String(localized: "use_spaces", comment: "Use spaces for indentation option"))
            }.disabled(true)

            Divider()

            Picker("Tab Width", selection: $defaultTabWidth) {
                ForEach(2..<9) { index in
                    Text(String(localized: "spaces_count_format", arguments: [index], comment: "Number of spaces format"))
                        .tag(index)
                }
            }
        } label: {
            Text(String(localized: "default_tab_width_spaces_format", arguments: [defaultTabWidth], comment: "Default tab width in spaces format"))
        }
        .menuStyle(StatusBarMenuStyle())
        .onHover { isHovering($0) }
    }
}
