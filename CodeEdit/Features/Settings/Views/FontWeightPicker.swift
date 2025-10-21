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
        .ultraLight: String(localized: "fontWeight.ultraLight", comment: "Font weight option"),
        .thin: String(localized: "fontWeight.thin", comment: "Font weight option"),
        .light: String(localized: "fontWeight.light", comment: "Font weight option"),
        .regular: String(localized: "fontWeight.regular", comment: "Font weight option"),
        .medium: String(localized: "fontWeight.medium", comment: "Font weight option"),
        .semibold: String(localized: "fontWeight.semiBold", comment: "Font weight option"),
        .bold: String(localized: "fontWeight.bold", comment: "Font weight option"),
        .heavy: String(localized: "fontWeight.heavy", comment: "Font weight option"),
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
