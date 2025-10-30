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
        .ultraLight: String(localized: "settings.font.weight.ultra-light", defaultValue: "Ultra Light", comment: "Font weight option: ultra light"),
        .thin: String(localized: "settings.font.weight.thin", defaultValue: "Thin", comment: "Font weight option: thin"),
        .light: String(localized: "settings.font.weight.light", defaultValue: "Light", comment: "Font weight option: light"),
        .regular: String(localized: "settings.font.weight.regular", defaultValue: "Regular", comment: "Font weight option: regular"),
        .medium: String(localized: "settings.font.weight.medium", defaultValue: "Medium", comment: "Font weight option: medium"),
        .semibold: String(localized: "settings.font.weight.semibold", defaultValue: "Semi Bold", comment: "Font weight option: semi bold"),
        .bold: String(localized: "settings.font.weight.bold", defaultValue: "Bold", comment: "Font weight option: bold"),
        .heavy: String(localized: "settings.font.weight.heavy", defaultValue: "Heavy", comment: "Font weight option: heavy"),
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
