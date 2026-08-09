//
//  TerminalEmulatorView+Coordinator.swift
//  CodeEditModules/TerminalEmulator
//
//  Created by Lukas Pistrol on 24.03.22.
//

import SwiftTerm
import SwiftUI

extension TerminalEmulatorView {
    final class Coordinator: NSObject, CELocalShellTerminalViewDelegate {
        private let terminalID: UUID
        var onTitleChange: (_ title: String) -> Void

        var mode: TerminalMode

        init(terminalID: UUID, mode: TerminalMode, onTitleChange: @escaping (_ title: String) -> Void) {
            self.terminalID = terminalID
            self.onTitleChange = onTitleChange
            self.mode = mode
            super.init()
        }

        func hostCurrentDirectoryUpdate(source _: TerminalView, directory _: String?) {}

        func sizeChanged(source _: CETerminalView, newCols _: Int, newRows _: Int) {}

        func setTerminalTitle(source _: CETerminalView, title: String) {
            onTitleChange(title)
        }

        func processTerminated(source: TerminalView, exitCode: Int32?) {
            guard let exitCode else {
                return
            }
            if case .shell = mode {
                source.feed(text: "Exit code: \(exitCode)\n\r\n")
                source.feed(text: String(localized: "terminal.coordinator.open-new-session-hint", defaultValue: "To open a new session, create a new terminal tab.", comment: "Hint message explaining how to open a new terminal session"))
                TerminalCache.shared.removeCachedView(terminalID)
            }
        }
    }
}
