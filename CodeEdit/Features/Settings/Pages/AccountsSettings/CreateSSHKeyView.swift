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
                Section(String(localized: "create_ssh_key", comment: "SSH key creation form title")) {
                    Picker(String(localized: "key_type", comment: "SSH key type picker label"), selection: $selectedKeyType) {
                        Text(KeyType.ed25519.rawValue)
                            .tag(KeyType.ed25519)
                        Text(KeyType.ecdsa.rawValue)
                            .tag(KeyType.ecdsa)
                        Divider()
                        Group {
                            Text(KeyType.rsa.rawValue) + Text(String(localized: "less_secure", comment: "Security warning for less secure key types")).foregroundColor(.secondary)
                        }
                        .tag(KeyType.rsa)
                        Group {
                            Text(KeyType.dsa.rawValue) + Text(String(localized: "less_secure", comment: "Security warning for less secure key types")).foregroundColor(.secondary)
                        }
                        .tag(KeyType.dsa)
                    }
                    SecureField(String(localized: "passphrase", comment: "SSH key passphrase field label"), text: $passphrase)
                    if !passphrase.isEmpty {
                        SecureField(String(localized: "confirm_passphrase", comment: "SSH key passphrase confirmation field label"), text: $confirmPassphrase)
                    }
                }
            }
            .formStyle(.grouped)
            .fixedSize()
            .scrollDisabled(true)
            HStack {
                Spacer()
                Button(String(localized: "cancel", comment: "Cancel button label")) {
                    dismiss()
                }
                Button(String(localized: "create", comment: "Create button label")) {
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
