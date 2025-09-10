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
                    Text("String(localized: "choose", comment: "Choose theme button text")")
                }
                .buttonStyle(.bordered)
                .opacity(isHovering ? 1 : 0)
            }
            ThemeSettingsColorPreview(theme)
            Menu {
                Button("String(localized: "details_ellipsis", comment: "Details menu item")") {
                    themeModel.detailsTheme = theme
                    themeModel.detailsIsPresented = true
                }
                Button("String(localized: "duplicate_ellipsis", comment: "Duplicate menu item")") {
                    if let fileURL = theme.fileURL {
                        themeModel.duplicate(fileURL)
                    }
                }
                Button("String(localized: "export_ellipsis", comment: "Export menu item")") {
                    themeModel.exportTheme(theme)
                }
                .disabled(theme.isBundled)
                Divider()
                Button("String(localized: "delete_ellipsis", comment: "Delete menu item")") {
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
            Text("Are you sure you want to delete the theme “\(theme.displayName)”?"),
            isPresented: $deleteConfirmationIsPresented
        ) {
            Button("String(localized: "delete_theme", comment: "Button text to delete a theme")") {
                themeModel.delete(theme)
            }
            Button("String(localized: "cancel", comment: "Cancel button text")") {
                deleteConfirmationIsPresented = false
            }
        } message: {
            Text("String(localized: "action_cannot_be_undone", comment: "Warning message that an action cannot be undone")")
        }
    }
}
