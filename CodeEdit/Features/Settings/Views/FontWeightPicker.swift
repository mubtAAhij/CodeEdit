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
        .ultraLight: String(localized: "font-weight.ultra-light", defaultValue: "Ultra Light", comment: "Font weight name for ultra light weight"),
        .thin: String(localized: "font-weight.thin", defaultValue: "Thin", comment: "Font weight name for thin weight"),
        .light: String(localized: "font-weight.light", defaultValue: "Light", comment: "Font weight name for light weight"),
        .regular: String(localized: "font-weight.regular", defaultValue: "Regular", comment: "Font weight name for regular weight"),
        .medium: String(localized: "font-weight.medium", defaultValue: "Medium", comment: "Font weight name for medium weight"),
        .semibold: String(localized: "font-weight.semi-bold", defaultValue: "Semi Bold", comment: "Font weight name for semi bold weight"),
        .bold: String(localized: "font-weight.bold", defaultValue: "Bold", comment: "Font weight name for bold weight"),
        .heavy: String(localized: "font-weight.heavy", defaultValue: "Heavy", comment: "Font weight name for heavy weight"),
        .black: String(localized: "font-weight.black", defaultValue: "Black", comment: "Font weight name for black weight")
    ]

    var body: some View {
        Picker(label ?? String(localized: "font-weight.picker-label", defaultValue: "Font Weight", comment: "Label for font weight picker"), selection: $selection) {
            ForEach(fontWeights, id: \.self) { weight in
                Text(weightNames[weight] ?? String(localized: "font-weight.unknown", defaultValue: "Unknown", comment: "Fallback text for unknown font weight"))
                    .tag(weight)
            }
        }
    }
}
