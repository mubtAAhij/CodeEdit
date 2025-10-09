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
        .ultraLight: String(localized: "font.weight.ultra_light", comment: "Font weight option"),
        .thin: String(localized: "font.weight.thin", comment: "Font weight option"),
        .light: String(localized: "font.weight.light", comment: "Font weight option"),
        .regular: String(localized: "font.weight.regular", comment: "Font weight option"),
        .medium: String(localized: "font.weight.medium", comment: "Font weight option"),
        .semibold: String(localized: "font.weight.semi_bold", comment: "Font weight option"),
        .bold: String(localized: "font.weight.bold", comment: "Font weight option"),
        .heavy: String(localized: "font.weight.heavy", comment: "Font weight option"),
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
