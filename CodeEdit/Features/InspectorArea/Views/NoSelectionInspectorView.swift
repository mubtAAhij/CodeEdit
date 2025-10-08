//
//  NoSelectionView.swift
//  CodeEdit
//
//  Created by Nanashi Li on 2022/04/18.
//

import SwiftUI

struct NoSelectionInspectorView: View {
    var body: some View {
        CEContentUnavailableView(String(localized: "inspector.no_selection", comment: "Message shown when no item is selected in inspector"))
    }
}
