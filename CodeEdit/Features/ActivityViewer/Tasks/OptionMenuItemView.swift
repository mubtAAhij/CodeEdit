//
//  OptionMenuItemView.swift
//  CodeEdit
//
//  Created by Tommy Ludwig on 24.06.24.
//

import SwiftUI

struct OptionMenuItemView: View {
    var label: String
    var action: () -> Void

    var body: some View {
        HStack {
            Text(label)
            Spacer()
        }
        .padding(.horizontal, 20)
        .dropdownItemStyle()
        .onTapGesture {
            action()
        }
        .accessibilityElement()
        .accessibilityAction {
            action()
        }
        .accessibilityLabel(label)
    }
}

#Preview {
    OptionMenuItemView(label: String(localized: "preview.test", defaultValue: "Test", comment: "SwiftUI preview placeholder - should not be localized")) {
        print(String(localized: "preview.test-id", defaultValue: "test", comment: "SwiftUI preview placeholder - should not be localized"))
    }
}
