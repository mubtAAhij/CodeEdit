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

    var weightNames: [NSFont.Weight: String] {
        [
            .ultraLight: String(localized: "settings.font-weight.ultra-light", defaultValue: "Ultra Light", comment: "Font weight: Ultra Light"),
            .thin: String(localized: "settings.font-weight.thin", defaultValue: "Thin", comment: "Font weight: Thin"),
            .light: String(localized: "settings.font-weight.light", defaultValue: "Light", comment: "Font weight: Light"),
            .regular: String(localized: "settings.font-weight.regular", defaultValue: "Regular", comment: "Font weight: Regular"),
            .medium: String(localized: "settings.font-weight.medium", defaultValue: "Medium", comment: "Font weight: Medium"),
            .semibold: String(localized: "settings.font-weight.semi-bold", defaultValue: "Semi Bold", comment: "Font weight: Semi Bold"),
            .bold: String(localized: "settings.font-weight.bold", defaultValue: "Bold", comment: "Font weight: Bold"),
            .heavy: String(localized: "settings.font-weight.heavy", defaultValue: "Heavy", comment: "Font weight: Heavy"),
            .black: String(localized: "settings.font-weight.black", defaultValue: "Black", comment: "Font weight: Black")
        ]
    }

    var body: some View {
        Picker(label ?? String(localized: "settings.font-weight.picker-label", defaultValue: "Font Weight", comment: "Label for font weight picker"), selection: $selection) {
            ForEach(fontWeights, id: \.self) { weight in
                Text(weightNames[weight] ?? String(localized: "settings.font-weight.unknown", defaultValue: "Unknown", comment: "Fallback for unknown font weight"))
                    .tag(weight)
            }
        }
    }
}
