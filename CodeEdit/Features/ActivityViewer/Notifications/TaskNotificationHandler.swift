//
//  TaskNotificationHandler.swift
//  CodeEdit
//
//  Created by Tommy Ludwig on 21.06.24.
//

import Foundation
import Combine

/// Manages task-related notifications.
///
/// This class listens for notifications named `.taskNotification` and performs actions
/// such as creating, updating, or deleting tasks based on the notification's content.
///
/// When a task is created, it is added to the end of the array. The activity viewer displays
/// only the first item in the array. To immediately display a notification, use the 
/// `"action": "createWithPriority"` option to insert the task at the beginning of the array.
/// *Note: This option should be reserved for important notifications only.*
///
/// It is recommended to use `UUID().uuidString` to generate a unique identifier for each task.
/// This identifier can then be used to update or delete the task. Alternatively, you can use any
/// unique identifier, such as a token sent from a language server.
///
/// Remember to manage your task notifications appropriately. You should either delete task 
/// notifications manually or schedule their deletion in advance using the `deleteWithDelay` method.
///
/// Some tasks should be restricted to a specific workspace. To do this, specify the `workspace` attribute in the
/// notification's `userInfo` dictionary as a `URL`, or use the `toWorkspace` parameter on
/// ``TaskNotificationHandler/postTask(toWorkspace:action:model:)``.
///
/// ## Available Methods
/// - `create`:
///     Creates a new Task Notification. 
///     Required fields: `id` (String), `action` (String), `title` (String). 
///     Optional fields: `message` (String), `percentage` (Double), `isLoading` (Bool), `workspace` (URL).
/// - `createWithPriority`:
///     Creates a new Task Notification and inserts it at the start of the array.
///     This ensures it appears in the activity viewer even if there are other task notifications before it.
///     **Note:** This should only be used for important notifications!
///     Required fields: `id` (String), `action` (String), `title` (String). 
///     Optional fields: `message` (String), `percentage` (Double), `isLoading` (Bool), `workspace` (URL).
/// - `update`:
///     Updates an existing task notification. It's important to pass the same `id` to update the correct task.
///     Required fields: `id` (String), `action` (String). 
///     Optional fields: `title` (String), `message` (String), `percentage` (Double), `isLoading` (Bool),
///     `workspace` (URL).
/// - `delete`:
///     Deletes an existing task notification.
///     Required fields: `id` (String), `action` (String).
///     Optional field: `workspace` (URL).
/// - `deleteWithDelay`:
///     Deletes an existing task notification after a certain `TimeInterval`.
///     Required fields: `id` (String), `action` (String), `delay` (Double).
///     Optional field: `workspace` (URL).
///     **Important:** When specifying the delay, ensure it's a double.
///     For example, '2' would be invalid because it would count as an integer, use '2.0' instead.
///
/// ## Example Usage:
/// ```swift
/// let uuidString = UUID().uuidString
///
/// func createTask() {
///     let userInfo: [String: Any] = [
///         "id": "uniqueTaskID",
///         "action": "create",
///         "title": "Task Title"
///     ]
///     NotificationCenter.default.post(name: .taskNotification, object: nil, userInfo: userInfo)
/// }
///
/// func createTaskWithPriority() {
///     let userInfo: [String: Any] = [
///         "id": "uniqueTaskID",
///         "action": "createWithPriority",
///         "title": "Priority Task Title"
///     ]
///     NotificationCenter.default.post(name: .taskNotification, object: nil, userInfo: userInfo)
/// }
///
/// func updateTask() {
///     var userInfo: [String: Any] = [
///         "id": "uniqueTaskID",
///         "action": "update",
///         "title": "Updated Task Title",
///         "message": "Updated Task Message",
///         "percentage": 0.5,
///         "isLoading": true
///     ]
///     NotificationCenter.default.post(name: .taskNotification, object: nil, userInfo: userInfo)
/// }
///
/// func deleteTask() {
///     let userInfo: [String: Any] = [
///         "id": "uniqueTaskID",
///         "action": "delete"
///     ]
///     NotificationCenter.default.post(name: .taskNotification, object: nil, userInfo: userInfo)
/// }
///
/// func deleteTaskWithDelay() {
///     let userInfo: [String: Any] = [
///         "id": "uniqueTaskID",
///         "action": "deleteWithDelay",
///         "delay": 4.0 // 4 would be invalid, because it would count as an int
///     ]
///     NotificationCenter.default.post(name: .taskNotification, object: nil, userInfo: userInfo)
/// }
/// ```
///
/// You can also use the static helper method instead of creating dictionaries manually:
/// ```swift
/// TaskNotificationHandler.postTask(action: .create, model: .init(id: "task_id", "title": "New Task"))
/// ```
///
/// - Important: Please refer to ``CodeEdit/TaskNotificationModel`` and ensure you pass the correct values.
final class TaskNotificationHandler: ObservableObject {
    @Published private(set) var notifications: [TaskNotificationModel] = []
    var workspaceURL: URL?
    var cancellables: Set<AnyCancellable> = []

    enum Action: String {
        case create
        case createWithPriority
        case update
        case delete
        case deleteWithDelay
    }

