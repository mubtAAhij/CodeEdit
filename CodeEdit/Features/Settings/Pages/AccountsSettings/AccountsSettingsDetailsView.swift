//
//  AccountsSettingsDetailView.swift
//  CodeEdit
//
//  Created by Austin Condiff on 4/6/23.
//

import SwiftUI

struct AccountsSettingsDetailsView: View {
    @Environment(\.dismiss)
    private var dismiss
    @AppSettings(\.accounts.sourceControlAccounts.sshKey)
    var sshKey
    @AppSettings(\.accounts.sourceControlAccounts.gitAccounts)
    var gitAccounts
    @Binding var account: SourceControlAccount

    @State var currentAccount: SourceControlAccount
    @State var deleteConfirmationIsPresented: Bool = false
    @State var prevSshKey: String
    @State var createSshKeyIsPresented: Bool = false

    init(_ account: Binding<SourceControlAccount>) {
        _account = account
        _currentAccount = State(initialValue: account.wrappedValue)
        _prevSshKey = State(initialValue: account.sshKey.wrappedValue)
    }

    /// Default instance of the `FileManager`
    private let filemanager = FileManager.default

    func isPrivateSSHKey(_ contents: String) -> Bool {
        if contents.starts(with: String(localized: "accounts.details.ssh.private-key-header", defaultValue: "-----BEGIN OPENSSH PRIVATE KEY-----\n", comment: "OpenSSH private key header")) &&
           contents.hasSuffix(String(localized: "accounts.details.ssh.private-key-footer", defaultValue: "\n-----END OPENSSH PRIVATE KEY-----\n", comment: "OpenSSH private key footer")) {
            return true
        } else {
            return false
        }
    }

    func isPublicSSHKey(_ contents: String) -> Bool {
        let sshKeyPattern = "^ssh-(rsa|dss|ed25519)\\s+[A-Za-z0-9+/]+[=]{0,2}(\\s+.+)?$"
        do {
            let regex = try NSRegularExpression(pattern: sshKeyPattern)
            let range = NSRange(location: 0, length: contents.utf16.count)
            return regex.firstMatch(in: contents, options: [], range: range) != nil
        } catch {
            print(String(format: String(localized: "accounts.details.debug.regex-error", defaultValue: "Error creating regular expression: %@", comment: "Debug message for regex error"), error.localizedDescription))
            return false
        }
    }

