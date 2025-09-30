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
        .ultraLight: String(localized: "font_weight_ultra_light", comment: "Font weight: Ultra Light"),
        .thin: String(localized: "font_weight_thin", comment: "Font weight: Thin"),
        .light: String(localized: "font_weight_light", comment: "Font weight: Light"),
        .regular: String(localized: "font_weight_regular", comment: "Font weight: Regular"),
        .medium: String(localized: "font_weight_medium", comment: "Font weight: Medium"),
        .semibold: String(localized: "font_weight_semi_bold", comment: "Font weight: Semi Bold"),
        .bold: String(localized: "font_weight_bold", comment: "Bold font weight option"),
        .heavy: String(localized: "font_weight_heavy", comment: "Heavy font weight option"),
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