    /// Post a new task.
    /// - Parameters:
    ///   - toWorkspace: The workspace to restrict the task to. Defaults to `nil`, which is received by all workspaces.
    ///   - action: The action being taken on the task.
    ///   - model: The task contents.
    @MainActor
    static func postTask(toWorkspace: URL? = nil, action: Action, model: TaskNotificationModel) {
        NotificationCenter.default.post(name: .taskNotification, object: nil, userInfo: [
            String(localized: "task.notification.key.id", defaultValue: "id", comment: "Notification key for task ID"): model.id,
            String(localized: "task.notification.key.title", defaultValue: "title", comment: "Notification key for task title"): model.title,
            String(localized: "task.notification.key.message", defaultValue: "message", comment: "Notification key for task message"): model.message as Any,
            String(localized: "task.notification.key.percentage", defaultValue: "percentage", comment: "Notification key for task percentage"): model.percentage as Any,
            String(localized: "task.notification.key.is-loading", defaultValue: "isLoading", comment: "Notification key for task loading state"): model.isLoading,
            String(localized: "task.notification.key.action", defaultValue: "action", comment: "Notification key for task action"): action.rawValue,
            String(localized: "task.notification.key.workspace", defaultValue: "workspace", comment: "Notification key for task workspace"): toWorkspace as Any
        ])
    }

    /// Initialises a new `TaskNotificationHandler` and starts observing for task notifications.
    init(workspaceURL: URL? = nil) {
        self.workspaceURL = workspaceURL

        NotificationCenter.default
            .publisher(for: .taskNotification)
            .receive(on: DispatchQueue.main)
            .sink { notification in
                self.handleNotification(notification)
            }
            .store(in: &cancellables)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .taskNotification, object: nil)
    }

    /// Handles notifications about task events.
    ///
    /// - Parameter notification: The notification containing task information.
    private func handleNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let taskID = userInfo[String(localized: "task.notification.key.id", defaultValue: "id", comment: "Notification key for task ID")] as? String,
              let actionRaw = userInfo[String(localized: "task.notification.key.action", defaultValue: "action", comment: "Notification key for task action")] as? String,
              let action = Action(rawValue: actionRaw) else { return }

        // If a workspace is specified and doesn't match, don't do anything with this task.
        if let workspaceURL = userInfo[String(localized: "task.notification.key.workspace", defaultValue: "workspace", comment: "Notification key for task workspace")] as? URL, workspaceURL != self.workspaceURL {
            return
        }

        switch action {
        case .create, .createWithPriority:
            createTask(task: userInfo)
        case .update:
            updateTask(task: userInfo)
        case .delete:
            deleteTask(taskID: taskID)
        case .deleteWithDelay:
            if let delay = userInfo[String(localized: "task.notification.key.delay", defaultValue: "delay", comment: "Notification key for task delay")] as? Double {
                deleteTaskAfterDelay(taskID: taskID, delay: delay)
            }
        }
    }

    /// Creates a new task or inserts it at the beginning of the tasks array based on the action.
    ///
    /// - Parameter task: A dictionary containing task information.
    private func createTask(task: [AnyHashable: Any]) {
        guard let title = task[String(localized: "task.notification.key.title", defaultValue: "title", comment: "Notification key for task title")] as? String,
              let id = task[String(localized: "task.notification.key.id", defaultValue: "id", comment: "Notification key for task ID")] as? String,
              let action = task[String(localized: "task.notification.key.action", defaultValue: "action", comment: "Notification key for task action")] as? String else {
            return
        }

        let task = TaskNotificationModel(
            id: id,
            title: title,
            message: task[String(localized: "task.notification.key.message", defaultValue: "message", comment: "Notification key for task message")] as? String,
            percentage: task[String(localized: "task.notification.key.percentage", defaultValue: "percentage", comment: "Notification key for task percentage")] as? Double,
            isLoading: task[String(localized: "task.notification.key.is-loading", defaultValue: "isLoading", comment: "Notification key for task loading state")] as? Bool ?? false
        )

        if action == String(localized: "task.notification.action.create", defaultValue: "create", comment: "Action to create task notification") {
            notifications.append(task)
        } else {
            notifications.insert(task, at: 0)
        }
    }

    /// Updates an existing task with new information.
    ///
    /// - Parameter task: A dictionary containing task information.
    private func updateTask(task: [AnyHashable: Any]) {
        guard let taskID = task[String(localized: "task.notification.key.id", defaultValue: "id", comment: "Notification key for task ID")] as? String else { return }
            if let index = self.notifications.firstIndex(where: { $0.id == taskID }) {
                if let title = task[String(localized: "task.notification.key.title", defaultValue: "title", comment: "Notification key for task title")] as? String {
                    self.notifications[index].title = title
                }
                if let message = task[String(localized: "task.notification.key.message", defaultValue: "message", comment: "Notification key for task message")] as? String {
                    self.notifications[index].message = message
                }
                if let percentage = task[String(localized: "task.notification.key.percentage", defaultValue: "percentage", comment: "Notification key for task percentage")] as? Double {
                    self.notifications[index].percentage = percentage
                }
                if let isLoading = task[String(localized: "task.notification.key.is-loading", defaultValue: "isLoading", comment: "Notification key for task loading state")] as? Bool {
                    self.notifications[index].isLoading = isLoading
                }
            }
    }

    private func deleteTask(taskID: String) {
            self.notifications.removeAll { $0.id == taskID }
    }

    private func deleteTaskAfterDelay(taskID: String, delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.notifications.removeAll { $0.id == taskID }
        }
    }
}

extension Notification.Name {
    static let taskNotification = Notification.Name(String(localized: "task.notification.name", defaultValue: "taskNotification", comment: "Notification name for task notifications"))
}
