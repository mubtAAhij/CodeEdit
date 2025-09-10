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
                Section("String(localized: "create_ssh_key", comment: "Section title for creating SSH key")") {
                    Picker("String(localized: "key_type", comment: "Label for SSH key type picker")", selection: $selectedKeyType) {
                        Text(KeyType.ed25519.rawValue)
                            .tag(KeyType.ed25519)
                        Text(KeyType.ecdsa.rawValue)
                            .tag(KeyType.ecdsa)
                        Divider()
                        Group {
                            Text(KeyType.rsa.rawValue) + Text("String(localized: "less_secure_note", comment: "Note indicating less secure option")").foregroundColor(.secondary)
                        }
                        .tag(KeyType.rsa)
                        Group {
                            Text(KeyType.dsa.rawValue) + Text("String(localized: "ssh_key_less_secure", comment: "Label indicating SSH key type is less secure")").foregroundColor(.secondary)
                        }
                        .tag(KeyType.dsa)
                    }
                    SecureField("String(localized: "passphrase", comment: "Label for SSH key passphrase field")", text: $passphrase)
                    if !passphrase.isEmpty {
                        SecureField("String(localized: "confirm_passphrase", comment: "Label for confirming SSH key passphrase field")", text: $confirmPassphrase)
                    }
                }
            }
            .formStyle(.grouped)
            .fixedSize()
            .scrollDisabled(true)
            HStack {
                Spacer()
                Button("String(localized: "cancel", comment: "Cancel button text")") {
                    dismiss()
                }
                Button("String(localized: "create", comment: "Create button text")") {
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
