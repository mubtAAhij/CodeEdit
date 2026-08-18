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
                                Text(String(
                                    localized: "settings.accounts.signin.server",
                                    defaultValue: "Server",
                                    comment: "Label for account server field"
                                ))
                                    .font(.caption3)
                                    .foregroundColor(.secondary)
                                TextField("", text: $server, prompt: Text("https://git.example.com"))
                                    .labelsHidden()
                            }
                        }
                        VStack(alignment: .leading, spacing: 5) {
                            Text(String(
                                localized: "settings.accounts.signin.username",
                                defaultValue: "Username",
                                comment: "Label for account username field"
                            ))
                                .font(.caption3)
                                .foregroundColor(.secondary)
                            TextField("", text: $username)
                                .labelsHidden()
                        }
                        VStack(alignment: .leading, spacing: 5) {
                            Text(String(
                                localized: "settings.accounts.signin.personal-access-token",
                                defaultValue: "Personal Access Token",
                                comment: "Label for personal access token field"
                            ))
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
                            Text(String(format: String(
                                localized: "settings.accounts.signin.sign-in-to-provider",
                                defaultValue: "Sign in to %@",
                                comment: "Title text for signing in to selected provider"
                            ), "\(provider.name)"))
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                    },
                    footer: {
                        VStack(alignment: .leading, spacing: 5) {
                            if provider == .github {
                                Text(String(format: String(
                                    localized: "settings.accounts.signin.required-scopes",
                                    defaultValue: "%@ personal access tokens must have these scopes set:",
                                    comment: "Instruction text before listing required token scopes"
                                ), "\(provider.name)"))
                                    .font(.system(size: 10.5))
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)
                                HStack(alignment: .center) {
                                    Spacer()
                                    VStack(alignment: .leading) {
                                        HStack(spacing: 2.5) {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 10.5, weight: .semibold))
                                            Text("admin:public _key")
                                                .font(.system(size: 10.5))
                                        }
                                        HStack(spacing: 2.5) {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 10.5, weight: .semibold))
                                            Text("write:discussion")
                                                .font(.system(size: 10.5))
                                        }
                                        HStack(spacing: 2.5) {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 10.5, weight: .semibold))
                                            Text("repo")
                                                .font(.system(size: 10.5))
                                        }
                                        HStack(spacing: 2.5) {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 10.5, weight: .semibold))
                                            Text("user")
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
                                    Text(String(format: String(
                                        localized: "settings.accounts.signin.create-password-on-provider",
                                        defaultValue: "Create a Password on %@",
                                        comment: "Action label to open provider page for creating password"
                                    ), "\(provider.name)"))
                                        .font(.system(size: 10.5))
                                } else {
                                    Text(String(format: String(
                                        localized: "settings.accounts.signin.create-token-on-provider",
                                        defaultValue: "Create a Token on %@",
                                        comment: "Action label to open provider page for creating access token"
                                    ), "\(provider.name)"))
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
                    Text(String(
                        localized: "settings.accounts.signin.cancel",
                        defaultValue: "Cancel",
                        comment: "Cancel button title for account sign-in sheet"
                    ))
                        .frame(maxWidth: .infinity)
                }
                .controlSize(.large)
                .frame(maxWidth: .infinity)

                Button {
                    signin()
                } label: {
                    Text(String(
                        localized: "settings.accounts.signin.sign-in",
                        defaultValue: "Sign In",
                        comment: "Primary action button title for account sign-in"
                    ))
                        .frame(maxWidth: .infinity)
                }
                .disabled(username.isEmpty || personalAccessToken.isEmpty)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .alert(
                    Text(String(format: String(
                        localized: "settings.accounts.signin.unable-to-add-account",
                        defaultValue: "Unable to add account “%@”",
                        comment: "Error alert title when adding account fails for username"
                    ), "\(username)")),
                    isPresented: $signinErrorAlertIsPresented
                ) {
                    Button(String(
                        localized: "settings.accounts.signin.ok",
                        defaultValue: "OK",
                        comment: "Confirmation button title for account sign-in alerts"
                    )) {
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
            signinErrorDetail = String(
                localized: "settings.accounts.signin.account-already-exists",
                defaultValue: "Account with the same username and provider already exists!",
                comment: "Validation error when duplicate account exists"
            )
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
            signinErrorDetail = String(
                localized: "settings.accounts.signin.error.authentication-failed",
                defaultValue: "Authentication Failed",
                comment: "Error title for authentication failure"
            )
        case 403:
            signinErrorDetail = String(
                localized: "settings.accounts.signin.error.api-access-forbidden",
                defaultValue: "API Access Forbidden",
                comment: "Error title for forbidden API access"
            )
        default:
            signinErrorDetail = String(
                localized: "settings.accounts.signin.error.unknown-error",
                defaultValue: "Unknown Error",
                comment: "Fallback error title for unknown sign-in failures"
            )
        }
        signinErrorAlertIsPresented.toggle()
    }
}
