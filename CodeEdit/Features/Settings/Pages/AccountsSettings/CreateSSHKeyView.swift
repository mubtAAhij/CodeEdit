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

        var displayName: String {
            switch self {
            case .ed25519:
                return String(localized: "ssh.key_type.ed25519", defaultValue: "ED25519", comment: "ED25519 SSH key type")
            case .ecdsa:
                return String(localized: "ssh.key_type.ecdsa", defaultValue: "ECDSA", comment: "ECDSA SSH key type")
            case .rsa:
                return String(localized: "ssh.key_type.rsa", defaultValue: "RSA", comment: "RSA SSH key type")
            case .dsa:
                return String(localized: "ssh.key_type.dsa", defaultValue: "DSA", comment: "DSA SSH key type")
            }
        }
    }

    @State var selectedKeyType: KeyType = .ed25519
    @State var passphrase: String = ""
    @State var confirmPassphrase: String = ""

    var body: some View {
        VStack {
            Form {
                Section(String(localized: "ssh.create_key.title", defaultValue: "Create SSH key", comment: "Create SSH key dialog title")) {
                    Picker(String(localized: "ssh.create_key.key_type", defaultValue: "Key Type", comment: "SSH key type picker label"), selection: $selectedKeyType) {
                        Text(KeyType.ed25519.displayName)
                            .tag(KeyType.ed25519)
                        Text(KeyType.ecdsa.displayName)
                            .tag(KeyType.ecdsa)
                        Divider()
                        Group {
                            Text(KeyType.rsa.displayName) + Text(String(localized: "ssh.create_key.less_secure", defaultValue: " (less secure)", comment: "Less secure key type indicator")).foregroundColor(.secondary)
                        }
                        .tag(KeyType.rsa)
                        Group {
                            Text(KeyType.dsa.displayName) + Text(String(localized: "ssh.create_key.less_secure", defaultValue: " (less secure)", comment: "Less secure key type indicator")).foregroundColor(.secondary)
                        }
                        .tag(KeyType.dsa)
                    }
                    SecureField(String(localized: "ssh.create_key.passphrase", defaultValue: "Passphrase", comment: "SSH key passphrase field"), text: $passphrase)
                    if !passphrase.isEmpty {
                        SecureField(String(localized: "ssh.create_key.confirm_passphrase", defaultValue: "Confirm Passphrase", comment: "Confirm SSH key passphrase field"), text: $confirmPassphrase)
                    }
                }
            }
            .formStyle(.grouped)
            .fixedSize()
            .scrollDisabled(true)
            HStack {
                Spacer()
                Button(String(localized: "ssh.create_key.cancel", defaultValue: "Cancel", comment: "Cancel SSH key creation button")) {
                    dismiss()
                }
                Button(String(localized: "ssh.create_key.create", defaultValue: "Create", comment: "Create SSH key button")) {
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
