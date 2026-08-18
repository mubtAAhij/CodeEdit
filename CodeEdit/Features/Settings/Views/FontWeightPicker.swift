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
        .ultraLight: String(
            localized: "settings.font-weight-picker.weight.ultra-light",
            defaultValue: "Ultra Light",
            comment: "Font weight option label for ultra light weight"
        ),
        .thin: String(
            localized: "settings.font-weight-picker.weight.thin",
            defaultValue: "Thin",
            comment: "Font weight option label for thin weight"
        ),
        .light: String(
            localized: "settings.font-weight-picker.weight.light",
            defaultValue: "Light",
            comment: "Font weight option label for light weight"
        ),
        .regular: String(
            localized: "settings.font-weight-picker.weight.regular",
            defaultValue: "Regular",
            comment: "Font weight option label for regular weight"
        ),
        .medium: String(
            localized: "settings.font-weight-picker.weight.medium",
            defaultValue: "Medium",
            comment: "Font weight option label for medium weight"
        ),
        .semibold: String(
            localized: "settings.font-weight-picker.weight.semi-bold",
            defaultValue: "Semi Bold",
            comment: "Font weight option label for semi bold weight"
        ),
        .bold: String(
            localized: "settings.font-weight-picker.weight.bold",
            defaultValue: "Bold",
            comment: "Font weight option label for bold weight"
        ),
        .heavy: String(
            localized: "settings.font-weight-picker.weight.heavy",
            defaultValue: "Heavy",
            comment: "Font weight option label for heavy weight"
        ),
        .black: String(
            localized: "settings.font-weight-picker.weight.black",
            defaultValue: "Black",
            comment: "Font weight option label for black weight"
        )
    ]

    var body: some View {
        Picker(label ?? String(
            localized: "settings.font-weight-picker.title",
            defaultValue: "Font Weight",
            comment: "Title label for font weight picker"
        ), selection: $selection) {
            ForEach(fontWeights, id: \.self) { weight in
                Text(weightNames[weight] ?? String(
                    localized: "settings.font-weight-picker.weight.unknown",
                    defaultValue: "Unknown",
                    comment: "Fallback font weight label when value cannot be mapped"
                ))
                    .tag(weight)
            }
        }
    }
}
