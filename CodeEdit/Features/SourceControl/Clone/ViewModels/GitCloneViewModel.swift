//
//  GitCloneViewModel.swift
//  CodeEdit
//
//  Created by Albert Vinizhanau on 10/17/23.
//

import Foundation
import AppKit

class GitCloneViewModel: ObservableObject {
    @Published var repoUrlStr = ""
    @Published var isCloning: Bool = false
    @Published var cloningProgress: GitClient.CloneProgress = .init(progress: 0, state: .initialState)

    var gitClient: GitClient?
    var cloningTask: Task<Void, Error>?

    /// Check if url is valid
    /// - Parameter url: Url to check
    /// - Returns: True if url is valid
    func isValidUrl(url: String) -> Bool {
        // Doing the same kind of check that Xcode does when cloning
        let url = url.lowercased()
        if url.starts(with: String(localized: "git_clone.url_scheme.http", defaultValue: "http://", comment: "HTTP URL scheme prefix")) && url.count > 7 {
            return true
        } else if url.starts(with: String(localized: "git_clone.url_scheme.https", defaultValue: "https://", comment: "HTTPS URL scheme prefix")) && url.count > 8 {
            return true
        } else if url.starts(with: String(localized: "git_clone.url_scheme.git", defaultValue: "git@", comment: "Git SSH URL scheme prefix")) && url.count > 4 {
            return true
        }
        return false
    }
    /// Check if Git is installed
    /// - Returns: True if Git is found by running "which git" command
    func isGitInstalled() -> Bool {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: String(localized: "git_clone.which_command_path", defaultValue: "/usr/bin/which", comment: "Path to which command"))
        process.arguments = [String(localized: "git_clone.git_command", defaultValue: "git", comment: "Git command name")]
        let pipe = Pipe()
        process.standardOutput = pipe
        do {
            try process.run()
            process.waitUntilExit()
            return process.terminationStatus == 0
        } catch {
            return false
        }
    }

    /// Check if clipboard contains git url
    func checkClipboard() {
        if let url = NSPasteboard.general.pasteboardItems?.first?.string(forType: .string) {
            if isValidUrl(url: url) {
                self.repoUrlStr = url
            }
        }
    }

    /// Clone repository
    func cloneRepository(completionHandler: @escaping (URL) -> Void) {
        if !isGitInstalled() {
            showAlert(
                alertMsg: String(localized: "git_clone.error.git_not_found", defaultValue: "Git installation not found.", comment: "Error message when Git is not installed"),
                infoText: String(localized: "git_clone.error.git_not_found_info", defaultValue: "Ensure Git is installed on your system and try again.", comment: "Information text for Git not found error")
            )
            return
        }
        if repoUrlStr == "" {
            showAlert(
                alertMsg: String(localized: "git_clone.error.url_empty", defaultValue: "Url cannot be empty", comment: "Error message when URL is empty"),
                infoText: String(localized: "git_clone.error.url_empty_info", defaultValue: "You must specify a repository to clone", comment: "Information text for empty URL error")
            )
            return
        }

        // Parsing repo name
        guard let remoteUrl = URL(string: repoUrlStr) else {
            return
        }

        var repoName = remoteUrl.lastPathComponent

        // Strip .git from name if it has it.
        // Cloning repository without .git also works
        if repoName.contains(String(localized: "git_clone.git_extension", defaultValue: ".git", comment: "Git repository extension")) {
            repoName.removeLast(4)
        }

        guard let localPath = getPath(saveName: repoName) else {
            return
        }

        var isDir: ObjCBool = true
        if FileManager.default.fileExists(atPath: localPath.relativePath, isDirectory: &isDir) {
            showAlert(alertMsg: String(localized: "git_clone.error.title", defaultValue: "Error", comment: "Generic error title"), infoText: String(localized: "git_clone.error.directory_exists", defaultValue: "Directory already exists", comment: "Error message when directory already exists"))
            return
        }

        do {
            try FileManager.default.createDirectory(
                atPath: localPath.relativePath,
                withIntermediateDirectories: true,
                attributes: nil
            )
        } catch {
            showAlert(alertMsg: String(localized: "git_clone.error.create_folder", defaultValue: "Failed to create folder", comment: "Error message when folder creation fails"), infoText: String(format: String(localized: "git_clone.error.error_details", defaultValue: "%@", comment: "Error details format"), error.localizedDescription))
            return
        }

        gitClient = GitClient(directoryURL: localPath, shellClient: .live())

        self.cloningTask = Task(priority: .background) {
            await processCloning(
                remoteUrl: remoteUrl,
                localPath: localPath,
                completionHandler: completionHandler
            )
        }
    }

    /// Process cloning
    /// - Parameters:
    ///   - remoteUrl: Path to remote repository
    ///   - localPath: Path to local folder
    ///   - completionHandler: Completion handler if cloning is successful
    private func processCloning(
        remoteUrl: URL,
        localPath: URL,
        completionHandler: @escaping (URL) -> Void
    ) async {
        guard let gitClient else { return }

        await setIsCloning(true)

        do {
            for try await progress in gitClient.cloneRepository(remoteUrl: remoteUrl, localPath: localPath) {
                await MainActor.run {
                    self.cloningProgress = progress
                }
            }

            if Task.isCancelled {
                await MainActor.run {
                    deleteTemporaryFolder(localPath: localPath)
                }
                return
            }

            completionHandler(localPath)
        } catch {
            await MainActor.run {
                if let error = error as? GitClient.GitClientError {
                    showAlert(alertMsg: String(localized: "git_clone.error.failed_to_clone", defaultValue: "Failed to clone", comment: "Error message when cloning fails"), infoText: error.description)
                } else {
                    showAlert(alertMsg: String(localized: "git_clone.error.failed_to_clone", defaultValue: "Failed to clone", comment: "Error message when cloning fails"), infoText: error.localizedDescription)
                }
                deleteTemporaryFolder(localPath: localPath)
            }
        }

        await setIsCloning(false)
    }

    private func deleteTemporaryFolder(localPath: URL) {
        do {
            try FileManager.default.removeItem(atPath: localPath.relativePath)
        } catch {
            showAlert(alertMsg: String(localized: "git_clone.error.failed_to_delete_folder", defaultValue: "Failed to delete folder", comment: "Error message when folder deletion fails"), infoText: String(format: String(localized: "git_clone.error.error_details", defaultValue: "%@", comment: "Error details format"), String(describing: error)))
            return
        }
    }

    @MainActor
    private func setIsCloning(_ newValue: Bool) {
        self.isCloning = newValue
    }

    private func getPath(saveName: String) -> URL? {
        let dialog = NSSavePanel()
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.showsTagField = false
        dialog.prompt = String(localized: "git_clone.dialog.prompt", defaultValue: "Clone", comment: "Clone button text in save panel")
        dialog.nameFieldStringValue = saveName
        dialog.nameFieldLabel = String(localized: "git_clone.dialog.name_field_label", defaultValue: "Clone as", comment: "Label for clone destination name field")
        dialog.title = String(localized: "git_clone.dialog.title", defaultValue: "Clone a Repository", comment: "Title for clone repository dialog")

        guard dialog.runModal() == NSApplication.ModalResponse.OK,
              let result = dialog.url else {
            return nil
        }

        return result
    }

    private func showAlert(alertMsg: String, infoText: String) {
        let alert = NSAlert()
        alert.messageText = alertMsg
        alert.informativeText = infoText
        alert.addButton(withTitle: String(localized: "git_clone.alert.ok", defaultValue: "OK", comment: "OK button text in alert dialog"))
        alert.alertStyle = .warning
        alert.runModal()
    }
}
