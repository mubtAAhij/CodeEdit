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
                String(localized: "ssh-key-type.ed25519", defaultValue: "ED25519", comment: "SSH key type: ED25519")
            case .ecdsa:
                String(localized: "ssh-key-type.ecdsa", defaultValue: "ECDSA", comment: "SSH key type: ECDSA")
            case .rsa:
                String(localized: "ssh-key-type.rsa", defaultValue: "RSA", comment: "SSH key type: RSA")
            case .dsa:
                String(localized: "ssh-key-type.dsa", defaultValue: "DSA", comment: "SSH key type: DSA")
            }
        }
    }

    @State var selectedKeyType: KeyType = .ed25519
    @State var passphrase: String = ""
    @State var confirmPassphrase: String = ""

    var body: some View {
        VStack {
            Form {
                Section(String(localized: "ssh-key.create-title", defaultValue: "Create SSH key", comment: "Title for SSH key creation section")) {
                    Picker(String(localized: "ssh-key.key-type", defaultValue: "Key Type", comment: "Label for SSH key type picker"), selection: $selectedKeyType) {
                        Text(KeyType.ed25519.displayName)
                            .tag(KeyType.ed25519)
                        Text(KeyType.ecdsa.displayName)
                            .tag(KeyType.ecdsa)
                        Divider()
                        Group {
                            Text(KeyType.rsa.displayName) + Text(String(localized: "ssh-key.less-secure-suffix", defaultValue: " (less secure)", comment: "Suffix indicating less secure SSH key type")).foregroundColor(.secondary)
                        }
                        .tag(KeyType.rsa)
                        Group {
                            Text(KeyType.dsa.displayName) + Text(String(localized: "ssh-key.less-secure-suffix", defaultValue: " (less secure)", comment: "Suffix indicating less secure SSH key type")).foregroundColor(.secondary)
                        }
                        .tag(KeyType.dsa)
                    }
                    SecureField(String(localized: "ssh-key.passphrase", defaultValue: "Passphrase", comment: "Label for SSH key passphrase field"), text: $passphrase)
                    if !passphrase.isEmpty {
                        SecureField(String(localized: "ssh-key.confirm-passphrase", defaultValue: "Confirm Passphrase", comment: "Label for confirm passphrase field"), text: $confirmPassphrase)
                    }
                }
            }
            .formStyle(.grouped)
            .fixedSize()
            .scrollDisabled(true)
            HStack {
                Spacer()
                Button(String(localized: "ssh-key.cancel", defaultValue: "Cancel", comment: "Cancel button for SSH key creation")) {
                    dismiss()
                }
                Button(String(localized: "ssh-key.create", defaultValue: "Create", comment: "Create button for SSH key creation")) {
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
