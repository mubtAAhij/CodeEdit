//
//  NewFileButton.swift
//  CodeEdit
//
//  Created by Giorgi Tchelidze on 07.06.25.
//

import SwiftUI
import WelcomeWindow

struct NewFileButton: View {

    var dismissWindow: () -> Void

    var body: some View {
        WelcomeButton(
            iconName: "plus.square",
            title: String(localized: "welcome.create_new_file", comment: "Button title to create a new file"),
            action: {
                let documentController = CodeEditDocumentController()
                documentController.createAndOpenNewDocument(onCompletion: { dismissWindow() })
            }
        )
    }
}
