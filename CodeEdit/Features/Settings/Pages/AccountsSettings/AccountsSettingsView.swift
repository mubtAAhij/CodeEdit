//
//  AccountSettingsView.swift
//  CodeEdit
//
//  Created by Austin Condiff on 4/4/23.
//

import SwiftUI

struct AccountsSettingsView: View {
    @AppSettings(\.accounts.sourceControlAccounts.gitAccounts)
    var gitAccounts

    @State private var addAccountSheetPresented: Bool = false
    @State private var selectedProvider: SourceControlAccount.Provider?

    var body: some View {
        SettingsForm {
            Section {
                if $gitAccounts.isEmpty {
                    Text(String(localized: "settings.accounts.no-accounts", defaultValue: "No accounts", comment: "Message displayed when no accounts are configured"))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    ForEach($gitAccounts, id: \.self) { $account in
                        AccountsSettingsAccountLink($account)
                    }
                }
            } footer: {
                HStack {
                    Spacer()
                    Button(String(localized: "settings.accounts.add-account", defaultValue: "Add Account...", comment: "Button to add a new account")) { addAccountSheetPresented.toggle() }
                    .sheet(isPresented: $addAccountSheetPresented, content: {
                        AccountSelectionView(selectedProvider: $selectedProvider)
                    })
                    .sheet(item: $selectedProvider, content: { provider in
                        switch provider {
                        case .github, .githubEnterprise, .gitlab, .gitlabSelfHosted:
                            AccountsSettingsSigninView(provider, addAccountSheetPresented: $addAccountSheetPresented)
                        default:
                            implementationNeeded
                        }
                    })
                }
                .padding(.top, 10)
            }
        }
    }

    private var implementationNeeded: some View {
        VStack(spacing: 20) {
            Text(String(localized: "settings.accounts.client-not-supported", defaultValue: "This git client is currently not supported.", comment: "Message for unsupported git clients"))
            HStack {
                Button(String(localized: "button.close", defaultValue: "Close", comment: "Button to close a dialog")) {
                    addAccountSheetPresented.toggle()
                    selectedProvider = nil
                }
                .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(20)
    }
}
