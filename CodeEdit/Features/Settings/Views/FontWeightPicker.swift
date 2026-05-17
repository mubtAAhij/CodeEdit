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
        .ultraLight: String(localized: "settings.font-weight.ultra-light", defaultValue: "Ultra Light", comment: "Font weight label for ultra light"),
        .thin: String(localized: "settings.font-weight.thin", defaultValue: "Thin", comment: "Font weight label for thin"),
        .light: String(localized: "settings.font-weight.light", defaultValue: "Light", comment: "Font weight label for light"),
        .regular: String(localized: "settings.font-weight.regular", defaultValue: "Regular", comment: "Font weight label for regular"),
        .medium: String(localized: "settings.font-weight.medium", defaultValue: "Medium", comment: "Font weight label for medium"),
        .semibold: String(localized: "settings.font-weight.semi-bold", defaultValue: "Semi Bold", comment: "Font weight label for semi bold"),
        .bold: String(localized: "settings.font-weight.bold", defaultValue: "Bold", comment: "Font weight label for bold"),
        .heavy: String(localized: "settings.font-weight.heavy", defaultValue: "Heavy", comment: "Font weight label for heavy"),
        .black: String(localized: "settings.font-weight.black", defaultValue: "Black", comment: "Font weight label for black")
    ]

    var body: some View {
        Picker(label ?? String(localized: "settings.font-weight.label", defaultValue: "Font Weight", comment: "Label for font weight picker"), selection: $selection) {
            ForEach(fontWeights, id: \.self) { weight in
                Text(weightNames[weight] ?? String(localized: "settings.font-weight.unknown", defaultValue: "Unknown", comment: "Fallback label for unknown font weight"))
                    .tag(weight)
            }
        }
    }
}
