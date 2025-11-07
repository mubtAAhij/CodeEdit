//
//  LanguageServerRowView.swift
//  CodeEdit
//
//  Created by Abe Malla on 2/2/25.
//

import SwiftUI

private let iconSize: CGFloat = 26

struct LanguageServerRowView: View, Equatable {
    let package: RegistryItem
    let onCancel: (() -> Void)
    let onInstall: (() async -> Void)

    private var isInstalled: Bool {
        registryManager.installedLanguageServers[package.name] != nil
    }
    private var isEnabled: Bool {
        registryManager.installedLanguageServers[package.name]?.isEnabled ?? false
    }

    @State private var isHovering: Bool = false
    @State private var showingRemovalConfirmation = false
    @State private var isRemoving = false
    @State private var removalError: Error?
    @State private var showingRemovalError = false

    @State private var showMore: Bool = false

    @EnvironmentObject var registryManager: RegistryManager

    init(
        package: RegistryItem,
        onCancel: @escaping (() -> Void),
        onInstall: @escaping () async -> Void
    ) {
        self.package = package
        self.onCancel = onCancel
        self.onInstall = onInstall
    }

    var body: some View {
        HStack {
            Label {
                VStack(alignment: .leading) {
                    Text(package.sanitizedName)

                    ZStack(alignment: .leadingLastTextBaseline) {
                        VStack(alignment: .leading) {
                            Text(package.sanitizedDescription)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .lineLimit(showMore ? nil : 1)
                                .truncationMode(.tail)
                            if showMore {
                                Button(package.homepagePretty) {
                                    guard let url = package.homepageURL else { return }
                                    NSWorkspace.shared.open(url)
                                }
                                .buttonStyle(.plain)
                                .foregroundColor(Color(NSColor.linkColor))
                                .font(.footnote)
                                .cursor(.pointingHand)
                                if let installerName = package.installMethod?.packageManagerType?.rawValue {
                                    Text(String(
                                        localized: "language-server-row.install-using",
                                        defaultValue: "Install using \(installerName)",
                                        comment: "Label showing which package manager will be used for installation"
                                    ))
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        if isHovering {
                            HStack {
                                Spacer()
                                Button {
                                    showMore.toggle()
                                } label: {
                                    let buttonText = showMore
                                        ? String(
                                            localized: "language-server-row.show-less",
                                            defaultValue: "Show Less",
                                            comment: "Button to collapse language server details"
                                        )
                                        : String(
                                            localized: "language-server-row.show-more",
                                            defaultValue: "Show More",
                                            comment: "Button to expand language server details"
                                        )
                                    Text(buttonText)
                                        .font(.footnote)
                                }
                                .buttonStyle(.plain)
                                .background(
                                    Rectangle()
                                        .inset(by: -2)
                                        .fill(.clear)
                                        .background(Color(NSColor.windowBackgroundColor))
                                )
                            }
                        }
                    }
                }
            } icon: {
                letterIcon()
            }
            .opacity(isInstalled && !isEnabled ? 0.5 : 1.0)

            Spacer()

            installationButton()
        }
        .onHover { hovering in
            isHovering = hovering
        }
        .alert(String(
            localized: "language-server-row.alert.remove-title",
            defaultValue: "Remove \(package.sanitizedName)?",
            comment: "Alert title asking to confirm removal of a language server"
        ), isPresented: $showingRemovalConfirmation) {
            Button(String(
                localized: "language-server-row.alert.cancel",
                defaultValue: "Cancel",
                comment: "Cancel button in removal confirmation alert"
            ), role: .cancel) { }
            Button(String(
                localized: "language-server-row.alert.remove",
                defaultValue: "Remove",
                comment: "Remove button in removal confirmation alert"
            ), role: .destructive) {
                removeLanguageServer()
            }
        } message: {
            Text(String(
                localized: "language-server-row.alert.remove-message",
                defaultValue: "Are you sure you want to remove this language server? This action cannot be undone.",
                comment: "Alert message warning about language server removal"
            ))
        }
        .alert(String(
            localized: "language-server-row.alert.removal-failed",
            defaultValue: "Removal Failed",
            comment: "Alert title when language server removal fails"
        ), isPresented: $showingRemovalError) {
            Button(String(
                localized: "language-server-row.alert.ok",
                defaultValue: "OK",
                comment: "OK button in removal failed alert"
            ), role: .cancel) { }
        } message: {
            let errorMessage = removalError?.localizedDescription ?? String(
                localized: "language-server-row.alert.unknown-error",
                defaultValue: "An unknown error occurred",
                comment: "Fallback error message when no specific error is available"
            )
            Text(errorMessage)
        }
    }

    @ViewBuilder
    private func installationButton() -> some View {
        if isInstalled {
            installedRow()
        } else if registryManager.runningInstall?.package.name == package.name {
            isInstallingRow()
        } else if isHovering {
            isHoveringRow()
        }
    }

    @ViewBuilder
    private func installedRow() -> some View {
        HStack {
            if isRemoving {
                CECircularProgressView()
                    .frame(width: 20, height: 20)
            } else if isHovering {
                Button {
                    showingRemovalConfirmation = true
                } label: {
                    Text(String(
                        localized: "language-server-row.button.remove",
                        defaultValue: "Remove",
                        comment: "Button to remove an installed language server"
                    ))
                }
            }
            Toggle(
                "",
                isOn: Binding(
                    get: { isEnabled },
                    set: { registryManager.setPackageEnabled(packageName: package.name, enabled: $0) }
                )
            )
            .toggleStyle(.switch)
            .controlSize(.small)
            .labelsHidden()
        }
    }

    @ViewBuilder
    private func isInstallingRow() -> some View {
        HStack {
            ZStack {
                CECircularProgressView()
                    .frame(width: 20, height: 20)

                Button {
                    onCancel()
                } label: {
                    Image(systemName: "stop.fill")
                        .font(.system(size: 8))
                        .foregroundColor(.blue)
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle())
            }
        }
    }

    @ViewBuilder
    private func failedRow() -> some View {
        Button {
            Task {
                await onInstall()
            }
        } label: {
            Text(String(
                localized: "language-server-row.button.retry",
                defaultValue: "Retry",
                comment: "Button to retry failed language server installation"
            ))
                .foregroundColor(.red)
        }
    }

    @ViewBuilder
    private func isHoveringRow() -> some View {
        Button {
            Task {
                await onInstall()
            }
        } label: {
            Text(String(
                localized: "language-server-row.button.install",
                defaultValue: "Install",
                comment: "Button to install a language server"
            ))
        }
        .disabled(registryManager.isInstalling)
    }

    @ViewBuilder
    private func letterIcon() -> some View {
        RoundedRectangle(cornerRadius: iconSize / 4, style: .continuous)
            .fill(background)
            .overlay {
                Text(String(package.sanitizedName.first ?? Character("")))
                    .font(.system(size: iconSize * 0.65))
                    .foregroundColor(.primary)
            }
            .clipShape(RoundedRectangle(cornerRadius: iconSize / 4, style: .continuous))
            .shadow(
                color: Color(NSColor.black).opacity(0.25),
                radius: iconSize / 40,
                y: iconSize / 40
            )
            .frame(width: iconSize, height: iconSize)
    }

    private func removeLanguageServer() {
        isRemoving = true
        Task {
            do {
                try await registryManager.removeLanguageServer(packageName: package.name)
                await MainActor.run {
                    isRemoving = false
                }
            } catch {
                await MainActor.run {
                    isRemoving = false
                    removalError = error
                    showingRemovalError = true
                }
            }
        }
    }

    private var background: AnyShapeStyle {
        let colors: [Color] = [
            .blue, .green, .orange, .red, .purple, .pink, .teal, .yellow, .indigo, .cyan
        ]
        let hashValue = abs(package.sanitizedName.hash) % colors.count
        return AnyShapeStyle(colors[hashValue].gradient)
    }

    static func == (lhs: LanguageServerRowView, rhs: LanguageServerRowView) -> Bool {
        lhs.package.name == rhs.package.name
    }
}
