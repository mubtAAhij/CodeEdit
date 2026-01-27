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
                    Section(String(localized: "extensions.detail.features.test", defaultValue: "Features (this is a test, please do not click)", comment: "Features section header in extension detail view with test notice")) {
                        ForEach(ext.availableFeatures, id: \.self) { feature in
                            Text(feature.description)
                        }
                    }
                }
                .formStyle(.grouped)
            }

            Text(String(localized: "extensions.detail.settings.test", defaultValue: "Extension Settings (still a test)", comment: "Extension settings section header with test notice"))
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.leading)
            ExtensionSceneView(with: ext.endpoint, sceneID: "Settings")
                .padding(.top, -5)
                .ceEnvironment(\.complexValue, ["HAllo"])
        }
        .navigationSubtitle(ext.name)
    }
}
