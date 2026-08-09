//
//  UtilityAreaTerminalSidebar.swift
//  CodeEdit
//
//  Created by Khan Winter on 8/19/24.
//

import SwiftUI

/// The view that displays the list of available terminals in the utility area.
/// See ``UtilityAreaTerminalView`` for use.
struct UtilityAreaTerminalSidebar: View {
    @EnvironmentObject private var workspace: WorkspaceDocument
    @EnvironmentObject private var utilityAreaViewModel: UtilityAreaViewModel

    var body: some View {
        List(selection: $utilityAreaViewModel.selectedTerminals) {
            ForEach(utilityAreaViewModel.terminals, id: \.self.id) { terminal in
                UtilityAreaTerminalTab(
                    terminal: terminal,
                    removeTerminals: utilityAreaViewModel.removeTerminals,
                    isSelected: utilityAreaViewModel.selectedTerminals.contains(terminal.id),
                    selectedIDs: utilityAreaViewModel.selectedTerminals
                )
                .tag(terminal.id)
                .listRowSeparator(.hidden)
            }
            .onMove { [weak utilityAreaViewModel] (source, destination) in
                utilityAreaViewModel?.reorderTerminals(from: source, to: destination)
            }
        }
        .focusedObject(utilityAreaViewModel)
        .listStyle(.automatic)
        .accentColor(.secondary)
        .contextMenu {
            Button(String(localized: "utility-area.terminal-sidebar.new-terminal", defaultValue: "New Terminal", comment: "Action to create a new terminal in sidebar")) {
                utilityAreaViewModel.addTerminal(rootURL: workspace.fileURL)
            }
            Menu(String(localized: "utility-area.terminal-sidebar.new-terminal-with-profile", defaultValue: "New Terminal With Profile", comment: "Action to create new terminal with selected profile")) {
                Button(String(localized: "utility-area.terminal-sidebar.default-profile", defaultValue: "Default", comment: "Default terminal profile name")) {
                    utilityAreaViewModel.addTerminal(rootURL: workspace.fileURL)
                }
                Divider()
                ForEach(Shell.allCases, id: \.self) { shell in
                    Button(shell.rawValue) {
                        utilityAreaViewModel.addTerminal(shell: shell, rootURL: workspace.fileURL)
                    }
                }
            }
        }
        .onChange(of: utilityAreaViewModel.terminals) { _, newValue in
            if newValue.isEmpty {
                utilityAreaViewModel.addTerminal(rootURL: workspace.fileURL)
            }
        }
        .paneToolbar {
            PaneToolbarSection {
                Button {
                    utilityAreaViewModel.addTerminal(rootURL: workspace.fileURL)
                } label: {
                    Image(systemName: "plus")
                }
                Button {
                    utilityAreaViewModel.removeTerminals(utilityAreaViewModel.selectedTerminals)
                } label: {
                    Image(systemName: "minus")
                }
                .disabled(utilityAreaViewModel.terminals.count <= 1)
                .opacity(utilityAreaViewModel.terminals.count <= 1 ? 0.5 : 1)
            }
            Spacer()
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(String(localized: "utility-area.terminal-sidebar.terminals", defaultValue: "Terminals", comment: "Section title for terminal list in sidebar"))
        .accessibilityIdentifier("terminalsList")
    }
}

#Preview {
    UtilityAreaTerminalSidebar()
}
