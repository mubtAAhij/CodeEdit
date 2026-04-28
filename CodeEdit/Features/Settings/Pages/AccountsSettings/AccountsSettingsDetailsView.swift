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
                LabeledContent(String(localized: "account", defaultValue: "Account", comment: "Account label", os_id: "102298")) {
                    Text(currentAccount.name)
                }
                TextField(String(localized: "description", defaultValue: "Description", comment: "Description text field"), text: $currentAccount.description)
                if currentAccount.provider.baseURL == nil {
                    TextField(String(localized: "server", defaultValue: "Server", comment: "Server text field"), text: $currentAccount.serverURL)
                }
            }

            Section {
                Picker(selection: $currentAccount.urlProtocol) {
                    Text(String(localized: "https", defaultValue: "HTTPS", comment: "HTTPS option", os_id: "102300"))
                        .tag(SourceControlAccount.URLProtocol.https)
                    Text(String(localized: "ssh", defaultValue: "SSH", comment: "SSH option"))
                        .tag(SourceControlAccount.URLProtocol.ssh)
                } label: {
                    Text(String(localized: "clone-using", defaultValue: "Clone Using", comment: "Clone Using label", os_id: "102301"))
                    Text(String(format: String(localized: "new-repositories-will-be-cloned", defaultValue: "New repositories will be cloned from %@ using %@.", comment: "Clone repositories message", os_id: "102302"), currentAccount.provider.name, currentAccount.urlProtocol.rawValue))
                }
                .pickerStyle(.radioGroup)
                if currentAccount.urlProtocol == .ssh {
                    Picker(String(localized: "ssh-key", defaultValue: "SSH Key", comment: "SSH Key picker label", os_id: "102303"), selection: $currentAccount.sshKey) {
                        Text(String(localized: "none", defaultValue: "None", comment: "None option", os_id: "102304"))
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
                        Text(String(localized: "create-new", defaultValue: "Create New...", comment: "Create New option", os_id: "102305"))
                            .tag("CREATE_NEW")
                        Text(String(localized: "choose", defaultValue: "Choose...", comment: "Choose option", os_id: "102022"))
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
                    Button(String(localized: "delete-account", defaultValue: "Delete Account...", comment: "Delete Account button", os_id: "102306")) {
                        deleteConfirmationIsPresented.toggle()
                    }
                    .alert(
                        Text(String(format: String(localized: "delete-account-confirmation", defaultValue: "Are you sure you want to delete the account \"%@\"?", comment: "Delete account confirmation message", os_id: "102307"), account.description)),
                        isPresented: $deleteConfirmationIsPresented
                    ) {
                        Button(String(localized: "ok", defaultValue: "OK", comment: "OK button", os_id: "102309")) {
                            // Handle the account delete
                            handleAccountDelete()
                            dismiss()
                        }
                        Button(String(localized: "cancel", defaultValue: "Cancel", comment: "Cancel button", os_id: "102310")) {
                            // Handle the cancel, dismiss the alert
                            deleteConfirmationIsPresented.toggle()
                        }
                    } message: {
                        Text(String(localized: "delete-account-warning", defaultValue: "Deleting this account will remove it from CodeEdit.", comment: "Delete account warning message", os_id: "102308"))
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
