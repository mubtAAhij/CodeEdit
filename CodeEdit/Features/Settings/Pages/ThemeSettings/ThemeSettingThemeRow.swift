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
                    Text("theme.choose", comment: "Choose button")
                }
                .buttonStyle(.bordered)
                .opacity(isHovering ? 1 : 0)
            }
            ThemeSettingsColorPreview(theme)
            Menu {
                Button("theme.details", comment: "Details menu item") {
                    themeModel.detailsTheme = theme
                    themeModel.detailsIsPresented = true
                }
                Button("theme.duplicate", comment: "Duplicate menu item") {
                    if let fileURL = theme.fileURL {
                        themeModel.duplicate(fileURL)
                    }
                }
                Button("theme.export", comment: "Export menu item") {
                    themeModel.exportTheme(theme)
                }
                .disabled(theme.isBundled)
                Divider()
                Button("theme.delete", comment: "Delete menu item") {
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
            Text("theme.delete_confirmation \(theme.displayName)", comment: "Delete theme confirmation"),
            isPresented: $deleteConfirmationIsPresented
        ) {
            Button("theme.delete_theme", comment: "Delete Theme button") {
                themeModel.delete(theme)
            }
            Button("actions.cancel", comment: "Cancel button") {
                deleteConfirmationIsPresented = false
            }
        } message: {
            Text("theme.delete_warning", comment: "Delete warning message")
        }
    }
}
