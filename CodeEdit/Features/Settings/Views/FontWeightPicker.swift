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
        .ultraLight: String(localized: "settings.font-weight.ultra-light", defaultValue: "Ultra Light", comment: "Ultra light font weight"),
        .thin: String(localized: "settings.font-weight.thin", defaultValue: "Thin", comment: "Thin font weight"),
        .light: String(localized: "settings.font-weight.light", defaultValue: "Light", comment: "Light font weight"),
        .regular: String(localized: "settings.font-weight.regular", defaultValue: "Regular", comment: "Regular font weight"),
        .medium: String(localized: "settings.font-weight.medium", defaultValue: "Medium", comment: "Medium font weight"),
        .semibold: String(localized: "settings.font-weight.semi-bold", defaultValue: "Semi Bold", comment: "Semi bold font weight"),
        .bold: String(localized: "settings.font-weight.bold", defaultValue: "Bold", comment: "Bold font weight"),
        .heavy: String(localized: "settings.font-weight.heavy", defaultValue: "Heavy", comment: "Heavy font weight"),
        .black: String(localized: "settings.font-weight.black", defaultValue: "Black", comment: "Black font weight")
    ]

    var body: some View {
        Picker(label ?? String(localized: "settings.font-weight.label", defaultValue: "Font Weight", comment: "Font weight picker label"), selection: $selection) {
            ForEach(fontWeights, id: \.self) { weight in
                Text(weightNames[weight] ?? String(localized: "settings.font-weight.unknown", defaultValue: "Unknown", comment: "Unknown font weight"))
                    .tag(weight)
            }
        }
    }
}
