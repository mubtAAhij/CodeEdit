//
//  GitChangedFileLabel.swift
//  CodeEdit
//
//  Created by Khan Winter on 8/23/24.
//

import SwiftUI

struct GitChangedFileLabel: View {
    @EnvironmentObject private var workspace: WorkspaceDocument
    @EnvironmentObject private var sourceControlManager: SourceControlManager

    let file: GitChangedFile

    var body: some View {
        Label {
            Text(file.fileURL.lastPathComponent.trimmingCharacters(in: .whitespacesAndNewlines))
                .lineLimit(1)
                .truncationMode(.middle)
        } icon: {
            if let ceFile = workspace.workspaceFileManager?.getFile(file.ceFileKey, createIfNotFound: true) {
                Image(nsImage: ceFile.nsIcon)
                    .renderingMode(.template)
            } else {
                Image(systemName: FileIcon.fileIcon(fileType: nil))
                    .renderingMode(.template)
            }
        }
    }
}

#Preview {
    Group {
        GitChangedFileLabel(file: GitChangedFile(
            status: .modified,
            stagedStatus: .none,
            fileURL: URL(filePath: String(localized: "preview.git.file_path", defaultValue: "/Users/CodeEdit/app.jsx", comment: "Preview file path")),
            originalFilename: nil
        ))
        .environmentObject(SourceControlManager(workspaceURL: URL(filePath: String(localized: "preview.git.workspace_path", defaultValue: "/Users/CodeEdit", comment: "Preview workspace path")), editorManager: .init()))
        .environmentObject(WorkspaceDocument())

        GitChangedFileLabel(file: GitChangedFile(
            status: .none,
            stagedStatus: .renamed,
            fileURL: URL(filePath: String(localized: "preview.git.file_path", defaultValue: "/Users/CodeEdit/app.jsx", comment: "Preview file path")),
            originalFilename: String(localized: "preview.git.original_filename", defaultValue: "app2.jsx", comment: "Preview original filename")
        ))
        .environmentObject(SourceControlManager(workspaceURL: URL(filePath: String(localized: "preview.git.workspace_path", defaultValue: "/Users/CodeEdit", comment: "Preview workspace path")), editorManager: .init()))
        .environmentObject(WorkspaceDocument())
    }.padding()
}
