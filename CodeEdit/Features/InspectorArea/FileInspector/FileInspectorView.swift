//
//  FileInspectorView.swift
//  CodeEdit
//
//  Created by Nanashi Li on 2022/03/24.
//
import SwiftUI
import CodeEditLanguages

struct FileInspectorView: View {
    @EnvironmentObject private var workspace: WorkspaceDocument

    @EnvironmentObject private var editorManager: EditorManager

    @AppSettings(\.textEditing)
    private var textEditing

    @State private var file: CEWorkspaceFile?

    @State private var fileName: String = ""

    // File settings overrides

    @State private var language: CodeLanguage?

    @State var indentOption: SettingsData.TextEditingSettings.IndentOption = .init(indentType: .tab)

    @State var defaultTabWidth: Int = 0

    @State var wrapLines: Bool = false

    func updateFileOptions(_ textEditingOverride: SettingsData.TextEditingSettings? = nil) {
        let textEditingSettings = textEditingOverride ?? textEditing
        indentOption = file?.fileDocument?.indentOption ?? textEditingSettings.indentOption
        defaultTabWidth = file?.fileDocument?.defaultTabWidth ?? textEditingSettings.defaultTabWidth
        wrapLines = file?.fileDocument?.wrapLines ?? textEditingSettings.wrapLinesToEditorWidth
    }

    func updateInspectorSource() {
        file = editorManager.activeEditor.selectedTab?.file
        fileName = file?.name ?? ""
        language = file?.fileDocument?.language
        updateFileOptions()
    }

    var body: some View {
        Group {
            if file != nil {
                Form {
                    Section(String(localized: "file-inspector.identity-section-title", defaultValue: "Identity and Type", comment: "Section title for file identity and type information")) {
                        fileNameField
                        fileType
                    }
                    Section {
                        location
                    }
                    Section(String(localized: "file-inspector.text-settings-section-title", defaultValue: "Text Settings", comment: "Section title for text editor settings")) {
                        indentUsing
                        widthOptions
                        wrapLinesToggle
                    }
                }
            } else {
                NoSelectionInspectorView()
            }
        }
        .onAppear {
            updateInspectorSource()
        }
        .onReceive(editorManager.activeEditor.objectWillChange) { _ in
            updateInspectorSource()
        }
        .onChange(of: editorManager.activeEditor) { _, _ in
            updateInspectorSource()
        }
        .onChange(of: editorManager.activeEditor.selectedTab) { _, _ in
            updateInspectorSource()
        }
        .onChange(of: textEditing) { _, newValue in
            updateFileOptions(newValue)
        }
    }

    @ViewBuilder private var fileNameField: some View {
        if let file {
            TextField(String(localized: "file-inspector.name-label", defaultValue: "Name", comment: "Label for file name field"), text: $fileName)
                .background(
                    fileName != file.fileName() && !file.validateFileName(for: fileName) ? Color(errorRed) : Color.clear
                )
                .onSubmit {
                    if file.validateFileName(for: fileName) {
                        let destinationURL = file.url
                            .deletingLastPathComponent()
                            .appending(path: fileName)
                        DispatchQueue.main.async { [weak workspace] in
                            do {
                                if let newItem = try workspace?.workspaceFileManager?.move(
                                    file: file,
                                    to: destinationURL
                                ),
                                   !newItem.isFolder {
                                    editorManager.editorLayout.closeAllTabs(of: file)
                                    editorManager.openTab(item: newItem)
                                }
                            } catch {
                                let alert = NSAlert(error: error)
                                alert.addButton(withTitle: String(localized: "file-inspector.dismiss-button", defaultValue: "Dismiss", comment: "Button to dismiss name editing"))
                                alert.runModal()
                            }
                        }
                    } else {
                        fileName = file.labelFileName()
                    }
                }
        }
    }

    @ViewBuilder private var fileType: some View {
        Picker(
            String(localized: "file-inspector.type-label", defaultValue: "Type", comment: "Label for file type picker"),
            selection: $language
        ) {
            Text(String(localized: "file-inspector.type-default-detected", defaultValue: "Default - Detected", comment: "Default option for file type detection")).tag(nil as CodeLanguage?)
            Divider()
            ForEach(CodeLanguage.allLanguages, id: \.id) { language in
                Text(language.id.rawValue.capitalized).tag(language as CodeLanguage?)
            }
        }
        .onChange(of: language) { _, newValue in
            file?.fileDocument?.language = newValue
        }
    }

