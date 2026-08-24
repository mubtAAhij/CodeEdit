//
//  NoSelectionInspectorView.swift
//  CodeEdit
//
//  Created by Nanashi Li on 2022/04/18.
//

import SwiftUI

struct NoSelectionInspectorView: View {
    var body: some View {
        CEContentUnavailableView(String(localized: "inspector.empty.no-selection", defaultValue: "No Selection", comment: "Placeholder title shown when nothing is selected in inspector"))
    }
}
