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
                    Text(String(localized: "theme-settings.button.choose", defaultValue: "Choose", comment: "Button to choose a theme"))
                }
                .buttonStyle(.bordered)
                .opacity(isHovering ? 1 : 0)
            }
            ThemeSettingsColorPreview(theme)
            Menu {
                Button(String(localized: "theme-settings.menu.details", defaultValue: "Details...", comment: "Menu item to show theme details")) {
                    themeModel.detailsTheme = theme
                    themeModel.detailsIsPresented = true
                }
                Button(String(localized: "theme-settings.menu.duplicate", defaultValue: "Duplicate...", comment: "Menu item to duplicate a theme")) {
                    if let fileURL = theme.fileURL {
                        themeModel.duplicate(fileURL)
                    }
                }
                Button(String(localized: "theme-settings.menu.export", defaultValue: "Export...", comment: "Menu item to export a theme")) {
                    themeModel.exportTheme(theme)
                }
                .disabled(theme.isBundled)
                Divider()
                Button(String(localized: "theme-settings.menu.delete", defaultValue: "Delete...", comment: "Menu item to delete a theme")) {
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
            Text(String(format: String(localized: "theme-settings.alert.title", defaultValue: "Are you sure you want to delete the theme \"%@\"?", comment: "Alert title for theme deletion confirmation"), theme.displayName)),
            isPresented: $deleteConfirmationIsPresented
        ) {
            Button(String(localized: "theme-settings.alert.delete-theme", defaultValue: "Delete Theme", comment: "Alert button to confirm theme deletion")) {
                themeModel.delete(theme)
            }
            Button(String(localized: "theme-settings.alert.cancel", defaultValue: "Cancel", comment: "Alert button to cancel theme deletion")) {
                deleteConfirmationIsPresented = false
            }
        } message: {
            Text(String(localized: "theme-settings.alert.message", defaultValue: "This action cannot be undone.", comment: "Alert message warning about theme deletion"))
        }
    }
}
