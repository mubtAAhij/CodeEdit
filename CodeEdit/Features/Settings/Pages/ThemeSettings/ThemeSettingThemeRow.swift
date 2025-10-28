//
//  ThemeSettingThemeRow.swift
//  CodeEdit
//
//  Created by Austin Condiff on 4/3/23.
//

import SwiftUI

struct ThemeSettingsThemeRow: View {
    @Binding var theme: Theme
    var active: Bool

    @ObservedObject private var themeModel: ThemeModel = .shared

    @State private var isHovering = false

    @State private var deleteConfirmationIsPresented = false

    var body: some View {
        HStack {
            Image(systemName: "checkmark")
                .opacity(active ? 1 : 0)
                .font(.system(size: 10.5, weight: .bold))
            VStack(alignment: .leading) {
                Text(theme.displayName)
                Text(theme.author)
                    .foregroundColor(.secondary)
                    .font(.footnote)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            if !active {
                Button {
                    themeModel.activateTheme(theme)
                } label: {
                    Text("theme.choose", comment: "Button text")
                }
                .buttonStyle(.bordered)
                .opacity(isHovering ? 1 : 0)
            }
            ThemeSettingsColorPreview(theme)
            Menu {
                Button("theme.details", comment: "Button text") {
                    themeModel.detailsTheme = theme
                    themeModel.detailsIsPresented = true
                }
                Button("theme.duplicate", comment: "Button text") {
                    if let fileURL = theme.fileURL {
                        themeModel.duplicate(fileURL)
                    }
                }
                Button("theme.export", comment: "Button text") {
                    themeModel.exportTheme(theme)
                }
                .disabled(theme.isBundled)
                Divider()
                Button("theme.delete", comment: "Button text") {
                    deleteConfirmationIsPresented = true
                }
                .disabled(theme.isBundled)
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.system(size: 16))
            }
            .buttonStyle(.icon)
        }
        .padding(10)
        .onHover { hovering in
            isHovering = hovering
        }
        .alert(
            Text("theme.delete.confirm \(theme.displayName)", comment: "Alert message"),
            isPresented: $deleteConfirmationIsPresented
        ) {
            Button("theme.delete.action", comment: "Button text") {
                themeModel.delete(theme)
            }
            Button("actions.cancel", comment: "Button text") {
                deleteConfirmationIsPresented = false
            }
        } message: {
            Text("theme.delete.warning", comment: "Alert warning")
        }
    }
}
