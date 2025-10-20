//
//  SchemeDropDownView.swift
//  CodeEdit
//
//  Created by Tommy Ludwig on 24.06.24.
//

import SwiftUI

struct SchemeDropDownView: View {
    @Environment(\.colorScheme)
    private var colorScheme

    @Environment(\.controlActiveState)
    private var activeState

    @State var isSchemePopOverPresented: Bool = false
    @State private var isHoveringScheme: Bool = false

    @ObservedObject var workspaceSettingsManager: CEWorkspaceSettings
    var workspaceFileManager: CEWorkspaceFileManager?

    var workspaceName: String {
        workspaceSettingsManager.settings.project.projectName
    }

    /// Resolves the name one step further than `workspaceName`.
    var workspaceDisplayName: String {
        workspaceName.isEmpty
        ? (workspaceFileManager?.workspaceItem.fileName() ?? String(localized: "schemeDropDown.noProjectFound", comment: "Empty state message"))
        : workspaceName
    }

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "folder.badge.gearshape")
                .imageScale(.medium)
            Text(workspaceDisplayName)
                .frame(minWidth: 0)
        }
        .opacity(activeState == .inactive ? 0.4 : 1.0)
        .font(.subheadline)
        .padding(.trailing, 11.5)
        .padding(.horizontal, 2.5)
        .padding(.vertical, 2.5)
        .background {
            Color(nsColor: colorScheme == .dark ? .white : .black)
                .opacity(isHoveringScheme || isSchemePopOverPresented ? 0.05 : 0)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 4, height: 4)))
            HStack {
                Spacer()
                if isHoveringScheme || isSchemePopOverPresented {
                    chevronDown
                        .padding(.trailing, 2)
                } else {
                    chevron
                        .padding(.trailing, 4)
                }
            }
        }
        .onHover(perform: { hovering in
            self.isHoveringScheme = hovering
        })
        .instantPopover(isPresented: $isSchemePopOverPresented, arrowEdge: .bottom) {
            popoverContent
        }
        .onTapGesture {
            isSchemePopOverPresented.toggle()
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .accessibilityIdentifier("SchemeDropdown")
        .accessibilityValue(workspaceDisplayName)
        .accessibilityLabel(String(localized: "schemeDropDown.activeScheme", comment: "Accessibility label"))
        .accessibilityHint(String(localized: "schemeDropDown.openActiveSchemeMenu", comment: "Accessibility hint"))
        .accessibilityAction {
            isSchemePopOverPresented.toggle()
        }
    }

    private var chevron: some View {
        Image(systemName: "chevron.compact.right")
            .font(.system(size: 9, weight: .medium, design: .default))
            .foregroundStyle(.secondary)
            .scaleEffect(x: 1.30, y: 1.0, anchor: .center)
            .imageScale(.large)
    }

    private var chevronDown: some View {
        VStack(spacing: 1) {
            Image(systemName: "chevron.down")
        }
        .font(.system(size: 8, weight: .semibold, design: .default))
        .padding(.top, 0.5)
    }

    @ViewBuilder var popoverContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            WorkspaceMenuItemView(
                workspaceFileManager: workspaceFileManager,
                item: workspaceFileManager?.workspaceItem
            )
            Divider()
                .padding(.vertical, 5)
            Group {
                OptionMenuItemView(label: String(localized: "schemeDropDown.addFolder", comment: "Menu item")) {
                    // TODO: Implment Add Folder
                    print("NOT IMPLEMENTED")
                }
                .disabled(true)
                OptionMenuItemView(label: String(localized: "schemeDropDown.workspaceSettings", comment: "Menu item")) {
                    NSApp.sendAction(
                        #selector(CodeEditWindowController.openWorkspaceSettings(_:)), to: nil, from: nil
                    )
                }
            }
        }
        .font(.subheadline)
        .padding(5)
        .frame(minWidth: 215)
    }
}

// #Preview {
//    SchemeDropDownMenuView()
// }
