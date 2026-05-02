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
            Image(systemName: String(localized: "theme-row.checkmark-icon", defaultValue: "checkmark", comment: "SF Symbol name for theme selection checkmark"))
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
                    Text(String(localized: "theme-row.choose", defaultValue: "Choose", comment: "Button to choose theme"))
                }
                .buttonStyle(.bordered)
                .opacity(isHovering ? 1 : 0)
            }
            ThemeSettingsColorPreview(theme)
            Menu {
                Button(String(localized: "theme-row.details", defaultValue: "Details...", comment: "Menu item to show theme details")) {
                    themeModel.detailsTheme = theme
                    themeModel.detailsIsPresented = true
                }
                Button(String(localized: "theme-row.duplicate", defaultValue: "Duplicate...", comment: "Menu item to duplicate theme")) {
                    if let fileURL = theme.fileURL {
                        themeModel.duplicate(fileURL)
                    }
                }
                Button(String(localized: "theme-row.export", defaultValue: "Export...", comment: "Menu item to export theme")) {
                    themeModel.exportTheme(theme)
                }
                .disabled(theme.isBundled)
                Divider()
                Button(String(localized: "theme-row.delete", defaultValue: "Delete...", comment: "Menu item to delete theme")) {
                    deleteConfirmationIsPresented = true
                }
                .disabled(theme.isBundled)
            } label: {
                Image(systemName: String(localized: "theme-row.menu-icon", defaultValue: "ellipsis.circle", comment: "SF Symbol name for theme menu icon"))
                    .font(.system(size: 16))
            }
            .buttonStyle(.icon)
        }
        .padding(10)
        .onHover { hovering in
            isHovering = hovering
        }
        .alert(
            Text(String(format: String(localized: "theme-row.delete-confirmation", defaultValue: "Are you sure you want to delete the theme \"%@\"?", comment: "Confirmation message for deleting theme"), theme.displayName)),
            isPresented: $deleteConfirmationIsPresented
        ) {
            Button(String(localized: "theme-row.delete-button", defaultValue: "Delete Theme", comment: "Button to confirm theme deletion")) {
                themeModel.delete(theme)
            }
            Button(String(localized: "theme-row.cancel", defaultValue: "Cancel", comment: "Button to cancel deletion")) {
                deleteConfirmationIsPresented = false
            }
        } message: {
            Text(String(localized: "theme-row.delete-warning", defaultValue: "This action cannot be undone.", comment: "Warning that deletion is permanent"))
        }
    }
}
