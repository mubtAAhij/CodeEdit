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
        if url.starts(with: String(localized: "git.clone.url.prefix.http", defaultValue: "http://", comment: "HTTP URL prefix for git repository")) && url.count > 7 {
            return true
        } else if url.starts(with: String(localized: "git.clone.url.prefix.https", defaultValue: "https://", comment: "HTTPS URL prefix for git repository")) && url.count > 8 {
            return true
        } else if url.starts(with: String(localized: "git.clone.url.prefix.ssh", defaultValue: "git@", comment: "SSH URL prefix for git repository")) && url.count > 4 {
            return true
        }
        return false
    }
    /// Check if Git is installed
    /// - Returns: True if Git is found by running "which git" command
    func isGitInstalled() -> Bool {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: String(localized: "git.clone.which.command.path", defaultValue: "/usr/bin/which", comment: "Path to which command"))
        process.arguments = [String(localized: "git.clone.git.command.name", defaultValue: "git", comment: "Git command name")]
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
                alertMsg: String(localized: "git.clone.error.git.not.found.title", defaultValue: "Git installation not found.", comment: "Alert title when Git is not installed"),
                infoText: String(localized: "git.clone.error.git.not.found.message", defaultValue: "Ensure Git is installed on your system and try again.", comment: "Alert message when Git is not installed")
            )
            return
        }
        if repoUrlStr == "" {
            showAlert(
                alertMsg: String(localized: "git.clone.error.empty.url.title", defaultValue: "Url cannot be empty", comment: "Alert title when URL is empty"),
                infoText: String(localized: "git.clone.error.empty.url.message", defaultValue: "You must specify a repository to clone", comment: "Alert message when URL is empty")
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
        if repoName.contains(String(localized: "git.clone.git.extension", defaultValue: ".git", comment: "Git repository extension")) {
            repoName.removeLast(4)
        }

        guard let localPath = getPath(saveName: repoName) else {
            return
        }

        var isDir: ObjCBool = true
        if FileManager.default.fileExists(atPath: localPath.relativePath, isDirectory: &isDir) {
            showAlert(alertMsg: String(localized: "git.clone.error.title", defaultValue: "Error", comment: "Generic error alert title"), infoText: String(localized: "git.clone.error.directory.exists", defaultValue: "Directory already exists", comment: "Alert message when directory already exists"))
            return
        }

        do {
            try FileManager.default.createDirectory(
                atPath: localPath.relativePath,
                withIntermediateDirectories: true,
                attributes: nil
            )
        } catch {
            showAlert(alertMsg: String(localized: "git.clone.error.create.folder.title", defaultValue: "Failed to create folder", comment: "Alert title when folder creation fails"), infoText: String(format: String(localized: "git.clone.error.create.folder.message", defaultValue: "%@", comment: "Alert message with error details"), String(describing: error)))
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
                    showAlert(alertMsg: String(localized: "git.clone.error.clone.failed.title", defaultValue: "Failed to clone", comment: "Alert title when cloning fails"), infoText: error.description)
                } else {
                    showAlert(alertMsg: String(localized: "git.clone.error.clone.failed.title", defaultValue: "Failed to clone", comment: "Alert title when cloning fails"), infoText: error.localizedDescription)
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
            showAlert(alertMsg: String(localized: "git.clone.error.delete.folder.title", defaultValue: "Failed to delete folder", comment: "Alert title when folder deletion fails"), infoText: String(format: String(localized: "git.clone.error.delete.folder.message", defaultValue: "%@", comment: "Alert message with error details"), String(describing: error)))
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
        dialog.prompt = String(localized: "git.clone.dialog.prompt", defaultValue: "Clone", comment: "Save panel prompt for cloning repository")
        dialog.nameFieldStringValue = saveName
        dialog.nameFieldLabel = String(localized: "git.clone.dialog.name.label", defaultValue: "Clone as", comment: "Save panel name field label")
        dialog.title = String(localized: "git.clone.dialog.title", defaultValue: "Clone a Repository", comment: "Save panel title for cloning repository")

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
        alert.addButton(withTitle: String(localized: "git.clone.alert.ok.button", defaultValue: "OK", comment: "OK button for alert"))
        alert.alertStyle = .warning
        alert.runModal()
    }
}
