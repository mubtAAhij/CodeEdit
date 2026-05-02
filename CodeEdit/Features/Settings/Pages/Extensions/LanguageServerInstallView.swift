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
            String(localized: "language.server.install.confirm.step.title", defaultValue: "Confirm Step", comment: "Alert title for confirming installation step"),
            isPresented: Binding(get: { operation.waitingForConfirmation != nil }, set: { _ in }),
            presenting: operation.waitingForConfirmation
        ) { _ in
            Button(String(localized: "language.server.install.confirm.cancel", defaultValue: "Cancel", comment: "Button to cancel installation step")) {
                registryManager.cancelInstallation()
            }
            Button(String(localized: "language.server.install.confirm.continue", defaultValue: "Continue", comment: "Button to continue with installation step")) {
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
                    Text(String(localized: "language.server.install.footer.cancel", defaultValue: "Cancel", comment: "Button to cancel language server installation"))
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
                    Text(String(localized: "language.server.install.footer.install", defaultValue: "Install", comment: "Button to start language server installation"))
                }
                .buttonStyle(.borderedProminent)
            case .running:
                Button {
                    registryManager.cancelInstallation()
                    dismiss()
                } label: {
                    Text(String(localized: "language.server.install.footer.running.cancel", defaultValue: "Cancel", comment: "Button to cancel running language server installation"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.bordered)
            case .complete:
                Button {
                    dismiss()
                } label: {
                    Text(String(localized: "language.server.install.footer.complete.continue", defaultValue: "Continue", comment: "Button to continue after language server installation completes"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }

    @ViewBuilder private var packageInfoSection: some View {
        Section {
            LabeledContent(String(localized: "language.server.install.package.label", defaultValue: "Installing Package", comment: "Label for package name being installed"), value: operation.package.sanitizedName)
            LabeledContent(String(localized: "language.server.install.homepage.label", defaultValue: "Homepage", comment: "Label for package homepage link")) {
                sourceButton.cursor(.pointingHand)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(String(localized: "language.server.install.description.label", defaultValue: "Description", comment: "Label for package description"))
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
                    Image(systemName: String(localized: "language.server.install.error.icon", defaultValue: "exclamationmark.octagon.fill", comment: "System icon name for installation error")).foregroundColor(.red)
                    Text(String(localized: "language.server.install.error.title", defaultValue: "Error Occurred", comment: "Title for installation error section"))
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
            LabeledContent(String(localized: "language.server.install.step.label", defaultValue: "Step", comment: "Label for current installation step")) {
                if registryManager.installedLanguageServers[operation.package.name] != nil {
                    HStack(spacing: 4) {
                        Image(systemName: String(localized: "language.server.install.success.icon", defaultValue: "checkmark.circle.fill", comment: "System icon name for successful installation"))
                            .foregroundColor(.green)
                        Text(String(localized: "language.server.install.success.message", defaultValue: "Successfully Installed", comment: "Message for successful installation"))
                            .foregroundStyle(.primary)
                    }
                } else if operation.error != nil {
                    Text(String(localized: "language.server.install.progress.error", defaultValue: "Error Occurred", comment: "Message for installation error in progress"))
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
                LabeledContent(String(localized: "language.server.install.method.label", defaultValue: "Install Method", comment: "Label for installation method"), value: method.installerDescription)
                    .textSelection(.enabled)
                if let packageDescription = method.packageDescription {
                    LabeledContent(String(localized: "language.server.install.package.info.label", defaultValue: "Package", comment: "Label for package information"), value: packageDescription)
                        .textSelection(.enabled)
                }
            } else {
                LabeledContent(String(localized: "language.server.install.installer.label", defaultValue: "Installer", comment: "Label for installer type"), value: String(localized: "language.server.install.installer.unknown", defaultValue: "Unknown", comment: "Value when installer is unknown"))
            }
        }
    }
}
