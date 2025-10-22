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
        .ultraLight: String(localized: "font.weight.ultralight", defaultValue: "Ultra Light", comment: "Font weight"),
        .thin: String(localized: "font.weight.thin", defaultValue: "Thin", comment: "Font weight"),
        .light: String(localized: "font.weight.light", defaultValue: "Light", comment: "Font weight"),
        .regular: String(localized: "font.weight.regular", defaultValue: "Regular", comment: "Font weight"),
        .medium: String(localized: "font.weight.medium", defaultValue: "Medium", comment: "Font weight"),
        .semibold: String(localized: "font.weight.semibold", defaultValue: "Semi Bold", comment: "Font weight"),
        .bold: String(localized: "font.weight.bold", defaultValue: "Bold", comment: "Font weight"),
        .heavy: String(localized: "font.weight.heavy", defaultValue: "Heavy", comment: "Font weight"),
        .black: "Black"
    ]

    var body: some View {
        Picker(label ?? "Font Weight", selection: $selection) {
            ForEach(fontWeights, id: \.self) { weight in
                Text(weightNames[weight] ?? "Unknown")
                    .tag(weight)
            }
        }
    }
}
