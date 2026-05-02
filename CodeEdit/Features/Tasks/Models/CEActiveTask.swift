//
//  CEActiveTask.swift
//  CodeEditTests
//
//  Created by Tommy Ludwig on 24.06.24.
//

import SwiftUI
import Combine
import SwiftTerm

/// Stores the state of a task once it's executed
class CEActiveTask: ObservableObject, Identifiable, Hashable {
    /// The current progress of the task.
    @Published var output: CEActiveTaskTerminalView?

    var hasOutputBeenConfigured: Bool = false

    /// The status of the task.
    @Published private(set) var status: CETaskStatus = .notRunning

    /// The name of the associated task.
    @ObservedObject var task: CETask

    /// Prevents tasks overwriting each other.
    /// Say a user cancels one task, then runs it immediately, the cancel message should show and then the
    /// starting message should show. If we don't add this modifier the starting message will be deleted.
    var activeTaskID: UUID = UUID()

    var taskId: String {
        task.id.uuidString + "-" + activeTaskID.uuidString
    }

    var workspaceURL: URL?

    private var cancellables = Set<AnyCancellable>()

    init(task: CETask) {
        self.task = task

        self.task.objectWillChange.sink { _ in
            self.objectWillChange.send()
        }.store(in: &cancellables)
    }

    @MainActor
    func run(workspaceURL: URL?, shell: Shell? = nil) {
        self.workspaceURL = workspaceURL
        self.activeTaskID = UUID() // generate a new ID for this run

        createStatusTaskNotification()
        updateTaskStatus(to: .running)

        let view = output ?? CEActiveTaskTerminalView(activeTask: self)
        view.startProcess(workspaceURL: workspaceURL, shell: shell)

        output = view
    }

    @MainActor
    func handleProcessFinished(terminationStatus: Int32) {
        // Shells add 128 to non-zero exit codes.
        var terminationStatus = terminationStatus
        if terminationStatus > 128 {
            terminationStatus -= 128
        }

        switch terminationStatus {
        case 0:
            output?.newline()
            output?.sendOutputMessage(String(format: String(localized: "tasks.output.finished-running", defaultValue: "Finished running %@.", comment: "Message when task finishes successfully"), task.name))
            output?.newline()

            updateTaskStatus(to: .finished)
            updateTaskNotification(
                title: String(format: String(localized: "tasks.notification.finished-running", defaultValue: "Finished Running %@", comment: "Notification title when task finishes"), task.name),
                message: "",
                isLoading: false
            )
        case 2, 15: // SIGINT or SIGTERM
            output?.newline()
            output?.sendOutputMessage(String(format: String(localized: "tasks.output.cancelled", defaultValue: "%@ cancelled.", comment: "Message when task is cancelled"), task.name))
            output?.newline()

            updateTaskStatus(to: .notRunning)
            updateTaskNotification(
                title: String(format: String(localized: "tasks.notification.cancelled", defaultValue: "%@ cancelled", comment: "Notification title when task is cancelled"), task.name),
                message: "",
                isLoading: false
            )
        case 17: // SIGSTOP
            updateTaskStatus(to: .stopped)
        default:
            output?.newline()
            output?.sendOutputMessage(String(format: String(localized: "tasks.output.failed", defaultValue: "Failed to run %@", comment: "Message when task fails"), task.name))
            output?.newline()

            updateTaskStatus(to: .failed)
            updateTaskNotification(
                title: String(format: String(localized: "tasks.notification.failed-running", defaultValue: "Failed Running %@", comment: "Notification title when task fails"), task.name),
                message: "",
                isLoading: false
            )
        }

        deleteStatusTaskNotification()
    }

    @MainActor
    func suspend() {
        if let shellPID = output?.runningPID(), status == .running {
            kill(shellPID, SIGSTOP)
            updateTaskStatus(to: .stopped)
        }
    }

    @MainActor
    func resume() {
        if let shellPID = output?.runningPID(), status == .running {
            kill(shellPID, SIGCONT)
            updateTaskStatus(to: .running)
        }
    }

    func terminate() {
        if let shellPID = output?.runningPID() {
            kill(shellPID, SIGTERM)
        }
    }

