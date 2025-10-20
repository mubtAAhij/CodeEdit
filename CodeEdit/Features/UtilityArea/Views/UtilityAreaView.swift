//
//  UtilityAreaView.swift
//  CodeEdit
//
//  Created by Lukas Pistrol on 22.03.22.
//

import SwiftUI

struct UtilityAreaView: View {
    @EnvironmentObject private var utilityAreaViewModel: UtilityAreaViewModel

    var body: some View {
        WorkspacePanelView(
            viewModel: utilityAreaViewModel,
            selectedTab: $utilityAreaViewModel.selectedTab,
            tabItems: $utilityAreaViewModel.tabItems,
            sidebarPosition: .side,
            darkDivider: true
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel(String(localized: "utilityArea.label", comment: "Accessibility label"))
        .accessibilityIdentifier("UtilityArea")
    }
}
