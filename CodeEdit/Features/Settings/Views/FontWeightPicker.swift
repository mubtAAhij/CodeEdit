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
            .ultraLight: String(
                localized: "font-weight.ultra-light",
                defaultValue: "Ultra Light",
                comment: "Font weight name for ultra light"
            ),
            .thin: String(
                localized: "font-weight.thin",
                defaultValue: "Thin",
                comment: "Font weight name for thin"
            ),
            .light: String(
                localized: "font-weight.light",
                defaultValue: "Light",
                comment: "Font weight name for light"
            ),
            .regular: String(
                localized: "font-weight.regular",
                defaultValue: "Regular",
                comment: "Font weight name for regular"
            ),
            .medium: String(
                localized: "font-weight.medium",
                defaultValue: "Medium",
                comment: "Font weight name for medium"
            ),
            .semibold: String(
                localized: "font-weight.semi-bold",
                defaultValue: "Semi Bold",
                comment: "Font weight name for semi bold"
            ),
            .bold: String(
                localized: "font-weight.bold",
                defaultValue: "Bold",
                comment: "Font weight name for bold"
            ),
            .heavy: String(
                localized: "font-weight.heavy",
                defaultValue: "Heavy",
                comment: "Font weight name for heavy"
            ),
            .black: "Black"
        ]
    }

    var body: some View {
        Picker(label ?? "Font Weight", selection: $selection) {
            ForEach(fontWeights, id: \.self) { weight in
                Text(weightNames[weight] ?? "Unknown")
                    .tag(weight)
            }
        }
    }
}
