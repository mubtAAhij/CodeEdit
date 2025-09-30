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
                    Text(String(localized: "choose", comment: "Button to choose/select a theme"))
                }
                .buttonStyle(.bordered)
                .opacity(isHovering ? 1 : 0)
            }
            ThemeSettingsColorPreview(theme)
            Menu {
                Button(String(localized: "details", comment: "Menu item to show theme details")) {
                    themeModel.detailsTheme = theme
                    themeModel.detailsIsPresented = true
                }
                Button(String(localized: "duplicate", comment: "Menu item to duplicate a theme")) {
                    if let fileURL = theme.fileURL {
                        themeModel.duplicate(fileURL)
                    }
                }
                Button(String(localized: "export", comment: "Menu item to export a theme")) {
                    themeModel.exportTheme(theme)
                }
                .disabled(theme.isBundled)
                Divider()
                Button(String(localized: "delete", comment: "Menu item to delete a theme")) {
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
            Button(String(localized: "delete_theme", comment: "Button to confirm theme deletion")) {
                themeModel.delete(theme)
            }
            Button(String(localized: "cancel", comment: "Button to cancel action")) {
                deleteConfirmationIsPresented = false
            }
        } message: {
            Text(String(localized: "theme_delete_warning", comment: "Warning message when deleting a theme"))
        }
    }
}
