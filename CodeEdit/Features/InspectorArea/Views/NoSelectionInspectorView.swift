//
//  NoSelectionView.swift
//  CodeEdit
//
//  Created by Nanashi Li on 2022/04/18.
//

import SwiftUI

struct NoSelectionInspectorView: View {
    var body: some View {
        CEContentUnavailableView(String(localized: "no-selection", defaultValue: "No Selection", comment: "Empty state when no item is selected"))
    }
}
