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
                Section(String(localized: "accounts.ssh.create_key", comment: "Title for SSH key creation dialog")) {
                    Picker(String(localized: "accounts.ssh.key_type", comment: "Label for SSH key type selection"), selection: $selectedKeyType) {
                        Text(KeyType.ed25519.rawValue)
                            .tag(KeyType.ed25519)
                        Text(KeyType.ecdsa.rawValue)
                            .tag(KeyType.ecdsa)
                        Divider()
                        Group {
                            Text(KeyType.rsa.rawValue) + Text(String(localized: "accounts.ssh.less_secure", comment: "Security warning for SSH key type")).foregroundColor(.secondary)
                        }
                        .tag(KeyType.rsa)
                        Group {
                            Text(KeyType.dsa.rawValue) + Text(String(localized: "accounts.ssh.less_secure", comment: "Security warning for SSH key type")).foregroundColor(.secondary)
                        }
                        .tag(KeyType.dsa)
                    }
                    SecureField(String(localized: "accounts.ssh.passphrase", comment: "Label for SSH key passphrase field"), text: $passphrase)
                    if !passphrase.isEmpty {
                        SecureField(String(localized: "accounts.ssh.confirm_passphrase", comment: "Label for SSH key passphrase confirmation field"), text: $confirmPassphrase)
                    }
                }
            }
            .formStyle(.grouped)
            .fixedSize()
            .scrollDisabled(true)
            HStack {
                Spacer()
                Button(String(localized: "general.cancel", comment: "Cancel button")) {
                    dismiss()
                }
                Button(String(localized: "general.create", comment: "Create button")) {
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
