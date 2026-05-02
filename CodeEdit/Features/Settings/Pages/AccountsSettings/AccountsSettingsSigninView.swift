//
//  AccountsSettingsSigninView.swift
//  CodeEdit
//
//  Created by Austin Condiff on 4/5/23.
//

import SwiftUI

struct AccountsSettingsSigninView: View {
    @Environment(\.dismiss)
    var dismiss
    @Environment(\.openURL)
    var createToken

    var provider: SourceControlAccount.Provider
    @Binding var addAccountSheetPresented: Bool

    init(_ provider: SourceControlAccount.Provider, addAccountSheetPresented: Binding<Bool>) {
        self.provider = provider
        self._addAccountSheetPresented = addAccountSheetPresented
    }

    @State var server = ""
    @State var username = ""
    @State var personalAccessToken = ""

    @State var signinErrorAlertIsPresented: Bool = false
    @State var signinErrorDetail: String = ""

    @AppSettings(\.accounts.sourceControlAccounts.gitAccounts)
    var gitAccounts

    private let keychain = CodeEditKeychain()

    var body: some View {
        VStack(spacing: 0) {
            Form {
                Section(
                    content: {
                        if provider.baseURL == nil {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(String(localized: "accounts.signin.label.server", defaultValue: "Server", comment: "Label for server input field"))
                                    .font(.caption3)
                                    .foregroundColor(.secondary)
                                TextField("", text: $server, prompt: Text(String(localized: "accounts.signin.placeholder.server", defaultValue: "https://git.example.com", comment: "Example server URL placeholder")))
                                    .labelsHidden()
                            }
                        }
                        VStack(alignment: .leading, spacing: 5) {
                            Text(String(localized: "accounts.signin.label.username", defaultValue: "Username", comment: "Label for username input field"))
                                .font(.caption3)
                                .foregroundColor(.secondary)
                            TextField("", text: $username)
                                .labelsHidden()
                        }
                        VStack(alignment: .leading, spacing: 5) {
                            Text(String(localized: "accounts.signin.token", defaultValue: "Personal Access Token", comment: "Label for personal access token field"))
                                .font(.caption3)
                                .foregroundColor(.secondary)
                            SecureField("", text: $personalAccessToken)
                                .labelsHidden()
                         }
                    },
                    header: {
                        VStack(alignment: .center, spacing: 10) {
                            FeatureIcon(image: Image(provider.iconResource), size: 52)
                                .padding(.top, 5)
                            Text(String(format: String(localized: "accounts.signin.title", defaultValue: "Sign in to %@", comment: "Title for sign in view"), provider.name))
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                    },
                    footer: {
                        VStack(alignment: .leading, spacing: 5) {
                            if provider == .github {
                                Text(String(format: String(localized: "accounts.signin.scopes-required", defaultValue: "%@ personal access tokens must have these scopes set:", comment: "Message about required token scopes"), provider.name))
                                    .font(.system(size: 10.5))
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)
                                HStack(alignment: .center) {
                                    Spacer()
                                    VStack(alignment: .leading) {
                                        HStack(spacing: 2.5) {
                                            Image(systemName: String(localized: "accounts.signin.icon.checkmark", defaultValue: "checkmark", comment: "SF Symbol name for checkmark icon"))
                                                .font(.system(size: 10.5, weight: .semibold))
                                            Text(String(localized: "accounts.signin.scope.admin-public-key", defaultValue: "admin:public _key", comment: "GitHub scope admin:public_key"))
                                                .font(.system(size: 10.5))
                                        }
                                        HStack(spacing: 2.5) {
                                            Image(systemName: String(localized: "accounts.signin.icon.checkmark", defaultValue: "checkmark", comment: "SF Symbol name for checkmark icon"))
                                                .font(.system(size: 10.5, weight: .semibold))
                                            Text(String(localized: "accounts.signin.scope.write-discussion", defaultValue: "write:discussion", comment: "GitHub scope write:discussion"))
                                                .font(.system(size: 10.5))
                                        }
                                        HStack(spacing: 2.5) {
                                            Image(systemName: String(localized: "accounts.signin.icon.checkmark", defaultValue: "checkmark", comment: "SF Symbol name for checkmark icon"))
                                                .font(.system(size: 10.5, weight: .semibold))
                                            Text(String(localized: "accounts.signin.scope.repo", defaultValue: "repo", comment: "GitHub scope repo"))
                                                .font(.system(size: 10.5))
                                        }
                                        HStack(spacing: 2.5) {
                                            Image(systemName: String(localized: "accounts.signin.icon.checkmark", defaultValue: "checkmark", comment: "SF Symbol name for checkmark icon"))
                                                .font(.system(size: 10.5, weight: .semibold))
                                            Text(String(localized: "accounts.signin.scope.user", defaultValue: "user", comment: "GitHub scope user"))
                                                .font(.system(size: 10.5))
                                        }
                                    }
                                    Spacer()
                                }
                                .foregroundColor(.secondary)
                            }
                            Button {
                                createToken(provider.authHelpURL)
                            } label: {
                                if provider.authType == .password {
                                    Text(String(format: String(localized: "accounts.signin.create-password", defaultValue: "Create a Password on %@", comment: "Button text to create password on provider"), provider.name))
                                        .font(.system(size: 10.5))
                                } else {
                                    Text(String(format: String(localized: "accounts.signin.create-token", defaultValue: "Create a Token on %@", comment: "Button text to create token on provider"), provider.name))
                                        .font(.system(size: 10.5))
                                }
                            }
                            .buttonStyle(.link)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(maxWidth: .infinity)
                    }
                )
            }
            .formStyle(.grouped)
            .scrollDisabled(true)
            .onSubmit {
                signin()
            }
            HStack {
                Button {
                    addAccountSheetPresented.toggle()
                    dismiss()
                } label: {
                    Text(String(localized: "accounts.signin.button.cancel", defaultValue: "Cancel", comment: "Cancel button label"))
                        .frame(maxWidth: .infinity)
                }
                .controlSize(.large)
                .frame(maxWidth: .infinity)

                Button {
                    signin()
                } label: {
                    Text(String(localized: "accounts.signin.sign-in", defaultValue: "Sign In", comment: "Sign in button text"))
                        .frame(maxWidth: .infinity)
                }
                .disabled(username.isEmpty || personalAccessToken.isEmpty)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .alert(
                    Text(String(format: String(localized: "accounts.signin.unable-to-add", defaultValue: "Unable to add account \"%@\"", comment: "Alert title when unable to add account"), username)),
                    isPresented: $signinErrorAlertIsPresented
                ) {
                    Button(String(localized: "accounts.signin.button.ok", defaultValue: "OK", comment: "OK button label")) {
                        signinErrorAlertIsPresented.toggle()
                    }
                } message: {
                    Text(signinErrorDetail)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .frame(width: 300)
    }

    private func signin() {
        if gitAccounts.contains(
            where: {
                $0.serverURL == provider.baseURL?.absoluteString ?? server &&
                $0.name.lowercased() == username.lowercased()
            }
        ) {
            // Show alert when adding a duplicated account
            signinErrorDetail = String(localized: "accounts.signin.error.duplicate-account", defaultValue: "Account with the same username and provider already exists!", comment: "Error message when account already exists")
            signinErrorAlertIsPresented.toggle()
        } else {
            let configURL = provider.apiURL?.absoluteString ?? server
            switch provider {
            case .github, .githubEnterprise:
                let config = GitHubTokenConfiguration(personalAccessToken, url: configURL)
                GitHubAccount(config).me { response in
                    switch response {
                    case .success:
                        handleGitRequestSuccess()
                    case .failure(let error):
                        handleGitRequestFailed(error)
                    }
                }
            case .gitlab, .gitlabSelfHosted:
                let config = GitLabTokenConfiguration(personalAccessToken, url: configURL)
                GitLabAccount(config).me { response in
                    switch response {
                    case .success:
                        handleGitRequestSuccess()
                    case .failure(let error):
                        handleGitRequestFailed(error)
                    }
                }
            default:
                print(String(localized: "accounts.signin.debug.no-action", defaultValue: "do nothing", comment: "Debug message for default case"))
            }
        }
    }

    private func handleGitRequestSuccess() {
        let providerLink = provider.baseURL?.absoluteString ?? server

        self.gitAccounts.append(
            SourceControlAccount(
                id: String(format: String(localized: "accounts.signin.account-id-format", defaultValue: "%@_%@", comment: "Format for account ID with provider and username"), providerLink, username.lowercased()),
                name: username,
                description: provider.name,
                provider: provider,
                serverURL: providerLink,
                urlProtocol: .https,
                sshKey: "",
                isTokenValid: true
            )
        )

        keychain.set(personalAccessToken, forKey: String(format: String(localized: "accounts.signin.keychain-key-format", defaultValue: "github_%@_enterprise", comment: "Format for keychain key with username"), username))
        dismiss()
    }

    private func handleGitRequestFailed(_ error: Error) {
        print(String(format: String(localized: "accounts.signin.debug.auth-failure", defaultValue: "git auth failure: %@", comment: "Debug message for authentication failure"), String(describing: error)))
        // Show alert if error encountered while requesting signin
        switch error._code {
        case -1009:
            signinErrorDetail = error.localizedDescription
        case 401:
            signinErrorDetail = String(localized: "accounts.signin.error.auth-failed", defaultValue: "Authentication Failed", comment: "Error message for authentication failure")
        case 403:
            signinErrorDetail = String(localized: "accounts.signin.error.api-forbidden", defaultValue: "API Access Forbidden", comment: "Error message for forbidden API access")
        default:
            signinErrorDetail = String(localized: "accounts.signin.error.unknown", defaultValue: "Unknown Error", comment: "Error message for unknown error")
        }
        signinErrorAlertIsPresented.toggle()
    }
}
