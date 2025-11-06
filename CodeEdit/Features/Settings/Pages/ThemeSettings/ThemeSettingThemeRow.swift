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
                    Text(String(localized: "settings.theme.choose", defaultValue: "Choose", comment: "Button to choose theme"))
                }
                .buttonStyle(.bordered)
                .opacity(isHovering ? 1 : 0)
            }
            ThemeSettingsColorPreview(theme)
            Menu {
                Button(String(localized: "settings.theme.details", defaultValue: "Details...", comment: "Menu item to view theme details")) {
                    themeModel.detailsTheme = theme
                    themeModel.detailsIsPresented = true
                }
                Button(String(localized: "settings.theme.duplicate", defaultValue: "Duplicate...", comment: "Menu item to duplicate theme")) {
                    if let fileURL = theme.fileURL {
                        themeModel.duplicate(fileURL)
                    }
                }
                Button(String(localized: "settings.theme.export", defaultValue: "Export...", comment: "Menu item to export theme")) {
                    themeModel.exportTheme(theme)
                }
                .disabled(theme.isBundled)
                Divider()
                Button(String(localized: "settings.theme.delete", defaultValue: "Delete...", comment: "Menu item to delete theme")) {
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
            Text(String(localized: "settings.theme.delete-confirm", defaultValue: "Are you sure you want to delete the theme \"\(theme.displayName)\"?", comment: "Confirmation prompt to delete theme")),
            isPresented: $deleteConfirmationIsPresented
        ) {
            Button(String(localized: "settings.theme.delete-button", defaultValue: "Delete Theme", comment: "Button to delete theme")) {
                themeModel.delete(theme)
            }
            Button(String(localized: "common.cancel", defaultValue: "Cancel", comment: "Cancel button title")) {
                deleteConfirmationIsPresented = false
            }
        } message: {
            Text(String(localized: "settings.theme.delete-warning", defaultValue: "This action cannot be undone.", comment: "Warning that theme deletion cannot be undone"))
        }
    }
}
