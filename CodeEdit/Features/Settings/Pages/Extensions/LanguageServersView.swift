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
                        String(localized: "settings.extensions.lsp.warning", defaultValue: "Warning: Language server installation is experimental. Use at your own risk.", comment: "Language server installation warning"),
                        systemImage: String(localized: "common.icon.warning_triangle", defaultValue: "exclamationmark.triangle.fill", comment: "SF Symbol for warning triangle icon")
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
        let string = String(localized: "settings.extensions.lsp.info", defaultValue: "CodeEdit makes use of the Mason Registry for language server installation. To install a package, CodeEdit uses the package manager directed by the Mason Registry, and installs a copy of the language server in Application Support.\n\nLanguage server installation is still experimental, there may be bugs and expect this flow to change over time.", comment: "Language server installation info text")

        var attrString = AttributedString(string)

        if let linkRange = attrString.range(of: String(localized: "settings.extensions.lsp.registry_name", defaultValue: "Mason Registry", comment: "Mason Registry name")) {
            attrString[linkRange].link = URL(string: String(localized: "settings.extensions.lsp.registry_url", defaultValue: "https://mason-registry.dev/", comment: "Mason Registry URL"))
            attrString[linkRange].foregroundColor = NSColor.linkColor
        }

        return attrString
    }
}
