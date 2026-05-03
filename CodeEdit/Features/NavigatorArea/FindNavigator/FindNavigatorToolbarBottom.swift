//
//  SourceControlToolbarBottom.swift
//  CodeEdit
//
//  Created by Nanashi Li on 2022/05/20.
//

import SwiftUI

struct FindNavigatorToolbarBottom: View {
    @State private var text = ""

    var body: some View {
        HStack(spacing: 2) {
            PaneTextField(
                String(localized: "findnavigator.filter", defaultValue: "Filter", comment: "Filter text field placeholder"),
                text: $text,
                leadingAccessories: {
                    Image(
                        systemName: text.isEmpty
                        ? String(localized: "findnavigator.filter_icon", defaultValue: "line.3.horizontal.decrease.circle", comment: "SF Symbol for filter icon empty")
                        : String(localized: "findnavigator.filter_icon_filled", defaultValue: "line.3.horizontal.decrease.circle.fill", comment: "SF Symbol for filter icon filled")
                    )
                    .foregroundStyle(
                        text.isEmpty
                        ? Color(nsColor: .secondaryLabelColor)
                        : Color(nsColor: .controlAccentColor)
                    )
                    .padding(.leading, 4)
                    .help(String(localized: "findnavigator.filter_help", defaultValue: "Show results with matching text", comment: "Help text for filter field"))
                },
                clearable: true
            )
        }
        .frame(height: 28, alignment: .center)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 5)
        .overlay(alignment: .top) {
            Divider()
                .opacity(0)
        }
    }
}
