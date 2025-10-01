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
            if let selectedTask = taskManager.selectedTask {
                if let selectedActiveTask = taskManager.activeTasks[selectedTask.id] {
                    ActiveTaskView(activeTask: selectedActiveTask)
                        .fixedSize()
                } else {
                    TaskView(task: selectedTask, status: CETaskStatus.notRunning)
                        .fixedSize()
                }
            } else {
                Text(String(localized: "task.create_tasks", comment: "Text shown when no tasks exist or label for task dropdown"))
                    .frame(minWidth: 0)
            }
        }
        .opacity(activeState == .inactive ? 0.4 : 1.0)
        .font(.subheadline)
        .padding(.trailing, 11.5)
        .padding(.horizontal, 2.5)
        .padding(.vertical, 2.5)
        .background(backgroundColor)
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
        .accessibilityValue(taskManager.selectedTask?.name ?? String(localized: "task.create_tasks", comment: "Text shown when no tasks exist or label for task dropdown"))
        .accessibilityLabel(String(localized: "task.active_task", comment: "Accessibility label for active task button"))
        .accessibilityHint(String(localized: "accessibility.task_dropdown.hint", comment: "Accessibility hint for task dropdown button"))
        .accessibilityAction {
            isTaskPopOverPresented = true
        }
    }

    private var backgroundColor: some View {
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

    private var chevronIcon: some View {
        Image(systemName: "chevron.down")
            .font(.system(size: 8, weight: .bold, design: .default))
            .padding(.top, 0.5)
            .padding(.trailing, 2)
    }

    private var taskPopoverContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            if !taskManager.availableTasks.isEmpty {
                ForEach(taskManager.availableTasks, id: \.id) { task in
                    TasksPopoverMenuItem(taskManager: taskManager, task: task) {
                        isTaskPopOverPresented = false
                    }
                }
                Divider()
                    .padding(.vertical, 5)
            }
            OptionMenuItemView(label: String(localized: "task_dropdown.add_task", comment: "Menu item to add a new task")) {
                NSApp.sendAction(#selector(CodeEditWindowController.openWorkspaceSettings(_:)), to: nil, from: nil)
            }
            OptionMenuItemView(label: String(localized: "task_dropdown.manage_tasks", comment: "Menu item to manage tasks")) {
                NSApp.sendAction(#selector(CodeEditWindowController.openWorkspaceSettings(_:)), to: nil, from: nil)
            }
        }
        .font(.subheadline)
        .padding(5)
        .frame(minWidth: 215)
    }
}
