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
                LabeledContent(String(localized: "settings.account", defaultValue: "Account", comment: "Account label")) {
                    Text(currentAccount.name)
                }
                TextField(String(localized: "settings.account.description", defaultValue: "Description", comment: "Description field label"), text: $currentAccount.description)
                if currentAccount.provider.baseURL == nil {
                    TextField(String(localized: "settings.account.server", defaultValue: "Server", comment: "Server field label"), text: $currentAccount.serverURL)
                }
            }

            Section {
                Picker(selection: $currentAccount.urlProtocol) {
                    Text("HTTPS")
                        .tag(SourceControlAccount.URLProtocol.https)
                    Text("SSH")
                        .tag(SourceControlAccount.URLProtocol.ssh)
                } label: {
                    Text(String(localized: "settings.account.clone-using", defaultValue: "Clone Using", comment: "Clone using picker label"))
                    Text(String(format: NSLocalizedString("settings.account.clone-using-description", comment: "Clone using description"), currentAccount.provider.name, currentAccount.urlProtocol.rawValue))
                }
                .pickerStyle(.radioGroup)
                if currentAccount.urlProtocol == .ssh {
                    Picker(String(localized: "settings.account.ssh-key", defaultValue: "SSH Key", comment: "SSH key picker label"), selection: $currentAccount.sshKey) {
                        Text(String(localized: "settings.account.ssh-key-none", defaultValue: "None", comment: "No SSH key option"))
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
                        Text(String(localized: "settings.account.ssh-key-create-new", defaultValue: "Create New...", comment: "Create new SSH key option"))
                            .tag("CREATE_NEW")
                        Text(String(localized: "settings.account.ssh-key-choose", defaultValue: "Choose...", comment: "Choose SSH key option"))
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
                    Button(String(localized: "settings.account.delete-account", defaultValue: "Delete Account...", comment: "Delete account button")) {
                        deleteConfirmationIsPresented.toggle()
                    }
                    .alert(
                        Text(String(format: NSLocalizedString("settings.account.delete-confirmation", comment: "Delete account confirmation"), account.description)),
                        isPresented: $deleteConfirmationIsPresented
                    ) {
                        Button(String(localized: "common.ok", defaultValue: "OK", comment: "OK button")) {
                            // Handle the account delete
                            handleAccountDelete()
                            dismiss()
                        }
                        Button(String(localized: "common.cancel", defaultValue: "Cancel", comment: "Cancel button")) {
                            // Handle the cancel, dismiss the alert
                            deleteConfirmationIsPresented.toggle()
                        }
                    } message: {
                        Text(String(localized: "settings.account.delete-warning", defaultValue: "Deleting this account will remove it from CodeEdit.", comment: "Delete account warning message"))
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
