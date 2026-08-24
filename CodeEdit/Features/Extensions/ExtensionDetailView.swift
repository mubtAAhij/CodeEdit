//
//  ExtensionDetailView.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 01/01/2023.
//

import SwiftUI

struct ExtensionDetailView: View {
    var ext: ExtensionInfo

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let icon = ext.icon {
                    Image(nsImage: icon)
                        .resizable()
                        .frame(width: 150, height: 150)
                }

                Form {
                    Section(String(localized: "extensions.detail.features", defaultValue: "Features", comment: "Section title for extension feature list")) {
                        ForEach(ext.availableFeatures, id: \.self) { feature in
                            Text(feature.description)
                        }
                    }
                }
                .formStyle(.grouped)
            }

            Text(String(localized: "extensions.detail.extension-settings", defaultValue: "Extension Settings", comment: "Section title for extension settings area"))
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.leading)
            ExtensionSceneView(with: ext.endpoint, sceneID: String(localized: "extensions.detail.settings", defaultValue: "Settings", comment: "Title for extension settings subsection"))
                .padding(.top, -5)
                .ceEnvironment(\.complexValue, ["HAllo"])
        }
        .navigationSubtitle(ext.name)
    }
}
