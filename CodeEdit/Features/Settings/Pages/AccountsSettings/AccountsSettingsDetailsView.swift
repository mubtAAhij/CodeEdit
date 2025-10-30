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
        if contents.starts(with: "-----BEGIN OPENSSH PRIVATE KEY-----\n") &&
           contents.hasSuffix("\n-----END OPENSSH PRIVATE KEY-----\n") {
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
            print("Error creating regular expression: \(error.localizedDescription)")
            return false
        }
    }

    var body: some View {
        SettingsForm {
            Section {
                LabeledContent(String(localized: "settings.accounts.details.account", defaultValue: "Account", comment: "Label for account field")) {
                    Text(currentAccount.name)
                }
                TextField(String(localized: "settings.accounts.details.description", defaultValue: "Description", comment: "Text field placeholder for description"), text: $currentAccount.description)
                if currentAccount.provider.baseURL == nil {
                    TextField(String(localized: "settings.accounts.details.server", defaultValue: "Server", comment: "Text field placeholder for server"), text: $currentAccount.serverURL)
                }
            }

            Section {
                Picker(selection: $currentAccount.urlProtocol) {
                    Text(String(localized: "settings.accounts.details.https", defaultValue: "HTTPS", comment: "HTTPS option in clone using picker"))
                        .tag(SourceControlAccount.URLProtocol.https)
                    Text("SSH")
                        .tag(SourceControlAccount.URLProtocol.ssh)
                } label: {
                    Text(String(localized: "settings.accounts.details.clone-using", defaultValue: "Clone Using", comment: "Label for clone using picker"))
                    Text(String(localized: "settings.accounts.details.clone-description", defaultValue: "New repositories will be cloned from \(currentAccount.provider.name) using \(currentAccount.urlProtocol.rawValue).", comment: "Description for clone using setting"))
                }
                .pickerStyle(.radioGroup)
                if currentAccount.urlProtocol == .ssh {
                    Picker(String(localized: "settings.accounts.details.ssh-key", defaultValue: "SSH Key", comment: "Label for SSH key picker"), selection: $currentAccount.sshKey) {
                        Text(String(localized: "settings.accounts.details.none", defaultValue: "None", comment: "None option for SSH key"))
                            .tag("")
                        Divider()
                        if let sshPath = FileManager.default.homeDirectoryForCurrentUser.appending(
                            path: ".ssh",
                            directoryHint: .isDirectory
                        ) as URL? {
                            if let files = try? FileManager.default.contentsOfDirectory(
                                atPath: sshPath.path
                            ) {
                                ForEach(files, id: \.self) { filename in
                                    let fileURL = sshPath.appending(path: filename)
                                    if let contents = try? String(contentsOf: fileURL) {
                                        if isPublicSSHKey(contents) {
                                            Text(filename.replacingOccurrences(of: ".pub", with: ""))
                                                .tag(fileURL.path)
                                        }
                                    }
                                }
                                Divider()
                            }
                        }
                        Text(String(localized: "settings.accounts.details.create-new", defaultValue: "Create New...", comment: "Menu item to create new SSH key"))
                            .tag("CREATE_NEW")
                        Text(String(localized: "settings.accounts.details.choose", defaultValue: "Choose...", comment: "Menu item to choose SSH key"))
                            .tag("CHOOSE")
                    }
                    .onReceive([currentAccount.sshKey].publisher.first()) { value in
                        if value == "CREATE_NEW" {
                            print("Create a new ssh key...")
                            createSshKeyIsPresented = true
                            currentAccount.sshKey = prevSshKey
                        } else if value == "CHOOSE" {
                            print("Choose a ssh key...")
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
                    Button(String(localized: "settings.accounts.details.delete", defaultValue: "Delete Account...", comment: "Button to delete account")) {
                        deleteConfirmationIsPresented.toggle()
                    }
                    .alert(
                        Text("Are you sure you want to delete the account “\(account.description)”?"),
                        Text(String(localized: "settings.accounts.delete.confirm-message", defaultValue: "Are you sure you want to delete the account "\(account.description)"?", comment: "Alert message to confirm account deletion")),
                    ) {
                        Button(String(localized: "settings.accounts.delete.ok", defaultValue: "OK", comment: "OK button in account deletion confirmation")) {
                            // Handle the account delete
                            handleAccountDelete()
                            dismiss()
                        }
                        Button(String(localized: "settings.accounts.delete.cancel", defaultValue: "Cancel", comment: "Cancel button in account deletion confirmation")) {
                            // Handle the cancel, dismiss the alert
                            deleteConfirmationIsPresented.toggle()
                        }
                    } message: {
                        Text(String(localized: "settings.accounts.delete.warning", defaultValue: "Deleting this account will remove it from CodeEdit.", comment: "Warning message about account deletion"))
                    }

                    Spacer()
                }
                .padding(.top, 10)
            }
        }
        .onChange(of: currentAccount) { newValue in
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
