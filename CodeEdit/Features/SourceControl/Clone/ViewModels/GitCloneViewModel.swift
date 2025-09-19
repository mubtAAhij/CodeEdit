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
        if url.starts(with: "http://") && url.count > 7 {
            return true
        } else if url.starts(with: "https://") && url.count > 8 {
            return true
        } else if url.starts(with: "git@") && url.count > 4 {
            return true
        }
        return false
    }
    /// Check if Git is installed
    /// - Returns: True if Git is found by running "which git" command
    func isGitInstalled() -> Bool {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/which")
        process.arguments = ["git"]
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
                alertMsg: String(localized: "git_installation_not_found", comment: "Error message when Git is not installed"),
                infoText: String(localized: "ensure_git_installed", comment: "Error message detail for Git installation")
            )
            return
        }
        if repoUrlStr == "" {
            showAlert(
                alertMsg: String(localized: "url_cannot_be_empty", comment: "Error message when URL field is empty"),
                infoText: String(localized: "repository_clone_required", comment: "Error message when no repository URL is specified for cloning")
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
        if repoName.contains(".git") {
            repoName.removeLast(4)
        }

        guard let localPath = getPath(saveName: repoName) else {
            return
        }

        var isDir: ObjCBool = true
        if FileManager.default.fileExists(atPath: localPath.relativePath, isDirectory: &isDir) {
            showAlert(alertMsg: String(localized: "error", comment: "Generic error alert title"), infoText: String(localized: "directory_already_exists", comment: "Error message when trying to clone to an existing directory"))
            return
        }

        do {
            try FileManager.default.createDirectory(
                atPath: localPath.relativePath,
                withIntermediateDirectories: true,
                attributes: nil
            )
        } catch {
            showAlert(alertMsg: String(localized: "failed_create_folder", comment: "Error message when folder creation fails during clone"), infoText: "\(error)")
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
                    showAlert(alertMsg: String(localized: "failed_to_clone", comment: "Error message when git clone operation fails"), infoText: error.description)
                } else {
                    showAlert(alertMsg: String(localized: "failed_to_clone", comment: "Error message when git clone operation fails"), infoText: error.localizedDescription)
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
            showAlert(alertMsg: String(localized: "failed_delete_folder", comment: "Error message when temporary folder deletion fails"), infoText: "\(error)")
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
        dialog.prompt = String(localized: "clone", comment: "Save panel prompt for git clone")
        dialog.nameFieldStringValue = saveName
        dialog.nameFieldLabel = String(localized: "clone_as", comment: "Save panel name field label for git clone")
        dialog.title = String(localized: "clone", comment: "Save panel title for git clone")

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
        alert.addButton(withTitle: String(localized: "ok", comment: "OK button title"))
        alert.alertStyle = .warning
        alert.runModal()
    }
}