    var body: some View {
        SettingsForm {
            Section {
                LabeledContent(String(localized: "accounts.details.account", defaultValue: "Account", comment: "Label for account field")) {
                    Text(currentAccount.name)
                }
                TextField(String(localized: "accounts.details.description", defaultValue: "Description", comment: "Label for description field"), text: $currentAccount.description)
                if currentAccount.provider.baseURL == nil {
                    TextField(String(localized: "accounts.details.server", defaultValue: "Server", comment: "Label for server field"), text: $currentAccount.serverURL)
                }
            }

            Section {
                Picker(selection: $currentAccount.urlProtocol) {
                    Text(String(localized: "accounts.details.protocol.https", defaultValue: "HTTPS", comment: "HTTPS protocol option"))
                        .tag(SourceControlAccount.URLProtocol.https)
                    Text(String(localized: "accounts.details.protocol.ssh", defaultValue: "SSH", comment: "SSH protocol option"))
                        .tag(SourceControlAccount.URLProtocol.ssh)
                } label: {
                    Text(String(localized: "accounts.details.clone-using", defaultValue: "Clone Using", comment: "Label for clone protocol picker"))
                    Text(String(format: String(localized: "accounts.details.clone-description", defaultValue: "New repositories will be cloned from %@ using %@.", comment: "Description of clone settings"), currentAccount.provider.name, currentAccount.urlProtocol.rawValue))
                }
                .pickerStyle(.radioGroup)
                if currentAccount.urlProtocol == .ssh {
                    Picker(String(localized: "accounts.details.ssh-key", defaultValue: "SSH Key", comment: "Label for SSH key picker"), selection: $currentAccount.sshKey) {
                        Text(String(localized: "accounts.details.ssh-key.none", defaultValue: "None", comment: "No SSH key option"))
                            .tag("")
                        Divider()
                        if let sshPath = FileManager.default.homeDirectoryForCurrentUser.appending(
                            path: String(localized: "accounts.details.ssh.directory", defaultValue: ".ssh", comment: "SSH directory name"),
                            directoryHint: .isDirectory
                        ) as URL? {
                            if let files = try? FileManager.default.contentsOfDirectory(
                                atPath: sshPath.path
                            ) {
                                ForEach(files, id: \.self) { filename in
                                    let fileURL = sshPath.appending(path: filename)
                                    if let contents = try? String(contentsOf: fileURL) {
                                        if isPublicSSHKey(contents) {
                                            Text(filename.replacingOccurrences(of: String(localized: "accounts.details.ssh.pub-extension", defaultValue: ".pub", comment: "SSH public key file extension"), with: ""))
                                                .tag(fileURL.path)
                                        }
                                    }
                                }
                                Divider()
                            }
                        }
                        Text(String(localized: "accounts.details.ssh-key.create-new", defaultValue: "Create New...", comment: "Option to create new SSH key"))
                            .tag(String(localized: "accounts.details.ssh-key.create-new-tag", defaultValue: "CREATE_NEW", comment: "Tag for create new SSH key option"))
                        Text(String(localized: "accounts.details.ssh-key.choose", defaultValue: "Choose...", comment: "Option to choose SSH key"))
                            .tag(String(localized: "accounts.details.ssh-key.choose-tag", defaultValue: "CHOOSE", comment: "Tag for choose SSH key option"))
                    }
                    .onReceive([currentAccount.sshKey].publisher.first()) { value in
                        if value == String(localized: "accounts.details.ssh-key.create-new-tag", defaultValue: "CREATE_NEW", comment: "Tag for create new SSH key option") {
                            print(String(localized: "accounts.details.debug.create-ssh-key", defaultValue: "Create a new ssh key...", comment: "Debug message for creating SSH key"))
                            createSshKeyIsPresented = true
                            currentAccount.sshKey = prevSshKey
                        } else if value == String(localized: "accounts.details.ssh-key.choose-tag", defaultValue: "CHOOSE", comment: "Tag for choose SSH key option") {
                            print(String(localized: "accounts.details.debug.choose-ssh-key", defaultValue: "Choose a ssh key...", comment: "Debug message for choosing SSH key"))
                            currentAccount.sshKey = prevSshKey
                        } else {
                            // TODO: Validate SSH key and check if it is uploaded to git provider.
                            // If not provide button to do so
                        }
                        prevSshKey = currentAccount.sshKey
                    }
                    .sheet(isPresented: $createSshKeyIsPresented, content: { CreateSSHKeyView() })
                }
            } footer: {
                HStack {
                    Button(String(localized: "accounts.details.delete-account", defaultValue: "Delete Account...", comment: "Button to delete account")) {
                        deleteConfirmationIsPresented.toggle()
                    }
                    .alert(
                        Text(String(format: String(localized: "accounts.details.delete-confirmation", defaultValue: "Are you sure you want to delete the account \"%@\"?", comment: "Confirmation message for account deletion"), account.description)),
                        isPresented: $deleteConfirmationIsPresented
                    ) {
                        Button(String(localized: "accounts.details.ok", defaultValue: "OK", comment: "OK button text")) {
                            // Handle the account delete
                            handleAccountDelete()
                            dismiss()
                        }
                        Button(String(localized: "accounts.details.cancel", defaultValue: "Cancel", comment: "Cancel button text")) {
                            // Handle the cancel, dismiss the alert
                            deleteConfirmationIsPresented.toggle()
                        }
                    } message: {
                        Text(String(localized: "accounts.details.delete-warning", defaultValue: "Deleting this account will remove it from CodeEdit.", comment: "Warning message for account deletion"))
                    }

                    Spacer()
                }
                .padding(.top, 10)
            }
        }
        .onChange(of: currentAccount) { _, newValue in
            account = newValue
        }
        .navigationTitle(currentAccount.description)
        .navigationBarBackButtonVisible()
    }

    private func handleAccountDelete() {
        // Delete account by finding the position of the account and remove by position
        if let gitAccount = gitAccounts.firstIndex(of: account) {
            gitAccounts.remove(at: gitAccount)
        }
    }
}
