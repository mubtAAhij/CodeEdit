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
            return String(localized: "utility.tab.terminal", defaultValue: "Terminal", comment: "Terminal utility tab title")
        case .debugConsole:
            return String(localized: "utility.tab.debug-console", defaultValue: "Debug Console", comment: "Debug console utility tab title")
        case .output:
            return String(localized: "utility.tab.output", defaultValue: "Output", comment: "Output utility tab title")
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
