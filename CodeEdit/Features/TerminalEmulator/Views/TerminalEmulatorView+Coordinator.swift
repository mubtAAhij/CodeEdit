//
//  TerminalEmulatorView+Coordinator.swift
//  CodeEditModules/TerminalEmulator
//
//  Created by Lukas Pistrol on 24.03.22.
//

import SwiftUI
import SwiftTerm

extension TerminalEmulatorView {
    final class Coordinator: NSObject, CELocalShellTerminalViewDelegate {
        private let terminalID: UUID
        public var onTitleChange: (_ title: String) -> Void

        var mode: TerminalMode

        init(terminalID: UUID, mode: TerminalMode, onTitleChange: @escaping (_ title: String) -> Void) {
            self.terminalID = terminalID
            self.onTitleChange = onTitleChange
            self.mode = mode
            super.init()
        }

        func hostCurrentDirectoryUpdate(source: TerminalView, directory: String?) {}

        func sizeChanged(source: CETerminalView, newCols: Int, newRows: Int) {}

        func setTerminalTitle(source: CETerminalView, title: String) {
            onTitleChange(title)
        }

        func processTerminated(source: TerminalView, exitCode: Int32?) {
            guard let exitCode else {
                return
            }
            if case .shell = mode {
                source.feed(text: String(localized: "terminal.exit-code", defaultValue: "Exit code: \(exitCode)\n\r\n", comment: "Terminal message showing process exit code"))
                source.feed(text: String(localized: "terminal.new-session-instruction", defaultValue: "To open a new session, create a new terminal tab.", comment: "Instruction for opening a new terminal session"))
                TerminalCache.shared.removeCachedView(terminalID)
            }
        }
    }
}
