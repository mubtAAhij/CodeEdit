//
//  LanguageServerInstallView.swift
//  CodeEdit
//
//  Created by Khan Winter on 8/14/25.
//

import SwiftUI

/// A view for initiating a package install and monitoring progress.
struct LanguageServerInstallView: View {
    @Environment(\.dismiss)
    var dismiss
    @EnvironmentObject private var registryManager: RegistryManager

    @ObservedObject var operation: PackageManagerInstallOperation

    var body: some View {
        VStack(spacing: 0) {
            formContent
            Divider()
            footer
        }
        .constrainHeightToWindow()
        .alert(
            String(
                localized: "settings.extensions.language-server-install.confirm-step.title",
                defaultValue: "Confirm Step",
                comment: "Title shown when confirming an installation step"
            ),
            isPresented: Binding(get: { operation.waitingForConfirmation != nil }, set: { _ in }),
            presenting: operation.waitingForConfirmation
        ) { _ in
            Button(String(
                localized: "settings.extensions.language-server-install.confirm-step.cancel.button",
                defaultValue: "Cancel",
                comment: "Cancel button title in confirm step view"
            )) {
                registryManager.cancelInstallation()
            }
            Button(String(
                localized: "settings.extensions.language-server-install.confirm-step.continue.button",
                defaultValue: "Continue",
                comment: "Continue button title in confirm step view"
            )) {
                operation.confirmCurrentStep()
            }
        } message: { confirmationMessage in
            Text(confirmationMessage)
        }
    }

    @ViewBuilder private var formContent: some View {
        Form {
            packageInfoSection
            errorSection
            if operation.runningState == .running || operation.runningState == .complete {
                progressSection
                outputSection
            } else {
                notInstalledSection
            }
        }
        .formStyle(.grouped)
    }

    @ViewBuilder private var footer: some View {
        HStack {
            Spacer()
            switch operation.runningState {
            case .none:
                Button {
                    dismiss()
                } label: {
                    Text(String(
                        localized: "settings.extensions.language-server-install.methods.cancel.button",
                        defaultValue: "Cancel",
                        comment: "Cancel button title in install method selection view"
                    ))
                }
                .buttonStyle(.bordered)
                Button {
                    do {
                        try registryManager.startInstallation(operation: operation)
                    } catch {
                        // Display the error
                        NSAlert(error: error).runModal()
                    }
                } label: {
                    Text(String(
                        localized: "settings.extensions.language-server-install.methods.install.button",
                        defaultValue: "Install",
                        comment: "Install button title in install method selection view"
                    ))
                }
                .buttonStyle(.borderedProminent)
            case .running:
                Button {
                    registryManager.cancelInstallation()
                    dismiss()
                } label: {
                    Text(String(
                        localized: "settings.extensions.language-server-install.details.cancel.button",
                        defaultValue: "Cancel",
                        comment: "Cancel button title in package details view"
                    ))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.bordered)
            case .complete:
                Button {
                    dismiss()
                } label: {
                    Text(String(
                        localized: "settings.extensions.language-server-install.details.continue.button",
                        defaultValue: "Continue",
                        comment: "Continue button title in package details view"
                    ))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }

    @ViewBuilder private var packageInfoSection: some View {
        Section {
            LabeledContent(String(
                localized: "settings.extensions.language-server-install.installing-package.title",
                defaultValue: "Installing Package",
                comment: "Title shown while package installation is running"
            ), value: operation.package.sanitizedName)
            LabeledContent(String(
                localized: "settings.extensions.language-server-install.package.homepage.label",
                defaultValue: "Homepage",
                comment: "Label for package homepage field"
            )) {
                sourceButton.cursor(.pointingHand)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(String(
                    localized: "settings.extensions.language-server-install.package.description.label",
                    defaultValue: "Description",
                    comment: "Label for package description field"
                ))
                Text(operation.package.sanitizedDescription)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.secondary)
                    .labelsHidden()
                    .textSelection(.enabled)
            }
        }
    }

    @ViewBuilder private var errorSection: some View {
        if let error = operation.error {
            Section {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.octagon.fill").foregroundColor(.red)
                    Text(String(
                        localized: "settings.extensions.language-server-install.progress.error-occurred.title",
                        defaultValue: "Error Occurred",
                        comment: "Title shown in installation progress view when an error occurs"
                    ))
                }
                .font(.title3)
                ErrorDescriptionLabel(error: error)
            }
        }
    }

    @ViewBuilder private var sourceButton: some View {
        if #available(macOS 14.0, *) {
            Button(operation.package.homepagePretty) {
                guard let homepage = operation.package.homepageURL else { return }
                NSWorkspace.shared.open(homepage)
            }
            .buttonStyle(.plain)
            .foregroundColor(Color(NSColor.linkColor))
            .focusEffectDisabled()
        } else {
            Button(operation.package.homepagePretty) {
                guard let homepage = operation.package.homepageURL else { return }
                NSWorkspace.shared.open(homepage)
            }
            .buttonStyle(.plain)
            .foregroundColor(Color(NSColor.linkColor))
        }
    }

