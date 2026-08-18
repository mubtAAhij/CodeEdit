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
                    Text(String(
                        localized: "settings.theme.row.choose.button",
                        defaultValue: "Choose",
                        comment: "Button title to choose a theme."
                    ))
                }
                .buttonStyle(.bordered)
                .opacity(isHovering ? 1 : 0)
            }
            ThemeSettingsColorPreview(theme)
            Menu {
                Button(String(
                    localized: "settings.theme.row.details.button",
                    defaultValue: "Details...",
                    comment: "Button title to show theme details."
                )) {
                    themeModel.detailsTheme = theme
                    themeModel.detailsIsPresented = true
                }
                Button(String(
                    localized: "settings.theme.row.duplicate.button",
                    defaultValue: "Duplicate...",
                    comment: "Button title to duplicate a theme."
                )) {
                    if let fileURL = theme.fileURL {
                        themeModel.duplicate(fileURL)
                    }
                }
                Button(String(
                    localized: "settings.theme.row.export.button",
                    defaultValue: "Export...",
                    comment: "Button title to export a theme."
                )) {
                    themeModel.exportTheme(theme)
                }
                .disabled(theme.isBundled)
                Divider()
                Button(String(
                    localized: "settings.theme.row.delete.button",
                    defaultValue: "Delete...",
                    comment: "Button title to delete a theme."
                )) {
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
            Text(String(format: String(
                localized: "settings.theme.row.delete.confirmation.message",
                defaultValue: "Are you sure you want to delete the theme “%@”?",
                comment: "Confirmation message before deleting a theme."
            ), "\(theme.displayName)")),
            isPresented: $deleteConfirmationIsPresented
        ) {
            Button(String(
                localized: "settings.theme.row.delete.confirmation.title",
                defaultValue: "Delete Theme",
                comment: "Alert title for deleting a theme."
            )) {
                themeModel.delete(theme)
            }
            Button(String(
                localized: "settings.theme.row.delete.confirmation.cancel",
                defaultValue: "Cancel",
                comment: "Cancel button in delete theme confirmation."
            )) {
                deleteConfirmationIsPresented = false
            }
        } message: {
            Text(String(
                localized: "settings.theme.row.delete.confirmation.footnote",
                defaultValue: "This action cannot be undone.",
                comment: "Warning text in delete theme confirmation."
            ))
        }
    }
}
