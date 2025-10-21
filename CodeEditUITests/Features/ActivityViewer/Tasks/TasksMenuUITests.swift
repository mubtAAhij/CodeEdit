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
        let viewer = window.groups[String(localized: "activityViewer.label", comment: "Accessibility label")]
        XCTAssertNotNil(viewer, "No Activity Viewer")

        let taskDropdown = viewer.buttons[String(localized: "taskDropDown.activeTask", comment: "Accessibility label")]
        XCTAssertTrue(taskDropdown.waitForExistence(timeout: 2.0), "No Task Dropdown")
        XCTAssertEqual(taskDropdown.value as? String, String(localized: "taskDropDown.createTasks", comment: "Button text"), "Incorrect empty tasks label")

        taskDropdown.click()
        XCTAssertGreaterThan(app.popovers.count, 0, "Popover didn't show up")
    }

    func testNewTask() {
        let viewer = window.groups[String(localized: "activityViewer.label", comment: "Accessibility label")]
        let taskDropdown = viewer.buttons[String(localized: "taskDropDown.activeTask", comment: "Accessibility label")]
        taskDropdown.click()
        let popover = app.popovers.firstMatch
        XCTAssertTrue(popover.exists, "Popover did not appear on click")

        let addTaskListOption = popover.buttons[String(localized: "taskDropDown.addTask", comment: "Menu item")]
        XCTAssertTrue(addTaskListOption.exists, "No add task option in dropdown")
        addTaskListOption.click()

        let workspaceSettingsWindow = window.sheets[String(localized: "workspaceSettings.title", comment: "Accessibility label")]
        XCTAssertTrue(workspaceSettingsWindow.waitForExistence(timeout: 1.0), "Workspace settings did not appear")

        let addTaskButton = workspaceSettingsWindow.buttons[String(localized: "workspaceSettings.addTask", comment: "Button text")]
        XCTAssertTrue(addTaskButton.exists, "No add task button")
        addTaskButton.click()

        // Enter in task information
        let newSheet = workspaceSettingsWindow.sheets.firstMatch
        XCTAssertTrue(newSheet.waitForExistence(timeout: 1.0), "New task sheet did not appear")
        let taskName = newSheet.textFields[String(localized: "taskForm.taskName", comment: "Accessibility label")]
        XCTAssertTrue(taskName.exists)
        taskName.click()
        taskName.typeText("New Test Task")
        XCTAssertEqual(taskName.value as? String, "New Test Task", "Name did not enter in")

        let taskCommand = newSheet.textFields[String(localized: "taskForm.taskCommand", comment: "Accessibility label")]
        XCTAssertTrue(taskCommand.exists)
        taskCommand.click()
        taskCommand.typeText("echo \"Hello World\"")
        XCTAssertEqual(taskCommand.value as? String, "echo \"Hello World\"", "Command did not enter in")

        let saveButton = newSheet.buttons[String(localized: "addTask.save", comment: "Button text")]
        XCTAssertTrue(saveButton.exists)
        saveButton.click()

        workspaceSettingsWindow.buttons[String(localized: "workspaceSettings.done", comment: "Button text")].click()
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
