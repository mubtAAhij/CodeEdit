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
                    Section(String(
                        localized: "inspector.file.identity-and-type.title",
                        defaultValue: "Identity and Type",
                        comment: "Section title in file inspector for identity and file type settings."
                    )) {
                        fileNameField
                        fileType
                    }
                    Section {
                        location
                    }
                    Section(String(
                        localized: "inspector.file.text-settings.title",
                        defaultValue: "Text Settings",
                        comment: "Section title in file inspector for text settings."
                    )) {
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
            TextField(String(
                localized: "inspector.file.identity-and-type.name",
                defaultValue: "Name",
                comment: "Label for file name field in file inspector."
            ), text: $fileName)
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
                                alert.addButton(withTitle: String(
                                    localized: "inspector.file.identity-and-type.rename.dismiss",
                                    defaultValue: "Dismiss",
                                    comment: "Button title to dismiss rename popover in file inspector."
                                ))
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
            String(
                localized: "inspector.file.identity-and-type.type",
                defaultValue: "Type",
                comment: "Label for file type field in file inspector."
            ),
            selection: $language
        ) {
            Text(String(
                localized: "inspector.file.identity-and-type.default-detected",
                defaultValue: "Default - Detected",
                comment: "Option label indicating default detected file type."
            )).tag(nil as CodeLanguage?)
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
                LabeledContent(String(
                    localized: "inspector.file.identity-and-type.location",
                    defaultValue: "Location",
                    comment: "Label for file location field in file inspector."
                )) {
                    Button(String(
                        localized: "inspector.file.identity-and-type.location.choose",
                        defaultValue: "Choose...",
                        comment: "Button title to choose a file location in file inspector."
                    )) {
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
                                alert.addButton(withTitle: String(
                                    localized: "inspector.file.identity-and-type.location.dismiss",
                                    defaultValue: "Dismiss",
                                    comment: "Button title to dismiss location chooser in file inspector."
                                ))
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
        Picker(String(
            localized: "inspector.file.text-settings.indent-using",
            defaultValue: "Indent using",
            comment: "Label for indentation mode setting in file inspector."
        ), selection: $indentOption.indentType) {
            Text(String(
                localized: "inspector.file.text-settings.indent-using.spaces",
                defaultValue: "Spaces",
                comment: "Option label for using spaces for indentation."
            )).tag(SettingsData.TextEditingSettings.IndentOption.IndentType.spaces)
            Text(String(
                localized: "inspector.file.text-settings.indent-using.tabs",
                defaultValue: "Tabs",
                comment: "Option label for using tabs for indentation."
            )).tag(SettingsData.TextEditingSettings.IndentOption.IndentType.tab)
        }
        .onChange(of: indentOption) { _, newValue in
            file?.fileDocument?.indentOption = newValue == textEditing.indentOption ? nil : newValue
        }
    }

    private var widthOptions: some View {
        LabeledContent(String(
            localized: "inspector.file.text-settings.widths.title",
            defaultValue: "Widths",
            comment: "Section label for indentation width settings in file inspector."
        )) {
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
                    Text(String(
                        localized: "inspector.file.text-settings.widths.tab",
                        defaultValue: "Tab",
                        comment: "Label for tab width setting in file inspector."
                    ))
                        .foregroundColor(.primary)
                        .font(.footnote)
                }
                .help(String(
                    localized: "inspector.file.text-settings.widths.tab.help",
                    defaultValue: "The visual width of tab characters",
                    comment: "Help text describing the tab width setting."
                ))
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
                    Text(String(
                        localized: "inspector.file.text-settings.widths.indent",
                        defaultValue: "Indent",
                        comment: "Label for indent width setting in file inspector."
                    ))
                        .foregroundColor(.primary)
                        .font(.footnote)
                }
                .help(String(
                    localized: "inspector.file.text-settings.widths.indent.help",
                    defaultValue: "The number of spaces to insert when the tab key is pressed.",
                    comment: "Help text describing the indent width setting."
                ))
            }
        }
        .onChange(of: defaultTabWidth) { _, newValue in
            file?.fileDocument?.defaultTabWidth = newValue == textEditing.defaultTabWidth ? nil : newValue
        }
    }

    private var wrapLinesToggle: some View {
        Toggle(String(
            localized: "inspector.file.text-settings.wrap-lines",
            defaultValue: "Wrap lines",
            comment: "Toggle label for wrapping lines in file inspector text settings."
        ), isOn: $wrapLines)
            .onChange(of: wrapLines) { _, newValue in
                file?.fileDocument?.wrapLines = newValue == textEditing.wrapLinesToEditorWidth ? nil : newValue
            }
    }

    private func chooseNewFileLocation() -> URL? {
        guard let file else { return nil }
        let dialogue = NSSavePanel()
        dialogue.title = String(
            localized: "inspector.file.actions.save-file",
            defaultValue: "Save File",
            comment: "Button title to save the current file from file inspector."
        )
        dialogue.directoryURL = file.url.deletingLastPathComponent()
        dialogue.nameFieldStringValue = file.name
        if dialogue.runModal() == .OK {
            return dialogue.url
        } else {
            return nil
        }
    }
}
