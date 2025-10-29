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
        .ultraLight: String(localized: "Ultra Light", comment: "Font weight option"),
        .thin: String(localized: "Thin", comment: "Font weight option"),
        .light: String(localized: "Light", comment: "Font weight option"),
        .regular: String(localized: "Regular", comment: "Font weight option"),
        .medium: String(localized: "Medium", comment: "Font weight option"),
        .semibold: String(localized: "Semi Bold", comment: "Font weight option"),
        .bold: String(localized: "Bold", comment: "Font weight option"),
        .heavy: String(localized: "Heavy", comment: "Font weight option"),
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
