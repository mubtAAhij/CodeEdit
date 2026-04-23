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
                    Text(String(localized: "theme-row.choose", defaultValue: "Choose", comment: "Choose theme button"))
                }
                .buttonStyle(.bordered)
                .opacity(isHovering ? 1 : 0)
            }
            ThemeSettingsColorPreview(theme)
            Menu {
                Button(String(localized: "theme-row.details", defaultValue: "Details...", comment: "Details menu item")) {
                    themeModel.detailsTheme = theme
                    themeModel.detailsIsPresented = true
                }
                Button(String(localized: "theme-row.duplicate", defaultValue: "Duplicate...", comment: "Duplicate menu item")) {
                    if let fileURL = theme.fileURL {
                        themeModel.duplicate(fileURL)
                    }
                }
                Button(String(localized: "theme-row.export", defaultValue: "Export...", comment: "Export menu item")) {
                    themeModel.exportTheme(theme)
                }
                .disabled(theme.isBundled)
                Divider()
                Button(String(localized: "theme-row.delete", defaultValue: "Delete...", comment: "Delete menu item")) {
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
            Text(String(format: String(localized: "theme-row.delete-confirmation", defaultValue: "Are you sure you want to delete the theme \"%@\"?", comment: "Delete theme confirmation message"), theme.displayName)),
            isPresented: $deleteConfirmationIsPresented
        ) {
            Button(String(localized: "theme-row.delete-theme", defaultValue: "Delete Theme", comment: "Delete theme button")) {
                themeModel.delete(theme)
            }
            Button(String(localized: "theme-row.cancel", defaultValue: "Cancel", comment: "Cancel button")) {
                deleteConfirmationIsPresented = false
            }
        } message: {
            Text(String(localized: "theme-row.delete-warning", defaultValue: "This action cannot be undone.", comment: "Delete theme warning message"))
        }
    }
}
