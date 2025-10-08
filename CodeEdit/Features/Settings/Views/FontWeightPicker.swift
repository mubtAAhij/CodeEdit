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
        .ultraLight: String(localized: "font_weight.ultra_light", comment: "Ultra Light font weight option"),
        .thin: String(localized: "font_weight.thin", comment: "Thin font weight option"),
        .light: String(localized: "font_weight.light", comment: "Light font weight option"),
        .regular: String(localized: "font_weight.regular", comment: "Regular font weight option"),
        .medium: String(localized: "font_weight.medium", comment: "Medium font weight option"),
        .semibold: String(localized: "font_weight.semi_bold", comment: "Semi Bold font weight option"),
        .bold: String(localized: "font_weight.bold", comment: "Bold font weight option"),
        .heavy: String(localized: "font_weight.heavy", comment: "Heavy font weight option"),
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
