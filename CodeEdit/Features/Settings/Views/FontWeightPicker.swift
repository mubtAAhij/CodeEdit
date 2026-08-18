//
//  FontWeightPicker.swift
//  CodeEdit
//
//  Created by Austin Condiff on 6/13/24.
//

import SwiftUI

struct FontWeightPicker: View {
    @Binding var selection: NSFont.Weight
    var label: String?

    let fontWeights: [NSFont.Weight] = [
        .ultraLight,
        .thin,
        .light,
        .regular,
        .medium,
        .semibold,
        .bold,
        .heavy,
        .black
    ]

    var weightNames: [NSFont.Weight: String] = [
        .ultraLight: String(localized: "settings.font-weight-picker.ultra-light", defaultValue: "Ultra Light", comment: "Font weight option label for ultra light"),
        .thin: String(localized: "settings.font-weight-picker.thin", defaultValue: "Thin", comment: "Font weight option label for thin"),
        .light: String(localized: "settings.font-weight-picker.light", defaultValue: "Light", comment: "Font weight option label for light"),
        .regular: String(localized: "settings.font-weight-picker.regular", defaultValue: "Regular", comment: "Font weight option label for regular"),
        .medium: String(localized: "settings.font-weight-picker.medium", defaultValue: "Medium", comment: "Font weight option label for medium"),
        .semibold: String(localized: "settings.font-weight-picker.semi-bold", defaultValue: "Semi Bold", comment: "Font weight option label for semibold"),
        .bold: String(localized: "settings.font-weight-picker.bold", defaultValue: "Bold", comment: "Font weight option label for bold"),
        .heavy: String(localized: "settings.font-weight-picker.heavy", defaultValue: "Heavy", comment: "Font weight option label for heavy"),
        .black: String(localized: "settings.font-weight-picker.black", defaultValue: "Black", comment: "Font weight option label for black")
    ]

    var body: some View {
        Picker(label ?? String(localized: "settings.font-weight-picker.title", defaultValue: "Font Weight", comment: "Title for font weight picker control"), selection: $selection) {
            ForEach(fontWeights, id: \.self) { weight in
                Text(weightNames[weight] ?? String(localized: "settings.font-weight-picker.unknown", defaultValue: "Unknown", comment: "Fallback label for unknown font weight"))
                    .tag(weight)
            }
        }
    }
}
