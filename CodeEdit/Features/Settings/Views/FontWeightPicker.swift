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
        .ultraLight: String(localized: "font_weight.ultra_light", comment: "Ultra light font weight"),
        .thin: String(localized: "font_weight.thin", comment: "Thin font weight"),
        .light: String(localized: "font_weight.light", comment: "Light font weight"),
        .regular: String(localized: "font_weight.regular", comment: "Regular font weight"),
        .medium: String(localized: "font_weight.medium", comment: "Medium font weight"),
        .semibold: String(localized: "font_weight.semi_bold", comment: "Semi bold font weight"),
        .bold: String(localized: "font_weight.bold", comment: "Font weight: Bold"),
        .heavy: String(localized: "font_weight.heavy", comment: "Font weight: Heavy"),
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
