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
        ? (workspaceFileManager?.workspaceItem.fileName() ?? String(localized: "scheme.no-project", defaultValue: "No Project found", comment: "No project found"))
        : workspaceName
    }

    var body: some View {
        Group {
            if #available(macOS 26, *) {
                tahoe
            } else {
                seqouia
            }
        }
        .onHover(perform: { hovering in
            self.isHoveringScheme = hovering
        })
        .instantPopover(isPresented: $isSchemePopOverPresented, arrowEdge: .top) {
            popoverContent
        }
        .onTapGesture {
            isSchemePopOverPresented.toggle()
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .accessibilityIdentifier("SchemeDropdown")
        .accessibilityValue(workspaceDisplayName)
        .accessibilityLabel(String(localized: "scheme.active-scheme", defaultValue: "Active Scheme", comment: "Active scheme accessibility label"))
        .accessibilityHint(String(localized: "scheme.open-menu-hint", defaultValue: "Open the active scheme menu", comment: "Open scheme menu hint"))
        .accessibilityAction {
            isSchemePopOverPresented.toggle()
        }
    }

    @available(macOS 26, *)
    @ViewBuilder private var tahoe: some View {
        HStack(spacing: 4) {
            label
            chevron
                .offset(x: 2)
                .opacity(isHoveringScheme || isSchemePopOverPresented ? 0.0 : 1.0)
        }
        .background {
            if isHoveringScheme || isSchemePopOverPresented {
                HStack {
                    Spacer()
                    chevronDown
                }
            }
        }
        .padding(6)
        .padding(.leading, 2) // apparently this is cummulative?
        .background {
            Color(nsColor: colorScheme == .dark ? .white : .black)
                .opacity(isHoveringScheme || isSchemePopOverPresented ? 0.05 : 0)
                .clipShape(Capsule())
        }
    }

    @ViewBuilder private var seqouia: some View {
        label
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
    }

    @ViewBuilder private var label: some View {
        HStack(spacing: 6) {
            Image(systemName: "folder.badge.gearshape")
                .imageScale(.medium)
            Text(workspaceDisplayName)
                .frame(minWidth: 0)
        }
        .opacity(activeState == .inactive ? 0.4 : 1.0)
        .font(.subheadline)
    }

    @ViewBuilder private var chevron: some View {
        Image(systemName: "chevron.compact.right")
            .font(.system(size: 9, weight: .medium, design: .default))
            .foregroundStyle(.secondary)
            .scaleEffect(x: 1.30, y: 1.0, anchor: .center)
            .imageScale(.large)
    }

    @ViewBuilder private var chevronDown: some View {
        VStack(spacing: 1) {
            Image(systemName: "chevron.down")
        }
        .font(.system(size: 8, weight: .semibold, design: .default))
        .padding(.top, 0.5)
    }

    @ViewBuilder var popoverContent: some View {
        WorkspaceMenuItemView(
            workspaceFileManager: workspaceFileManager,
            item: workspaceFileManager?.workspaceItem
        )
        Divider()
            .padding(.vertical, 5)
        Group {
            OptionMenuItemView(label: String(localized: "scheme.add-folder", defaultValue: "Add Folder...", comment: "Add folder menu item")) {
                // TODO: Implment Add Folder
                print("NOT IMPLEMENTED")
            }
            .disabled(true)
            OptionMenuItemView(label: String(localized: "scheme.workspace-settings", defaultValue: "Workspace Settings...", comment: "Workspace settings menu item")) {
                NSApp.sendAction(
                    #selector(CodeEditWindowController.openWorkspaceSettings(_:)), to: nil, from: nil
                )
            }
        }
    }
}

// #Preview {
//    SchemeDropDownMenuView()
// }
