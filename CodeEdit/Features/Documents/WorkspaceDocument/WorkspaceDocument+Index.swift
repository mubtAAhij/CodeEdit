//
//  WorkspaceDocument+Index.swift
//  CodeEdit
//
//  Created by Tommy Ludwig on 02.01.24.
//

import Foundation

extension WorkspaceDocument.SearchState {
    /// Adds the contents of the current workspace URL to the search index.
    /// That means that the contents of the workspace will be indexed and searchable.
    func addProjectToIndex() {
        guard let indexer = indexer else { return }
        guard let url = workspace.fileURL else { return }

        indexStatus = .indexing(progress: 0.0)
        let uuidString = UUID().uuidString
        let createInfo: [String: Any] = [
            String(localized: "task.notification.key.id", defaultValue: "id", comment: "Notification key for task id"): uuidString,
            String(localized: "task.notification.key.action", defaultValue: "action", comment: "Notification key for task action"): String(localized: "task.notification.action.create", defaultValue: "create", comment: "Action to create notification"),
            String(localized: "task.notification.key.title", defaultValue: "title", comment: "Notification key for task title"): String(localized: "indexing.task.title.processing", defaultValue: "Indexing | Processing files", comment: "Title for indexing task when processing files"),
            String(localized: "task.notification.key.message", defaultValue: "message", comment: "Notification key for task message"): String(localized: "indexing.task.message.creating", defaultValue: "Creating an index to enable fast and accurate searches within your codebase.", comment: "Message explaining index creation purpose"),
            String(localized: "task.notification.key.isloading", defaultValue: "isLoading", comment: "Notification key for task loading state"): true
        ]
        NotificationCenter.default.post(name: .taskNotification, object: nil, userInfo: createInfo)

        Task.detached {
            let filePaths = self.getFileURLs(at: url)

            let asyncController = SearchIndexer.AsyncManager(index: indexer)
            var lastProgress: Double = 0

            for await (file, index) in AsyncFileIterator(fileURLs: filePaths) {
                _ = await asyncController.addText(files: [file], flushWhenComplete: false)
                let progress = Double(index) / Double(filePaths.count)

                // Send only if difference is > 0.5%, to keep updates from sending too frequently
                if progress - lastProgress > 0.005 || index == filePaths.count - 1 {
                    lastProgress = progress
                    await MainActor.run {
                        self.indexStatus = .indexing(progress: progress)
                    }
                    let updateInfo: [String: Any] = [
                        String(localized: "task.notification.key.id", defaultValue: "id", comment: "Notification key for task id"): uuidString,
                        String(localized: "task.notification.key.action", defaultValue: "action", comment: "Notification key for task action"): String(localized: "task.notification.action.update", defaultValue: "update", comment: "Action to update notification"),
                        String(localized: "task.notification.key.percentage", defaultValue: "percentage", comment: "Notification key for task percentage"): progress
                    ]
                    NotificationCenter.default.post(name: .taskNotification, object: nil, userInfo: updateInfo)
                }
            }
            asyncController.index.flush()

            await MainActor.run {
                self.indexStatus = .done
            }
            let updateInfo: [String: Any] = [
                String(localized: "task.notification.key.id", defaultValue: "id", comment: "Notification key for task id"): uuidString,
                String(localized: "task.notification.key.action", defaultValue: "action", comment: "Notification key for task action"): String(localized: "task.notification.action.update", defaultValue: "update", comment: "Action to update notification"),
                String(localized: "task.notification.key.title", defaultValue: "title", comment: "Notification key for task title"): String(localized: "indexing.task.title.finished", defaultValue: "Finished indexing", comment: "Title for indexing task when finished"),
                String(localized: "task.notification.key.isloading", defaultValue: "isLoading", comment: "Notification key for task loading state"): false
            ]
            NotificationCenter.default.post(name: .taskNotification, object: nil, userInfo: updateInfo)

            let deleteInfo = [
                String(localized: "task.notification.key.id", defaultValue: "id", comment: "Notification key for task id"): uuidString,
                String(localized: "task.notification.key.action", defaultValue: "action", comment: "Notification key for task action"): String(localized: "task.notification.action.delete.with.delay", defaultValue: "deleteWithDelay", comment: "Action to delete notification with delay"),
                String(localized: "task.notification.key.delay", defaultValue: "delay", comment: "Notification key for task delay"): 4.0
            ]
            NotificationCenter.default.post(name: .taskNotification, object: nil, userInfo: deleteInfo)
        }
    }

    /// Retrieves an array of file URLs within the specified directory URL.
    ///
    /// - Parameter url: The URL of the directory to search for files.
    ///
    /// - Returns: An array of file URLs found within the specified directory.
    func getFileURLs(at url: URL) -> [URL] {
        let enumerator = FileManager.default.enumerator(
            at: url,
            includingPropertiesForKeys: [.isRegularFileKey],
            options: [.skipsHiddenFiles, .skipsPackageDescendants]
        )
        return enumerator?.allObjects as? [URL] ?? []
    }

    /// Retrieves the contents of a files  from the specified file paths.
    ///
    /// - Parameter filePaths: An array of file URLs representing the paths of the files.
    ///
    /// - Returns: An array of `TextFile` objects containing the standardised file URLs and text content.
    func getFileContent(from filePaths: [URL]) async -> [SearchIndexer.AsyncManager.TextFile] {
        var textFiles = [SearchIndexer.AsyncManager.TextFile]()
        for file in filePaths {
            if let content = try? String(contentsOf: file) {
                textFiles.append(
                    SearchIndexer.AsyncManager.TextFile(url: file.standardizedFileURL, text: content)
                )
            }
        }
        return textFiles
    }
}
