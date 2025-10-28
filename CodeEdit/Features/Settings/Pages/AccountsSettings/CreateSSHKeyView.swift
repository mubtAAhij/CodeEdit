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
                Section("ssh.create_key", comment: "Section title") {
                    Picker("ssh.key_type", comment: "Picker label", selection: $selectedKeyType) {
                        Text(KeyType.ed25519.rawValue)
                            .tag(KeyType.ed25519)
                        Text(KeyType.ecdsa.rawValue)
                            .tag(KeyType.ecdsa)
                        Divider()
                        Group {
                            Text(KeyType.rsa.rawValue) + Text("ssh.less_secure", comment: "Security warning").foregroundColor(.secondary)
                        }
                        .tag(KeyType.rsa)
                        Group {
                            Text(KeyType.dsa.rawValue) + Text("ssh.less_secure", comment: "Security warning").foregroundColor(.secondary)
                        }
                        .tag(KeyType.dsa)
                    }
                    SecureField("ssh.passphrase", text: $passphrase, prompt: Text("ssh.passphrase", comment: "Passphrase field"))
                    if !passphrase.isEmpty {
                        SecureField("ssh.confirm_passphrase", text: $confirmPassphrase, prompt: Text("ssh.confirm_passphrase", comment: "Confirm passphrase field"))
                    }
                }
            }
            .formStyle(.grouped)
            .fixedSize()
            .scrollDisabled(true)
            HStack {
                Spacer()
                Button("actions.cancel", comment: "Cancel button") {
                    dismiss()
                }
                Button("ssh.create", comment: "Create button") {
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
