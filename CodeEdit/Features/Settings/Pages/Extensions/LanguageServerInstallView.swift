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
            String(localized: "settings.extensions.language-server.install.confirm-step", defaultValue: "Confirm Step", comment: "Header title for the confirmation step in language server installation."),
            isPresented: Binding(get: { operation.waitingForConfirmation != nil }, set: { _ in }),
            presenting: operation.waitingForConfirmation
        ) { _ in
            Button(String(localized: "settings.extensions.language-server.install.confirm.cancel", defaultValue: "Cancel", comment: "Cancel button title in language server install confirmation step.")) {
                registryManager.cancelInstallation()
            }
            Button(String(localized: "settings.extensions.language-server.install.confirm.continue", defaultValue: "Continue", comment: "Continue button title in language server install confirmation step.")) {
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
                    Text(String(localized: "settings.extensions.language-server.install.progress.cancel", defaultValue: "Cancel", comment: "Cancel button title while language server installation is in progress."))
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
                    Text(String(localized: "settings.extensions.language-server.install.action.install", defaultValue: "Install", comment: "Primary action button title to start language server installation."))
                }
                .buttonStyle(.borderedProminent)
            case .running:
                Button {
                    registryManager.cancelInstallation()
                    dismiss()
                } label: {
                    Text(String(localized: "settings.extensions.language-server.install.action.cancel", defaultValue: "Cancel", comment: "Cancel button title in language server install action row."))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.bordered)
            case .complete:
                Button {
                    dismiss()
                } label: {
                    Text(String(localized: "settings.extensions.language-server.install.action.continue", defaultValue: "Continue", comment: "Continue button title in language server install action row."))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }

    @ViewBuilder private var packageInfoSection: some View {
        Section {
            LabeledContent(String(localized: "settings.extensions.language-server.install.status.installing-package", defaultValue: "Installing Package", comment: "Status title shown while a language server package is being installed."), value: operation.package.sanitizedName)
            LabeledContent(String(localized: "settings.extensions.language-server.install.metadata.homepage", defaultValue: "Homepage", comment: "Label for language server package homepage field.")) {
                sourceButton.cursor(.pointingHand)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(String(localized: "settings.extensions.language-server.install.metadata.description", defaultValue: "Description", comment: "Label for language server package description field."))
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
                    Text(String(localized: "settings.extensions.language-server.install.error-occurred", defaultValue: "Error Occurred", comment: "Error header title shown when language server installation fails."))
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
            LabeledContent(String(localized: "settings.extensions.language-server.install.progress.step", defaultValue: "Step", comment: "Label prefix for current installation step information.")) {
                if registryManager.installedLanguageServers[operation.package.name] != nil {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text(String(localized: "settings.extensions.language-server.install.result.success", defaultValue: "Successfully Installed", comment: "Result title shown after successful language server installation."))
                            .foregroundStyle(.primary)
                    }
                } else if operation.error != nil {
                    Text(String(localized: "settings.extensions.language-server.install.result.error", defaultValue: "Error Occurred", comment: "Result title shown after failed language server installation."))
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
                LabeledContent(String(localized: "settings.extensions.language-server.install.metadata.install-method", defaultValue: "Install Method", comment: "Label for the package installation method field."), value: method.installerDescription)
                    .textSelection(.enabled)
                if let packageDescription = method.packageDescription {
                    LabeledContent(String(localized: "settings.extensions.language-server.install.metadata.package", defaultValue: "Package", comment: "Label for package source/install type."), value: packageDescription)
                        .textSelection(.enabled)
                }
            } else {
                LabeledContent(String(localized: "settings.extensions.language-server.install.metadata.installer", defaultValue: "Installer", comment: "Label for installer source/install type."), value: String(localized: "settings.extensions.language-server.install.metadata.unknown", defaultValue: "Unknown", comment: "Fallback label when install method is unknown."))
            }
        }
    }
}