    private var location: some View {
        Group {
            if let file {
                LabeledContent(String(localized: "file-inspector.location-label", defaultValue: "Location", comment: "Label for file location field")) {
                    Button(String(localized: "file-inspector.location-choose-button", defaultValue: "Choose...", comment: "Button to choose file location")) {
                        guard let newURL = chooseNewFileLocation() else {
                            return
                        }
                        // This is ugly but if the tab is opened at the same time as closing the others, it doesn't open
                        // And if the files are re-built at the same time as the tab is opened, it causes a memory error
                        DispatchQueue.main.async { [weak workspace] in
                            do {
                                guard let newItem = try workspace?.workspaceFileManager?.move(file: file, to: newURL),
                                      !newItem.isFolder else {
                                    return
                                }
                                editorManager.editorLayout.closeAllTabs(of: file)
                                editorManager.openTab(item: newItem)
                            } catch {
                                let alert = NSAlert(error: error)
                                alert.addButton(withTitle: String(localized: "file-inspector.location-dismiss-button", defaultValue: "Dismiss", comment: "Button to dismiss location picker"))
                                alert.runModal()
                            }
                        }
                    }
                }
                ExternalLink(showInFinder: true, destination: file.url) {
                    Text(file.url.path(percentEncoded: false))
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
        }
    }

    private var indentUsing: some View {
        Picker(String(localized: "file-inspector.indent-using-label", defaultValue: "Indent using", comment: "Label for indent type picker"), selection: $indentOption.indentType) {
            Text(String(localized: "file-inspector.indent-spaces", defaultValue: "Spaces", comment: "Option to indent using spaces")).tag(SettingsData.TextEditingSettings.IndentOption.IndentType.spaces)
            Text(String(localized: "file-inspector.indent-tabs", defaultValue: "Tabs", comment: "Option to indent using tabs")).tag(SettingsData.TextEditingSettings.IndentOption.IndentType.tab)
        }
        .onChange(of: indentOption) { _, newValue in
            file?.fileDocument?.indentOption = newValue == textEditing.indentOption ? nil : newValue
        }
    }

    private var widthOptions: some View {
        LabeledContent(String(localized: "file-inspector.widths-label", defaultValue: "Widths", comment: "Label for width settings section")) {
            HStack(spacing: 5) {
                VStack(alignment: .center, spacing: 0) {
                    Stepper(
                        "",
                        value: Binding<Double>(
                            get: { Double(defaultTabWidth) },
                            set: { defaultTabWidth = Int($0) }
                        ),
                        in: 1...16,
                        step: 1,
                        format: .number
                    )
                    .labelsHidden()
                    Text(String(localized: "file-inspector.tab-width-label", defaultValue: "Tab", comment: "Label for tab width field"))
                        .foregroundColor(.primary)
                        .font(.footnote)
                }
                .help(String(localized: "file-inspector.tab-width-help", defaultValue: "The visual width of tab characters", comment: "Help text for tab width setting"))
                VStack(alignment: .center, spacing: 0) {
                    Stepper(
                        "",
                        value: Binding<Double>(
                            get: { Double(indentOption.spaceCount) },
                            set: { indentOption.spaceCount = Int($0) }
                        ),
                        in: 1...10,
                        step: 1,
                        format: .number
                    )
                    .labelsHidden()
                    Text(String(localized: "file-inspector.indent-width-label", defaultValue: "Indent", comment: "Label for indent width field"))
                        .foregroundColor(.primary)
                        .font(.footnote)
                }
                .help(String(localized: "file-inspector.indent-width-help", defaultValue: "The number of spaces to insert when the tab key is pressed.", comment: "Help text for indent width setting"))
            }
        }
        .onChange(of: defaultTabWidth) { _, newValue in
            file?.fileDocument?.defaultTabWidth = newValue == textEditing.defaultTabWidth ? nil : newValue
        }
    }

    private var wrapLinesToggle: some View {
        Toggle(String(localized: "file-inspector.wrap-lines-label", defaultValue: "Wrap lines", comment: "Label for wrap lines toggle"), isOn: $wrapLines)
            .onChange(of: wrapLines) { _, newValue in
                file?.fileDocument?.wrapLines = newValue == textEditing.wrapLinesToEditorWidth ? nil : newValue
            }
    }

    private func chooseNewFileLocation() -> URL? {
        guard let file else { return nil }
        let dialogue = NSSavePanel()
        dialogue.title = String(localized: "file-inspector.save-file-button", defaultValue: "Save File", comment: "Button to save file changes")
        dialogue.directoryURL = file.url.deletingLastPathComponent()
        dialogue.nameFieldStringValue = file.name
        if dialogue.runModal() == .OK {
            return dialogue.url
        } else {
            return nil
        }
    }
}
