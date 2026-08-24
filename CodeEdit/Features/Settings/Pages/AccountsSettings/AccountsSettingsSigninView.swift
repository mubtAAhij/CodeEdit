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
                                Text(String(localized: "settings.accounts.signin.server", defaultValue: "Server", comment: "Field label for account server URL"))
                                    .font(.caption3)
                                    .foregroundColor(.secondary)
                                TextField("", text: $server, prompt: Text(String(localized: "settings.accounts.signin.server-placeholder", defaultValue: "https://git.example.com", comment: "Placeholder shown in server URL input field")))
                                    .labelsHidden()
                            }
                        }
                        VStack(alignment: .leading, spacing: 5) {
                            Text(String(localized: "settings.accounts.signin.username", defaultValue: "Username", comment: "Field label for account username"))
                                .font(.caption3)
                                .foregroundColor(.secondary)
                            TextField("", text: $username)
                                .labelsHidden()
                        }
                        VStack(alignment: .leading, spacing: 5) {
                            Text(String(localized: "settings.accounts.signin.personal-access-token", defaultValue: "Personal Access Token", comment: "Field label for personal access token input"))
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
                            Text(String(format: String(localized: "settings.accounts.signin.title", defaultValue: "Sign in to %@", comment: "Title for signing in to a selected source control provider"), "\(provider.name)"))
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                    },
                    footer: {
                        VStack(alignment: .leading, spacing: 5) {
                            if provider == .github {
                                Text(String(format: String(localized: "settings.accounts.signin.scopes-required", defaultValue: "%@ personal access tokens must have these scopes set:", comment: "Instruction text listing required access token scopes"), "\(provider.name)"))
                                    .font(.system(size: 10.5))
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)
                                HStack(alignment: .center) {
                                    Spacer()
                                    VStack(alignment: .leading) {
                                        HStack(spacing: 2.5) {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 10.5, weight: .semibold))
                                            Text(String(localized: "settings.accounts.signin.required-scope.admin-public-key", defaultValue: "admin:public _key", comment: "Required OAuth scope token shown for provider setup"))
                                                .font(.system(size: 10.5))
                                        }
                                        HStack(spacing: 2.5) {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 10.5, weight: .semibold))
                                            Text(String(localized: "settings.accounts.signin.required-scope.write-discussion", defaultValue: "write:discussion", comment: "Required OAuth scope token shown for provider setup"))
                                                .font(.system(size: 10.5))
                                        }
                                        HStack(spacing: 2.5) {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 10.5, weight: .semibold))
                                            Text(String(localized: "settings.accounts.signin.required-scope.repo", defaultValue: "repo", comment: "Required OAuth scope token shown for provider setup"))
                                                .font(.system(size: 10.5))
                                        }
                                        HStack(spacing: 2.5) {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 10.5, weight: .semibold))
                                            Text(String(localized: "settings.accounts.signin.required-scope.user", defaultValue: "user", comment: "Required OAuth scope token shown for provider setup"))
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
                                    Text(String(format: String(localized: "settings.accounts.signin.create-password-on-provider", defaultValue: "Create a Password on %@", comment: "Button title linking to create a password on the provider"), "\(provider.name)"))
                                        .font(.system(size: 10.5))
                                } else {
                                    Text(String(format: String(localized: "settings.accounts.signin.create-token-on-provider", defaultValue: "Create a Token on %@", comment: "Button title linking to create a token on the provider"), "\(provider.name)"))
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
                    Text(String(localized: "settings.accounts.signin.cancel", defaultValue: "Cancel", comment: "Button title to cancel account sign in"))
                        .frame(maxWidth: .infinity)
                }
                .controlSize(.large)
                .frame(maxWidth: .infinity)

                Button {
                    signin()
                } label: {
                    Text(String(localized: "settings.accounts.signin.sign-in", defaultValue: "Sign In", comment: "Button title to submit sign-in credentials"))
                        .frame(maxWidth: .infinity)
                }
                .disabled(username.isEmpty || personalAccessToken.isEmpty)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .alert(
                    Text(String(format: String(localized: "settings.accounts.signin.unable-to-add-account", defaultValue: "Unable to add account “%@”", comment: "Alert title shown when adding account fails"), "\(username)")),
                    isPresented: $signinErrorAlertIsPresented
                ) {
                    Button(String(localized: "settings.accounts.signin.error-ok", defaultValue: "OK", comment: "Confirmation button for sign-in error alert")) {
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
            signinErrorDetail = String(localized: "settings.accounts.signin.account-already-exists", defaultValue: "Account with the same username and provider already exists!", comment: "Validation error shown when account already exists")
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
                print("do nothing")
            }
        }
    }

    private func handleGitRequestSuccess() {
        let providerLink = provider.baseURL?.absoluteString ?? server

        self.gitAccounts.append(
            SourceControlAccount(
                id: "\(providerLink)_\(username.lowercased())",
                name: username,
                description: provider.name,
                provider: provider,
                serverURL: providerLink,
                urlProtocol: .https,
                sshKey: "",
                isTokenValid: true
            )
        )

        keychain.set(personalAccessToken, forKey: "github_\(username)_enterprise")
        dismiss()
    }

    private func handleGitRequestFailed(_ error: Error) {
        print("git auth failure: \(error)")
        // Show alert if error encountered while requesting signin
        switch error._code {
        case -1009:
            signinErrorDetail = error.localizedDescription
        case 401:
            signinErrorDetail = String(localized: "settings.accounts.signin.error.authentication-failed", defaultValue: "Authentication Failed", comment: "Error message for failed authentication")
        case 403:
            signinErrorDetail = String(localized: "settings.accounts.signin.error.api-access-forbidden", defaultValue: "API Access Forbidden", comment: "Error message for forbidden API access")
        default:
            signinErrorDetail = String(localized: "settings.accounts.signin.error.unknown", defaultValue: "Unknown Error", comment: "Fallback error message for unknown sign-in failures")
        }
        signinErrorAlertIsPresented.toggle()
    }
}
