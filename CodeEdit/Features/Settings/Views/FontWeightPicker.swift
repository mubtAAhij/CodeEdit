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
        .ultraLight: String(localized: "settings.font-weight.ultra-light", defaultValue: "Ultra Light", comment: "Font weight ultra light option"),
        .thin: String(localized: "settings.font-weight.thin", defaultValue: "Thin", comment: "Font weight thin option"),
        .light: String(localized: "settings.font-weight.light", defaultValue: "Light", comment: "Font weight light option"),
        .regular: String(localized: "settings.font-weight.regular", defaultValue: "Regular", comment: "Font weight regular option"),
        .medium: String(localized: "settings.font-weight.medium", defaultValue: "Medium", comment: "Font weight medium option"),
        .semibold: String(localized: "settings.font-weight.semi-bold", defaultValue: "Semi Bold", comment: "Font weight semi bold option"),
        .bold: String(localized: "settings.font-weight.bold", defaultValue: "Bold", comment: "Font weight bold option"),
        .heavy: String(localized: "settings.font-weight.heavy", defaultValue: "Heavy", comment: "Font weight heavy option"),
        .black: String(localized: "settings.font-weight.black", defaultValue: "Black", comment: "Font weight black option")
    ]

    var body: some View {
        Picker(label ?? String(localized: "settings.font-weight.title", defaultValue: "Font Weight", comment: "Font weight picker title"), selection: $selection) {
            ForEach(fontWeights, id: \.self) { weight in
                Text(weightNames[weight] ?? String(localized: "settings.font-weight.unknown", defaultValue: "Unknown", comment: "Unknown font weight fallback"))
                    .tag(weight)
            }
        }
    }
}
