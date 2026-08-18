//
//  UtilityAreaTab.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 02/06/2023.
//

import SwiftUI

enum UtilityAreaTab: WorkspacePanelTab, CaseIterable {
    var id: Self { self }

    case terminal
    case debugConsole
    case output

    var title: String {
        switch self {
        case .terminal:
            return String(
                localized: "utility-area.tab.terminal",
                defaultValue: "Terminal",
                comment: "Utility area tab title for terminal"
            )
        case .debugConsole:
            return String(
                localized: "utility-area.tab.debug-console",
                defaultValue: "Debug Console",
                comment: "Utility area tab title for debug console"
            )
        case .output:
            return String(
                localized: "utility-area.tab.output",
                defaultValue: "Output",
                comment: "Utility area tab title for output"
            )
        }
    }

    var systemImage: String {
        switch self {
        case .terminal:
            return "terminal"
        case .debugConsole:
            return "ladybug"
        case .output:
            return "list.bullet.indent"
        }
    }

    var body: some View {
        switch self {
        case .terminal:
            UtilityAreaTerminalView()
        case .debugConsole:
            UtilityAreaDebugView()
        case .output:
            UtilityAreaOutputView()
        }
    }
}
