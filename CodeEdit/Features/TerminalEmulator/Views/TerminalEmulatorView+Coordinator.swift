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
                source.feed(text: String(format: String(localized: "terminal-emulator.coordinator.exit-code", defaultValue: "Exit code: %d\n\r\n", comment: "Terminal exit code message shown when a session ends"), exitCode))
                source.feed(text: String(localized: "terminal-emulator.coordinator.open-new-session-instruction", defaultValue: "To open a new session, create a new terminal tab.", comment: "Instruction displayed after terminal session exits"))
                TerminalCache.shared.removeCachedView(terminalID)
            }
        }
    }
}
