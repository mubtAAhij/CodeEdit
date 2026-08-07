//
//  NoSelectionView.swift
//  CodeEdit
//
//  Created by Nanashi Li on 2022/04/18.
//

import SwiftUI

struct NoSelectionInspectorView: View {
    var body: some View {
        CEContentUnavailableView(String(localized: "inspector-area.no-selection.title", defaultValue: "No Selection", comment: "Placeholder title shown when nothing is selected in inspector area"))
    }
}
