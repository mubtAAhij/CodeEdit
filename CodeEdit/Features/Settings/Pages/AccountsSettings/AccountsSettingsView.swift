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
                    Text(String(localized: "accountsSettings.noAccounts", comment: "Empty state message"))
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
                    Button(String(localized: "accountsSettings.addAccount", comment: "Button text")) { addAccountSheetPresented.toggle() }
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
            Text(String(localized: "accountsSettings.gitClientNotSupported", comment: "Error message"))
            HStack {
                Button(String(localized: "accountsSettings.close", comment: "Button text")) {
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