    @ViewBuilder private var progressSection: some View {
        Section {
            LabeledContent(String(
                localized: "settings.extensions.language-server-install.progress.step.label",
                defaultValue: "Step",
                comment: "Label prefix for current installation step"
            )) {
                if registryManager.installedLanguageServers[operation.package.name] != nil {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text(String(
                            localized: "settings.extensions.language-server-install.result.successfully-installed.title",
                            defaultValue: "Successfully Installed",
                            comment: "Title shown when language server installation succeeds"
                        ))
                            .foregroundStyle(.primary)
                    }
                } else if operation.error != nil {
                    Text(String(
                        localized: "settings.extensions.language-server-install.result.error-occurred.title",
                        defaultValue: "Error Occurred",
                        comment: "Title shown on final result screen when installation fails"
                    ))
                } else {
                    Text(operation.currentStep?.name ?? "")
                }
            }
            ProgressView(operation.progress)
                .progressViewStyle(.linear)
        }
    }

    @ViewBuilder private var outputSection: some View {
        Section {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 2) {
                        ForEach(operation.accumulatedOutput) { line in
                            VStack {
                                if line.isStepDivider && line != operation.accumulatedOutput.first {
                                    Divider()
                                }
                                HStack(alignment: .firstTextBaseline, spacing: 6) {
                                    ZStack {
                                        if let idx = line.outputIdx {
                                            Text(String(idx))
                                                .font(.caption2.monospaced())
                                                .foregroundStyle(.tertiary)
                                        }
                                        Text(String(10)) // Placeholder for spacing
                                            .font(.caption2.monospaced())
                                            .foregroundStyle(.tertiary)
                                            .opacity(0.0)
                                    }
                                    Text(line.contents)
                                        .font(.caption.monospaced())
                                        .foregroundStyle(line.isStepDivider ? .primary : .secondary)
                                        .textSelection(.enabled)
                                    Spacer(minLength: 0)
                                }
                            }
                            .tag(line.id)
                            .id(line.id)
                        }
                    }
                }
                .onReceive(operation.$accumulatedOutput) { output in
                    DispatchQueue.main.async {
                        withAnimation(.linear(duration: 0.1)) {
                            proxy.scrollTo(output.last?.id)
                        }
                    }
                }
            }
        }
        .frame(height: 200)
    }

    @ViewBuilder private var notInstalledSection: some View {
        Section {
            if let method = operation.package.installMethod {
                LabeledContent(String(
                    localized: "settings.extensions.language-server-install.summary.install-method.label",
                    defaultValue: "Install Method",
                    comment: "Label for selected install method in summary information"
                ), value: method.installerDescription)
                    .textSelection(.enabled)
                if let packageDescription = method.packageDescription {
                    LabeledContent(String(
                        localized: "settings.extensions.language-server-install.summary.package.label",
                        defaultValue: "Package",
                        comment: "Label for selected package in summary information"
                    ), value: packageDescription)
                        .textSelection(.enabled)
                }
            } else {
                LabeledContent(String(
                    localized: "settings.extensions.language-server-install.summary.installer.label",
                    defaultValue: "Installer",
                    comment: "Label for installer value in summary information"
                ), value: String(
                    localized: "settings.extensions.language-server-install.summary.installer.unknown",
                    defaultValue: "Unknown",
                    comment: "Fallback value when installer name is unavailable"
                ))
            }
        }
    }
}
