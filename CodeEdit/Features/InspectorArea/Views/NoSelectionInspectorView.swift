//
//  NoSelectionView.swift
//  CodeEdit
//
//  Created by Nanashi Li on 2022/04/18.
//

import SwiftUI

struct NoSelectionInspectorView: View {
    var body: some View {
        CEContentUnavailableView(String(localized: "inspector.no-selection", defaultValue: "No Selection", comment: "Message shown when nothing is selected in inspector"))
    }
}
