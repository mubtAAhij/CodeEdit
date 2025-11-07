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
                    localized: "create-ssh-key.title",
                    defaultValue: "Create SSH key",
                    comment: "Section title for creating SSH key"
                )) {
                    Picker(String(
                        localized: "create-ssh-key.key-type",
                        defaultValue: "Key Type",
                        comment: "Label for SSH key type picker"
                    ), selection: $selectedKeyType) {
                        Text(KeyType.ed25519.rawValue)
                            .tag(KeyType.ed25519)
                        Text(KeyType.ecdsa.rawValue)
                            .tag(KeyType.ecdsa)
                        Divider()
                        Group {
                            Text(KeyType.rsa.rawValue) + Text(String(
                                localized: "create-ssh-key.less-secure",
                                defaultValue: " (less secure)",
                                comment: "Label indicating less secure key type"
                            )).foregroundColor(.secondary)
                        }
                        .tag(KeyType.rsa)
                        Group {
                            Text(KeyType.dsa.rawValue) + Text(String(
                                localized: "create-ssh-key.less-secure",
                                defaultValue: " (less secure)",
                                comment: "Label indicating less secure key type"
                            )).foregroundColor(.secondary)
                        }
                        .tag(KeyType.dsa)
                    }
                    SecureField(String(
                        localized: "create-ssh-key.passphrase",
                        defaultValue: "Passphrase",
                        comment: "Label for passphrase field"
                    ), text: $passphrase)
                    if !passphrase.isEmpty {
                        SecureField(String(
                            localized: "create-ssh-key.confirm-passphrase",
                            defaultValue: "Confirm Passphrase",
                            comment: "Label for confirm passphrase field"
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
                    localized: "create-ssh-key.cancel",
                    defaultValue: "Cancel",
                    comment: "Button to cancel SSH key creation"
                )) {
                    dismiss()
                }
                Button(String(
                    localized: "create-ssh-key.create",
                    defaultValue: "Create",
                    comment: "Button to create SSH key"
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
