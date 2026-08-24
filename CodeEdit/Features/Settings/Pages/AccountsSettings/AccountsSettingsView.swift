//
//  AccountsSettingsView.swift
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
                    Text(String(localized: "settings.accounts.empty-state.no-accounts", defaultValue: "No accounts", comment: "Empty state text when no accounts are configured"))
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
                    Button(String(localized: "settings.accounts.add-account.button", defaultValue: "Add Account...", comment: "Button title to add a new account")) { addAccountSheetPresented.toggle() }
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
            Text(String(localized: "settings.accounts.git-client.unsupported", defaultValue: "This git client is currently not supported.", comment: "Alert message when selected git client is not supported"))
            HStack {
                Button(String(localized: "settings.accounts.git-client.unsupported.close", defaultValue: "Close", comment: "Button title to dismiss unsupported git client alert")) {
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
