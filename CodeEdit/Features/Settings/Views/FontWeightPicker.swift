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
        .ultraLight: String(localized: "fonts.weight.ultra_light", comment: "Font weight"),
        .thin: String(localized: "fonts.weight.thin", comment: "Font weight"),
        .light: String(localized: "fonts.weight.light", comment: "Font weight"),
        .regular: String(localized: "fonts.weight.regular", comment: "Font weight"),
        .medium: String(localized: "fonts.weight.medium", comment: "Font weight"),
        .semibold: String(localized: "fonts.weight.semi_bold", comment: "Font weight"),
        .bold: String(localized: "fonts.weight.bold", comment: "Font weight"),
        .heavy: String(localized: "fonts.weight.heavy", comment: "Font weight"),
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
