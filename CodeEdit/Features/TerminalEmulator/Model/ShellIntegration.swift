//
//  ShellIntegration.swift
//  CodeEdit
//
//  Created by Khan Winter on 6/2/24.
//

import Foundation
import os

/// Provides a single function for setting up shell integrations.
/// See ``ShellIntegration/setUpIntegration(for:environment:)``
enum ShellIntegration {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: String(localized: "shell-integration.logger-category", defaultValue: "ShellIntegration", comment: "Logger category for shell integration"))

    /// Variable constants used by setup scripts.
    enum Variables {
        static let shellLogin = String(localized: "shell-integration.var.shell-login", defaultValue: "CE_SHELL_LOGIN", comment: "Environment variable for shell login flag")
        static let ceZDotDir = String(localized: "shell-integration.var.ce-zdotdir", defaultValue: "CE_ZDOTDIR", comment: "Environment variable for CodeEdit zsh directory")
        static let userZDotDir = String(localized: "shell-integration.var.user-zdotdir", defaultValue: "USER_ZDOTDIR", comment: "Environment variable for user zsh directory")
        static let zDotDir = String(localized: "shell-integration.var.zdotdir", defaultValue: "ZDOTDIR", comment: "Environment variable for zsh directory")
        static let ceInjection = String(localized: "shell-integration.var.ce-injection", defaultValue: "CE_INJECTION", comment: "Environment variable for CodeEdit injection flag")
        static let disableHistory = String(localized: "shell-integration.var.disable-history", defaultValue: "CE_DISABLE_HISTORY", comment: "Environment variable for disabling shell history")
    }

    /// Errors for shell integration setup.
    enum Error: Swift.Error, LocalizedError {
        case bashShellFileNotFound
        case zshShellFileNotFound

        var localizedDescription: String {
            switch self {
            case .bashShellFileNotFound:
                return String(localized: "shell-integration.error.bash-file-not-found", defaultValue: "Failed to find bash injection file.", comment: "Error message when bash injection file is not found")
            case .zshShellFileNotFound:
                return String(localized: "shell-integration.error.zsh-file-not-found", defaultValue: "Failed to find zsh injection file.", comment: "Error message when zsh injection file is not found")
            }
        }
    }

    /// Setup shell integration.
    ///
    /// Injects necessary init files for whatever shell is being used for CodeEdit to receive notifications about
    /// running processes for display in the UI.
    /// Any other setup/configuration should also be done here.
    ///
    /// - Parameters:
    ///   - shell: The shell being set up.
    ///   - environment: The existing environment variables. Passed as an `inout` parameter because this function will
    ///                  modify this array.
    ///   - useLogin: Whether or not to use a login shell.
    /// - Returns: An array of args to pass to the shell executable.
    /// - Throws: Errors involving filesystem operations. This function requires copying various files, which can
    ///           throw. Can also throw ``ShellIntegration/Error`` errors if required files are not found in the bundle.
    static func setUpIntegration(
        for shell: Shell,
        environment: inout [String],
        useLogin: Bool,
        interactive: Bool
    ) throws -> [String] {
        do {
            logger.debug("Setting up shell: \(shell.rawValue)")
            var args: [String] = []

            // Enable injection in our scripts.
            environment.append("\(Variables.ceInjection)=1")

            switch shell {
            case .bash:
                try bash(&args)
            case .zsh:
                try zsh(&environment)
            }

            if useLogin {
                environment.append("\(Variables.shellLogin)=1")
            }

            if let execArgs = shell.execArguments(interactive: interactive, login: useLogin) {
                args.append(execArgs)
            }

            return args
        } catch {
            // catch so we can log this here
            logger.error("Failed to setup shell integration: \(error.localizedDescription)")
            throw error
        }
    }

    // MARK: - Shell Specific Setup

    /// Sets up the `bash` shell integration.
    ///
    /// Sets the bash `--init-file` option to point to CE's shell integration script. This script will source the
    /// user's "real" init file and then install our required functions.
    /// Also sets the `-i` option to initialize an interactive session if `interactive` is true.
    ///
    /// - Parameters:
    ///   - args: The args to use for shell exec, will be modified by this function.
    ///   - interactive: Set to true to use an interactive shell.
    private static func bash(_ args: inout [String]) throws {
        // Inject our own bash script that will execute the user's init files, then install our pre/post exec functions.
        guard let scriptURL = Bundle.main.url(
            forResource: String(localized: "shell-integration.bash.resource-name", defaultValue: "codeedit_shell_integration", comment: "Resource name for bash shell integration script"),
            withExtension: String(localized: "shell-integration.bash.extension", defaultValue: "bash", comment: "File extension for bash script")
        ) else {
            throw Error.bashShellFileNotFound
        }
        args.append(contentsOf: [String(localized: "shell-integration.bash.init-file-flag", defaultValue: "--init-file", comment: "Bash flag for init file"), scriptURL.path()])
    }

    /// Sets up the `zsh` shell integration.
    ///
    /// Sets the zsh init directory to a temporary directory containing CE setup scripts. Each script corresponds to an
    /// available zsh init script, and will source the user's real init script. To inject our `preexec/precmd` functions
    /// we first source the user's zsh init files, then install our functions. Transparently installing our functions
    /// and still using the user's init files w/o modifying anyone's rc files.
    /// Also sets up an interactive session using the `-i` parameter.
    ///
    /// - Parameters:
    ///   - shellExecArgs: The args to use for shell exec, will be modified by this function.
    ///   - environment: Environment variables in an array. Formatted as `EnvVar=Value`. Will be modified by this
    ///                  function.
    ///   - useLogin: Whether to use a login shell.
    ///   - interactive: Whether to use an interactive shell.
    private static func zsh(
        _ environment: inout [String]
    ) throws {
        // All injection script URLs
        guard let profileScriptURL = Bundle.main.url(
            forResource: String(localized: "shell-integration.zsh.resource-profile", defaultValue: "codeedit_shell_integration_profile", comment: "Resource name for zsh profile script"),
            withExtension: String(localized: "shell-integration.zsh.extension", defaultValue: "zsh", comment: "File extension for zsh script")
        ), let envScriptURL = Bundle.main.url(
            forResource: String(localized: "shell-integration.zsh.resource-env", defaultValue: "codeedit_shell_integration_env", comment: "Resource name for zsh environment script"),
            withExtension: String(localized: "shell-integration.zsh.extension", defaultValue: "zsh", comment: "File extension for zsh script")
        ), let loginScriptURL = Bundle.main.url(
            forResource: String(localized: "shell-integration.zsh.resource-login", defaultValue: "codeedit_shell_integration_login", comment: "Resource name for zsh login script"),
            withExtension: String(localized: "shell-integration.zsh.extension", defaultValue: "zsh", comment: "File extension for zsh script")
        ), let rcScriptURL = Bundle.main.url(
            forResource: String(localized: "shell-integration.zsh.resource-rc", defaultValue: "codeedit_shell_integration_rc", comment: "Resource name for zsh rc script"),
            withExtension: String(localized: "shell-integration.zsh.extension", defaultValue: "zsh", comment: "File extension for zsh script")
        ) else {
            throw Error.zshShellFileNotFound
        }

        // Make the current user here to avoid a duplicate fetch.
        let currentUser = CurrentUser.getCurrentUser()
        let tempDir = try makeTempDir(forShell: .zsh, user: currentUser)

        // Save any existing home dir. First getting a value from the environment.
        // Falling back to the user's home dir, then ~
        let envZDotDir = environment.first(where: { $0.starts(with: String(localized: "shell-integration.zsh.zdotdir-prefix", defaultValue: "ZDOTDIR=", comment: "Environment variable prefix for ZDOTDIR")) })?.trimmingPrefix(String(localized: "shell-integration.zsh.zdotdir-prefix", defaultValue: "ZDOTDIR=", comment: "Environment variable prefix for ZDOTDIR"))
        let userZDotDir = (envZDotDir?.isEmpty ?? true) ? currentUser?.homeDir ?? String(localized: "shell-integration.zsh.home-fallback", defaultValue: "~", comment: "Fallback home directory path") : String(envZDotDir ?? "")

        environment.append("\(Variables.zDotDir)=\(tempDir.path())")
        environment.append("\(Variables.userZDotDir)=\(userZDotDir)")

        // Move all shell files to new temp dir
        try copyFile(profileScriptURL, toDir: tempDir.appending(path: String(localized: "shell-integration.zsh.file.zprofile", defaultValue: ".zprofile", comment: "Zsh profile filename")))
        try copyFile(envScriptURL, toDir: tempDir.appending(path: String(localized: "shell-integration.zsh.file.zshenv", defaultValue: ".zshenv", comment: "Zsh environment filename")))
        try copyFile(loginScriptURL, toDir: tempDir.appending(path: String(localized: "shell-integration.zsh.file.zlogin", defaultValue: ".zlogin", comment: "Zsh login filename")))
        try copyFile(rcScriptURL, toDir: tempDir.appending(path: String(localized: "shell-integration.zsh.file.zshrc", defaultValue: ".zshrc", comment: "Zsh rc filename")))
    }

    /// Helper function for safely copying files, removing existing ones if needed.
    /// - Parameters:
    ///   - origin: The path of the file to copy from
    ///   - destination: The destination URL to copy the file to.
    /// - Throws: Errors from `FileManager` operations.
    private static func copyFile(_ origin: URL, toDir destination: URL) throws {
        if FileManager.default.fileExists(atPath: destination.path()) {
            try FileManager.default.removeItem(at: destination)
        }
        try FileManager.default.copyItem(at: origin, to: destination)
    }

    /// Creates a temporary directory for a user/shell combination.
    /// - Parameters:
    ///   - shell: The shell to create the directory for.
    ///   - user: The current user, will attempt to get the current user if none are supplied.
    /// - Returns: The URL of the temporary directory.
    /// - Throws: Errors from `FileManager` operations.
    private static func makeTempDir(forShell shell: Shell, user: CurrentUser? = .getCurrentUser()) throws -> URL {
        let username = user?.name ?? String(localized: "shell-integration.temp-dir.unknown-user", defaultValue: "unknown", comment: "Fallback username for temp directory") // doesn't really matter but this is used later so might as well

        // Create a temp directory to store our init files in.
        // The name of the directory is user-specific and shell-specific to avoid overlap.
        let tempDir = FileManager.default.temporaryDirectory.appending(
            path: "\(username)-codeedit-\(shell.rawValue)"
        )
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        return tempDir
    }
}
