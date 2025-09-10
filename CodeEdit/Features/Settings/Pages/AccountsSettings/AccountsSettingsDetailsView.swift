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
                LabeledContent(String(localized: "account_details_account_label", comment: "Account label in account details view")) {
                    Text(currentAccount.name)
                }
                TextField(String(localized: "account_details_description_placeholder", comment: "Description placeholder in account details view"), text: $currentAccount.description)
                if currentAccount.provider.baseURL == nil {
                    TextField("String(localized: "server", comment: "Label for server URL input field")", text: $currentAccount.serverURL)
                }
            }

            Section {
                Picker(selection: $currentAccount.urlProtocol) {
                    Text("String(localized: "https", comment: "HTTPS protocol option")")
                        .tag(SourceControlAccount.URLProtocol.https)
                    Text("String(localized: "ssh", comment: "SSH protocol option")")
                        .tag(SourceControlAccount.URLProtocol.ssh)
                } label: {
                    Text("String(localized: "clone_using", comment: "Label for protocol selection picker")")
                    Text("String(localized: "new_repositories_will_be_cloned_from", comment: "Description text for clone protocol selection").replacingOccurrences(of: "%@", with: currentAccount.provider.name)"
                         + "String(localized: "using_protocol", comment: "Continuation of clone description with protocol").replacingOccurrences(of: "%@", with: currentAccount.urlProtocol.rawValue)")
                }
                .pickerStyle(.radioGroup)
                if currentAccount.urlProtocol == .ssh {
                    Picker(String(localized: "ssh_key", comment: "Label for SSH key picker in account settings"), selection: $currentAccount.sshKey) {
                        Text("None")
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
                        Text(String(localized: "create_new_ssh_key", comment: "Option to create a new SSH key"))
                            .tag("CREATE_NEW")
                        Text(String(localized: "choose_ssh_key", comment: "Option to choose an existing SSH key file"))
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
                    Button("String(localized: "delete_account", comment: "Button to delete a source control account")") {
                        deleteConfirmationIsPresented.toggle()
                    }
                    .alert(
                        Text("Are you sure you want to delete the account “\(account.description)”?"),
                        isPresented: $deleteConfirmationIsPresented
                    ) {
                        Button("String(localized: "ok", comment: "OK button text")") {
                            // Handle the account delete
                            handleAccountDelete()
                            dismiss()
                        }
                        Button("String(localized: "cancel", comment: "Cancel button in delete account confirmation dialog")") {
                            // Handle the cancel, dismiss the alert
                            deleteConfirmationIsPresented.toggle()
                        }
                    } message: {
                        Text("String(localized: "delete_account_message", comment: "Warning message when deleting an account")")
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
