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
            String(localized: "extensions.language-server-install.confirm-step", defaultValue: "Confirm Step", comment: "Title for confirmation step in language server install flow"),
            isPresented: Binding(get: { operation.waitingForConfirmation != nil }, set: { _ in }),
            presenting: operation.waitingForConfirmation
        ) { _ in
            Button(String(localized: "extensions.language-server-install.cancel-confirm-step", defaultValue: "Cancel", comment: "Button title to cancel at confirmation step")) {
                registryManager.cancelInstallation()
            }
            Button(String(localized: "extensions.language-server-install.continue-confirm-step", defaultValue: "Continue", comment: "Button title to continue from confirmation step")) {
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
                    Text(String(localized: "extensions.language-server-install.cancel-download-step", defaultValue: "Cancel", comment: "Button title to cancel at download step"))
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
                    Text(String(localized: "extensions.language-server-install.install", defaultValue: "Install", comment: "Button title to start installing language server package"))
                }
                .buttonStyle(.borderedProminent)
            case .running:
                Button {
                    registryManager.cancelInstallation()
                    dismiss()
                } label: {
                    Text(String(localized: "extensions.language-server-install.cancel-install-step", defaultValue: "Cancel", comment: "Button title to cancel at install step"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.bordered)
            case .complete:
                Button {
                    dismiss()
                } label: {
                    Text(String(localized: "extensions.language-server-install.continue-install-step", defaultValue: "Continue", comment: "Button title to continue from install step"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }

    @ViewBuilder private var packageInfoSection: some View {
        Section {
            LabeledContent(String(localized: "extensions.language-server-install.installing-package", defaultValue: "Installing Package", comment: "Status title shown while installing package"), value: operation.package.sanitizedName)
            LabeledContent(String(localized: "extensions.language-server-install.homepage", defaultValue: "Homepage", comment: "Label for package homepage link")) {
                sourceButton.cursor(.pointingHand)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(String(localized: "extensions.language-server-install.description", defaultValue: "Description", comment: "Label for package description field"))
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
                    Text(String(localized: "extensions.language-server-install.error-occurred-status", defaultValue: "Error Occurred", comment: "Status title shown when an error occurs during install flow"))
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
            LabeledContent(String(localized: "extensions.language-server-install.step", defaultValue: "Step", comment: "Label for current step indicator in install flow")) {
                if registryManager.installedLanguageServers[operation.package.name] != nil {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text(String(localized: "extensions.language-server-install.successfully-installed", defaultValue: "Successfully Installed", comment: "Title shown when language server installation succeeds"))
                            .foregroundStyle(.primary)
                    }
                } else if operation.error != nil {
                    Text(String(localized: "extensions.language-server-install.error-occurred-result", defaultValue: "Error Occurred", comment: "Title shown in final result view when installation fails"))
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
                LabeledContent(String(localized: "extensions.language-server-install.install-method", defaultValue: "Install Method", comment: "Label for installation method field"), value: method.installerDescription)
                    .textSelection(.enabled)
                if let packageDescription = method.packageDescription {
                    LabeledContent(String(localized: "extensions.language-server-install.install-method.package", defaultValue: "Package", comment: "Install method option label for package-based install"), value: packageDescription)
                        .textSelection(.enabled)
                }
            } else {
                LabeledContent(String(localized: "extensions.language-server-install.install-method.installer", defaultValue: "Installer", comment: "Install method option label for installer-based install"), value: String(localized: "extensions.language-server-install.install-method.unknown", defaultValue: "Unknown", comment: "Install method fallback label when method cannot be determined"))
            }
        }
    }
}
