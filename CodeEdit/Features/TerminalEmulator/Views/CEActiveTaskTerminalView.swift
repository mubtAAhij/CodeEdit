//
//  CEActiveTaskTerminalView.swift
//  CodeEdit
//
//  Created by Khan Winter on 7/14/25.
//

import AppKit
import SwiftTerm

class CEActiveTaskTerminalView: CELocalShellTerminalView {
    var activeTask: CEActiveTask

    var isUserCommandRunning: Bool {
        activeTask.status == .running || activeTask.status == .stopped
    }

    init(activeTask: CEActiveTask) {
        self.activeTask = activeTask
        super.init(frame: .zero)
    }

    public required init?(coder: NSCoder) {
        fatalError(String(localized: "terminal.task.init_coder_error", defaultValue: "init(coder:) has not been implemented", comment: "Fatal error for unsupported initializer"))
    }

    override func startProcess(
        workspaceURL url: URL?,
        shell: Shell? = nil,
        environment: [String] = [],
        interactive: Bool = true
    ) {
        let terminalSettings = Settings.shared.preferences.terminal

        var terminalEnvironment: [String] = Terminal.getEnvironmentVariables()
        terminalEnvironment.append(String(localized: "terminal.task.env_program", defaultValue: "TERM_PROGRAM=CodeEditApp_Terminal", comment: "Terminal program environment variable"))

        guard let (shell, shellPath) = getShell(shell, userSetting: terminalSettings.shell) else {
            return
        }
        let shellArgs = [String(localized: "terminal.task.shell_flag", defaultValue: "-lic", comment: "Shell login interactive flag"), activeTask.task.command]

        terminalEnvironment.append(contentsOf: environment)
        terminalEnvironment.append(String(format: String(localized: "terminal.task.env_disable_history", defaultValue: "%@=1", comment: "Environment variable to disable shell history"), ShellIntegration.Variables.disableHistory))
        terminalEnvironment.append(
            contentsOf: activeTask.task.environmentVariables.map({ $0.key + "=" + $0.value })
        )

        sendOutputMessage(String(
            format: String(localized: "terminal.task.starting", defaultValue: "Starting task: %@", comment: "Task starting message"),
            self.activeTask.task.name
        ))
        sendOutputMessage(self.activeTask.task.command)
        newline()

        process.startProcess(
            executable: shellPath,
            args: shellArgs,
            environment: terminalEnvironment,
            execName: shell.rawValue,
            currentDirectory: URL(filePath: activeTask.task.workingDirectory, relativeTo: url).absolutePath
        )
    }

    override func processTerminated(_ source: LocalProcess, exitCode: Int32?) {
        activeTask.handleProcessFinished(terminationStatus: exitCode ?? 1)
    }

    func sendOutputMessage(_ message: String) {
        sendSpecialSequence()
        feed(text: message)
        newline()
    }

    func sendSpecialSequence() {
        let start: [UInt8] = [0x1B, 0x5B, 0x37, 0x6D]
        let end: [UInt8] = [0x1B, 0x5B, 0x30, 0x6D]
        feed(byteArray: start[0..<start.count])
        feed(text: String(localized: "terminal.task.marker", defaultValue: " * ", comment: "Terminal output marker"))
        feed(byteArray: end[0..<end.count])
        feed(text: " ")
    }

    func newline() {
        // cr cr lf
        feed(byteArray: [13, 13, 10])
    }

    func runningPID() -> pid_t? {
        if process.shellPid != 0 {
            return process.shellPid
        }
        return nil
    }

    func getBufferAsString() -> String {
        terminal.getText(
            start: .init(col: 0, row: 0),
            end: .init(col: terminal.cols, row: terminal.rows + terminal.buffer.yDisp)
        )
    }
}
