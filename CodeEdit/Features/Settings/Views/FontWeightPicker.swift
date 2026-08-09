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
        .ultraLight: String(localized: "font_weight.ultra_light", defaultValue: "Ultra Light", comment: "Font weight option label for ultra light weight"),
        .thin: String(localized: "font_weight.thin", defaultValue: "Thin", comment: "Font weight option label for thin weight"),
        .light: String(localized: "font_weight.light", defaultValue: "Light", comment: "Font weight option label for light weight"),
        .regular: String(localized: "font_weight.regular", defaultValue: "Regular", comment: "Font weight option label for regular weight"),
        .medium: String(localized: "font_weight.medium", defaultValue: "Medium", comment: "Font weight option label for medium weight"),
        .semibold: String(localized: "font_weight.semi_bold", defaultValue: "Semi Bold", comment: "Font weight option label for semi bold weight"),
        .bold: String(localized: "font_weight.bold", defaultValue: "Bold", comment: "Font weight option label for bold weight"),
        .heavy: String(localized: "font_weight.heavy", defaultValue: "Heavy", comment: "Font weight option label for heavy weight"),
        .black: String(localized: "font_weight.black", defaultValue: "Black", comment: "Font weight option label for black weight")
    ]

    var body: some View {
        Picker(label ?? String(localized: "settings.font.weight", defaultValue: "Font Weight", comment: "Title label for font weight picker control"), selection: $selection) {
            ForEach(fontWeights, id: \.self) { weight in
                Text(weightNames[weight] ?? String(localized: "font_weight.unknown", defaultValue: "Unknown", comment: "Fallback label for unknown font weight"))
                    .tag(weight)
            }
        }
    }
}
