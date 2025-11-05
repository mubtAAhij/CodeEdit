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
            return "Terminal"
        case .debugConsole:
            return String(localized: "utility-area.debug-console", defaultValue: "Debug Console", comment: "Title of debug console utility area tab")
        case .output:
            return String(localized: "utility-area.output", defaultValue: "Output", comment: "Title of output utility area tab")
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
