//
//  AcknowledgementsRowView.swift
//  CodeEdit
//
//  Created by Austin Condiff on 1/19/23.
//

import SwiftUI

struct AcknowledgementRowView: View {
    @Environment(\.openURL)
    private var openURL

    let acknowledgement: AcknowledgementDependency

    var body: some View {
        HStack {
            Text(acknowledgement.name)
                .font(.body)

            Spacer()

            Button {
                openURL(acknowledgement.repositoryURL)
            } label: {
                Image(systemName: "arrow.right.circle.fill")
                    .foregroundColor(Color(nsColor: .tertiaryLabelColor))
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
    }
}

struct AcknowledgementsRowView_Previews: PreviewProvider {
    static var previews: some View {
        AcknowledgementRowView(acknowledgement: AcknowledgementDependency(
            name: String(localized: "acknowledgements.preview.name", defaultValue: "Test", comment: "Preview test package name"),
            repositoryLink: String(localized: "acknowledgements.preview.url", defaultValue: "https://www.test.com/", comment: "Preview test URL"),
            version: String(localized: "acknowledgements.preview.license", defaultValue: "-", comment: "Preview test license placeholder")
        ))
    }
}
