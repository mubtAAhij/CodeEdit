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
            return String(localized: "utility-area.terminal.title", defaultValue: "Terminal", comment: "Terminal tab title")
        case .debugConsole:
            return String(localized: "utility-area.debug-console.title", defaultValue: "Debug Console", comment: "Debug console tab title")
        case .output:
            return String(localized: "utility-area.output.title", defaultValue: "Output", comment: "Output tab title")
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