    func interrupt() {
        if let shellPID = output?.runningPID() {
            kill(shellPID, SIGINT)
        }
    }

    func waitForExit() {
        if let shellPID = output?.runningPID() {
            waitid(P_PGID, UInt32(shellPID), nil, 0)
        }
    }

    @MainActor
    func clearOutput() {
        output?.terminal.resetToInitialState()
        output?.feed(text: "")
    }

    private func createStatusTaskNotification() {
        let userInfo: [String: Any] = [
            String(localized: "tasks.notification.key.id", defaultValue: "id", comment: "Notification key for task ID"): taskId,
            String(localized: "tasks.notification.key.action", defaultValue: "action", comment: "Notification key for action"): String(localized: "tasks.notification.action.create-priority", defaultValue: "createWithPriority", comment: "Action to create notification with priority"),
            String(localized: "tasks.notification.key.title", defaultValue: "title", comment: "Notification key for title"): String(format: String(localized: "tasks.notification.running", defaultValue: "Running %@", comment: "Notification title when task is running"), self.task.name),
            String(localized: "tasks.notification.key.message", defaultValue: "message", comment: "Notification key for message"): String(format: String(localized: "tasks.notification.running-message", defaultValue: "Running your task: %@.", comment: "Notification message when task is running"), self.task.name),
            String(localized: "tasks.notification.key.is-loading", defaultValue: "isLoading", comment: "Notification key for loading state"): true,
            String(localized: "tasks.notification.key.workspace", defaultValue: "workspace", comment: "Notification key for workspace"): workspaceURL as Any
        ]

        NotificationCenter.default.post(name: .taskNotification, object: nil, userInfo: userInfo)
    }

    private func deleteStatusTaskNotification() {
        let deleteInfo: [String: Any] = [
            String(localized: "tasks.notification.key.id", defaultValue: "id", comment: "Notification key for task ID"): taskId,
            String(localized: "tasks.notification.key.action", defaultValue: "action", comment: "Notification key for action"): String(localized: "tasks.notification.action.delete-delay", defaultValue: "deleteWithDelay", comment: "Action to delete notification with delay"),
            String(localized: "tasks.notification.key.delay", defaultValue: "delay", comment: "Notification key for delay"): 3.0,
            String(localized: "tasks.notification.key.workspace", defaultValue: "workspace", comment: "Notification key for workspace"): workspaceURL as Any
        ]

        NotificationCenter.default.post(name: .taskNotification, object: nil, userInfo: deleteInfo)
    }

    private func updateTaskNotification(title: String? = nil, message: String? = nil, isLoading: Bool? = nil) {
        var userInfo: [String: Any] = [
            String(localized: "tasks.notification.key.id", defaultValue: "id", comment: "Notification key for task ID"): taskId,
            String(localized: "tasks.notification.key.action", defaultValue: "action", comment: "Notification key for action"): String(localized: "tasks.notification.action.update", defaultValue: "update", comment: "Action to update notification"),
            String(localized: "tasks.notification.key.workspace", defaultValue: "workspace", comment: "Notification key for workspace"): workspaceURL as Any
        ]
        if let title {
            userInfo[String(localized: "tasks.notification.key.title", defaultValue: "title", comment: "Notification key for title")] = title
        }
        if let message {
            userInfo[String(localized: "tasks.notification.key.message", defaultValue: "message", comment: "Notification key for message")] = message
        }
        if let isLoading {
            userInfo[String(localized: "tasks.notification.key.is-loading", defaultValue: "isLoading", comment: "Notification key for loading state")] = isLoading
        }

        NotificationCenter.default.post(name: .taskNotification, object: nil, userInfo: userInfo)
    }

    @MainActor
    func updateTaskStatus(to taskStatus: CETaskStatus) {
        self.status = taskStatus
    }

    static func == (lhs: CEActiveTask, rhs: CEActiveTask) -> Bool {
        return lhs.output == rhs.output &&
        lhs.status == rhs.status &&
        lhs.output?.process.shellPid == rhs.output?.process.shellPid &&
        lhs.task == rhs.task
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(output)
        hasher.combine(status)
        hasher.combine(task)
    }
}
