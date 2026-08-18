//
//  CreateSSHKeyView.swift
//  CodeEdit
//
//  Created by Austin Condiff on 4/28/23.
//

import SwiftUI

struct CreateSSHKeyView: View {
    @Environment(\.dismiss)
    private var dismiss

    enum KeyType: String, CaseIterable {
        case ed25519 = "ED25519"
        case ecdsa = "ECDSA"
        case rsa = "RSA"
        case dsa = "DSA"
    }

    @State var selectedKeyType: KeyType = .ed25519
    @State var passphrase: String = ""
    @State var confirmPassphrase: String = ""

    var body: some View {
        VStack {
            Form {
                Section(String(
                    localized: "settings.accounts.create-ssh-key.title",
                    defaultValue: "Create SSH key",
                    comment: "Title for create SSH key sheet"
                )) {
                    Picker(String(
                        localized: "settings.accounts.create-ssh-key.key-type",
                        defaultValue: "Key Type",
                        comment: "Label for SSH key type picker"
                    ), selection: $selectedKeyType) {
                        Text(KeyType.ed25519.rawValue)
                            .tag(KeyType.ed25519)
                        Text(KeyType.ecdsa.rawValue)
                            .tag(KeyType.ecdsa)
                        Divider()
                        Group {
                            Text(KeyType.rsa.rawValue) + Text(" " + String(
                                localized: "settings.accounts.create-ssh-key.rsa-less-secure",
                                defaultValue: "(less secure)",
                                comment: "Suffix indicating RSA key type is less secure"
                            )).foregroundColor(.secondary)
                        }
                        .tag(KeyType.rsa)
                        Group {
                            Text(KeyType.dsa.rawValue) + Text(" " + String(
                                localized: "settings.accounts.create-ssh-key.dsa-less-secure",
                                defaultValue: "(less secure)",
                                comment: "Suffix indicating DSA key type is less secure"
                            )).foregroundColor(.secondary)
                        }
                        .tag(KeyType.dsa)
                    }
                    SecureField(String(
                        localized: "settings.accounts.create-ssh-key.passphrase",
                        defaultValue: "Passphrase",
                        comment: "Label for SSH key passphrase field"
                    ), text: $passphrase)
                    if !passphrase.isEmpty {
                        SecureField(String(
                            localized: "settings.accounts.create-ssh-key.confirm-passphrase",
                            defaultValue: "Confirm Passphrase",
                            comment: "Label for SSH key passphrase confirmation field"
                        ), text: $confirmPassphrase)
                    }
                }
            }
            .formStyle(.grouped)
            .fixedSize()
            .scrollDisabled(true)
            HStack {
                Spacer()
                Button(String(
                    localized: "settings.accounts.create-ssh-key.cancel",
                    defaultValue: "Cancel",
                    comment: "Cancel button in create SSH key sheet"
                )) {
                    dismiss()
                }
                Button(String(
                    localized: "settings.accounts.create-ssh-key.create",
                    defaultValue: "Create",
                    comment: "Create button in create SSH key sheet"
                )) {
                    // create the ssh key
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
}
