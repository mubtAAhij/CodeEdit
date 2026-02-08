//
//  ExtensionsSettingsView.swift
//  CodeEdit
//
//  Created by Abe Malla on 2/2/25.
//

import SwiftUI

/// Displays a searchable list of packages from the ``RegistryManager``.
struct LanguageServersView: View {
    @StateObject var registryManager: RegistryManager = .shared
    @StateObject private var searchModel = FuzzySearchUIModel<RegistryItem>()
    @State private var searchText: String = ""
    @State private var selectedInstall: PackageManagerInstallOperation?

    @State private var showingInfoPanel = false

    var body: some View {
        Group {
            SettingsForm {
                if registryManager.isDownloadingRegistry {
                    HStack {
                        Spacer()
                        ProgressView()
                            .controlSize(.small)
                        Spacer()
                    }
                }

                Section {
                    List(searchModel.items ?? registryManager.registryItems, id: \.name) { item in
                        LanguageServerRowView(
                            package: item,
                            onCancel: {
                                registryManager.cancelInstallation()
                            },
                            onInstall: { [item] in
                                do {
                                    selectedInstall = try registryManager.installOperation(package: item)
                                } catch {
                                    // Display the error
                                    NSAlert(error: error).runModal()
                                }
                            }
                        )
                        .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    }
                    .searchable(text: $searchText)
                    .onChange(of: searchText) { _, newValue in
                        searchModel.searchTextUpdated(searchText: newValue, allItems: registryManager.registryItems)
                    }
                } header: {
                    Label(
                        String(localized: "settings.lsp.experimental-warning", defaultValue: "Warning: Language server installation is experimental. Use at your own risk.", comment: "LSP installation warning"),
                        systemImage: "exclamationmark.triangle.fill"
                    )
                }
            }
            .sheet(item: $selectedInstall) { operation in
                LanguageServerInstallView(operation: operation)
            }
        }
        .environmentObject(registryManager)
    }

    private func getInfoString() -> AttributedString {
        let string = NSLocalizedString("settings.lsp.info-text", comment: "LSP installation info text")

        var attrString = AttributedString(string)

        if let linkRange = attrString.range(of: "Mason Registry") {
            attrString[linkRange].link = URL(string: "https://mason-registry.dev/")
            attrString[linkRange].foregroundColor = NSColor.linkColor
        }

        return attrString
    }
}
