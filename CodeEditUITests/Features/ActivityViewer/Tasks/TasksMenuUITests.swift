//
//  ActivityViewerTasksMenuTests.swift
//  CodeEditUITests
//
//  Created by Khan Winter on 1/3/25.
//

import XCTest

final class ActivityViewerTasksMenuTests: XCTestCase {
    // After all tests in this group
    override static func tearDown() {
        do {
            try cleanUpTempProjectPaths()
        } catch {
            print("Failed to clean up test temp directories.")
            print(error)
        }
    }

    var app: XCUIApplication!
    var window: XCUIElement!

    @MainActor
    override func setUp() async throws {
        (app, _) = try App.launchWithTempDir()
        window = Query.getWindow(app)
        XCTAssertTrue(window.exists, "Window not found")
    }

    func testTaskMenu() {
        let viewer = window.groups[String(localized: "test.activity-viewer", defaultValue: "Activity Viewer", comment: "Activity Viewer accessibility identifier in test")]
        XCTAssertNotNil(viewer, "No Activity Viewer")

        let taskDropdown = viewer.buttons[String(localized: "test.active-task", defaultValue: "Active Task", comment: "Active Task accessibility identifier in test")]
        XCTAssertTrue(taskDropdown.waitForExistence(timeout: 2.0), "No Task Dropdown")
        XCTAssertEqual(taskDropdown.value as? String, String(localized: "test.create-tasks", defaultValue: "Create Tasks", comment: "Create Tasks text in test"), "Incorrect empty tasks label")

        taskDropdown.click()
        XCTAssertGreaterThan(app.popovers.count, 0, "Popover didn't show up")
    }

    func testNewTask() {
        let viewer = window.groups[String(localized: "test.activity-viewer", defaultValue: "Activity Viewer", comment: "Activity Viewer accessibility identifier in test")]
        let taskDropdown = viewer.buttons[String(localized: "test.active-task", defaultValue: "Active Task", comment: "Active Task accessibility identifier in test")]
        taskDropdown.click()
        let popover = app.popovers.firstMatch
        XCTAssertTrue(popover.exists, "Popover did not appear on click")

        let addTaskListOption = popover.buttons[String(localized: "test.add-task-button", defaultValue: "Add Task...", comment: "Add Task button text in test")]
        XCTAssertTrue(addTaskListOption.exists, "No add task option in dropdown")
        addTaskListOption.click()

        let workspaceSettingsWindow = window.sheets[String(localized: "test.workspace-settings", defaultValue: "Workspace Settings", comment: "Workspace Settings window title in test")]
        XCTAssertTrue(workspaceSettingsWindow.waitForExistence(timeout: 1.0), "Workspace settings did not appear")

        let addTaskButton = workspaceSettingsWindow.buttons[String(localized: "test.add-task-button", defaultValue: "Add Task...", comment: "Add Task button text in test")]
        XCTAssertTrue(addTaskButton.exists, "No add task button")
        addTaskButton.click()

        // Enter in task information
        let newSheet = workspaceSettingsWindow.sheets.firstMatch
        XCTAssertTrue(newSheet.waitForExistence(timeout: 1.0), "New task sheet did not appear")
        let taskName = newSheet.textFields[String(localized: "test.task-name", defaultValue: "Task Name", comment: "Task Name field identifier in test")]
        XCTAssertTrue(taskName.exists)
        taskName.click()
        taskName.typeText("New Test Task")
        XCTAssertEqual(taskName.value as? String, "New Test Task", "Name did not enter in")

        let taskCommand = newSheet.textFields[String(localized: "test.task-command", defaultValue: "Task Command", comment: "Task Command field identifier in test")]
        XCTAssertTrue(taskCommand.exists)
        taskCommand.click()
        taskCommand.typeText("echo \"Hello World\"")
        XCTAssertEqual(taskCommand.value as? String, "echo \"Hello World\"", "Command did not enter in")

        let saveButton = newSheet.buttons[String(localized: "test.save-button", defaultValue: "Save", comment: "Save button text in test")]
        XCTAssertTrue(saveButton.exists)
        saveButton.click()

        workspaceSettingsWindow.buttons[String(localized: "test.done-button", defaultValue: "Done", comment: "Done button text in test")].click()
        XCTAssertFalse(
            workspaceSettingsWindow.waitForNonExistence(timeout: 1.0),
            "Workspace Settings should have dismissed"
        )

        // Ensure the new task was added as an option
        XCTAssertEqual(taskDropdown.value as? String, "New Test Task")
        taskDropdown.click()
        XCTAssertTrue(popover.buttons["New Test Task"].exists, "New task was not added to the task list.")
    }
}
