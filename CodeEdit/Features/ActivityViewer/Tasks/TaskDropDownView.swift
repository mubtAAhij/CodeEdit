//
//  TaskDropDownView.swift
//  CodeEdit
//
//  Created by Tommy Ludwig on 24.06.24.
//

import SwiftUI

struct TaskDropDownView: View {
    @Environment(\.colorScheme)
    private var colorScheme

    @Environment(\.controlActiveState)
    private var activeState

    @ObservedObject var taskManager: TaskManager

    @State private var isTaskPopOverPresented: Bool = false
    @State private var isHoveringTasks: Bool = false

    var body: some View {
        Group {
            if #available(macOS 26, *) {
                tahoe
            } else {
                seqouia
            }
        }
        .onHover { hovering in
            self.isHoveringTasks = hovering
        }
        .instantPopover(isPresented: $isTaskPopOverPresented, arrowEdge: .top) {
            taskPopoverContent
        }
        .onTapGesture {
            self.isTaskPopOverPresented.toggle()
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .accessibilityIdentifier("TaskDropdown")
        .accessibilityValue(taskManager.selectedTask?.name ?? String(localized: "activity-viewer.task-dropdown.create-tasks", defaultValue: "Create Tasks", comment: "Action title shown in task dropdown when no tasks exist"))
        .accessibilityLabel(String(localized: "activity-viewer.task-dropdown.active-task", defaultValue: "Active Task", comment: "Label for active task section in task dropdown"))
        .accessibilityHint(String(localized: "activity-viewer.task-dropdown.open-active-task-menu", defaultValue: "Open the active task menu", comment: "Accessibility label for opening the active task menu"))
        .accessibilityAction {
            isTaskPopOverPresented = true
        }
    }

    @available(macOS 26, *)
    @ViewBuilder private var tahoe: some View {
        HStack(spacing: 4) {
            label
            chevronIcon
                .opacity(isHoveringTasks || isTaskPopOverPresented ? 1.0 : 0.0)
        }
        .padding(6)
        .background {
            Color(nsColor: colorScheme == .dark ? .white : .black)
                .opacity(isHoveringTasks || isTaskPopOverPresented ? 0.05 : 0)
                .clipShape(Capsule())
        }
    }

    @ViewBuilder private var seqouia: some View {
        label
            .opacity(activeState == .inactive ? 0.4 : 1.0)
            .padding(.trailing, 11.5)
            .padding(.horizontal, 2.5)
            .padding(.vertical, 2.5)
            .background(backgroundColor)
    }

    @ViewBuilder private var label: some View {
        Group {
            if let selectedTask = taskManager.selectedTask {
                if let selectedActiveTask = taskManager.activeTasks[selectedTask.id] {
                    ActiveTaskView(activeTask: selectedActiveTask)
                        .fixedSize()
                } else {
                    TaskView(task: selectedTask, status: CETaskStatus.notRunning)
                        .fixedSize()
                }
            } else {
                Text(String(localized: "activity-viewer.task-dropdown.create-tasks", defaultValue: "Create Tasks", comment: "Menu action title to create tasks from task dropdown"))
                    .frame(minWidth: 0)
            }
        }
        .font(.subheadline)
    }

    @ViewBuilder private var backgroundColor: some View {
        Color(nsColor: colorScheme == .dark ? .white : .black)
            .opacity(isHoveringTasks || isTaskPopOverPresented ? 0.05 : 0)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 4, height: 4)))
            .overlay(
                HStack {
                    Spacer()
                    if isHoveringTasks || isTaskPopOverPresented {
                        chevronIcon
                    }
                }
            )
    }

    @ViewBuilder private var chevronIcon: some View {
        Image(systemName: "chevron.down")
            .font(.system(size: 8, weight: .bold, design: .default))
            .padding(.top, 0.5)
            .padding(.trailing, 2)
    }

    @ViewBuilder private var taskPopoverContent: some View {
        if !taskManager.availableTasks.isEmpty {
            ForEach(taskManager.availableTasks, id: \.id) { task in
                TasksPopoverMenuItem(taskManager: taskManager, task: task) {
                    isTaskPopOverPresented = false
                }
            }
            Divider()
                .padding(.vertical, 5)
        }
        OptionMenuItemView(label: String(localized: "activity-viewer.task-dropdown.add-task", defaultValue: "Add Task...", comment: "Menu action title to add a task")) {
            NSApp.sendAction(#selector(CodeEditWindowController.openWorkspaceSettings(_:)), to: nil, from: nil)
        }
        OptionMenuItemView(label: String(localized: "activity-viewer.task-dropdown.manage-tasks", defaultValue: "Manage Tasks...", comment: "Menu action title to open task management settings")) {
            NSApp.sendAction(#selector(CodeEditWindowController.openWorkspaceSettings(_:)), to: nil, from: nil)
        }
    }
}
