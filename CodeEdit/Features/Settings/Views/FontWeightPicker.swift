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
        .ultraLight: String(localized: "ultra_light", comment: "Ultra Light font weight"),
        .thin: "Thin",
        .light: String(localized: "light", comment: "Light font weight"),
        .regular: "Regular",
        .medium: String(localized: "medium", comment: "Medium font weight"),
        .semibold: "Semi Bold",
        .bold: String(localized: "bold", comment: "Bold font weight"),
        .heavy: "Heavy",
        .black: "Black"
    ]

    var body: some View {
        Picker(label ?? "Font Weight", selection: $selection) {
            ForEach(fontWeights, id: \.self) { weight in
                Text(weightNames[weight] ?? String(localized: "unknown", comment: "Unknown font weight fallback"))
                    .tag(weight)
            }
        }
    }
}
