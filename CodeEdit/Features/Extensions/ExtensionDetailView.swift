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
                    Section(String(localized: "extensions.features", defaultValue: "Features", comment: "Features section header")) {
                        ForEach(ext.availableFeatures, id: \.self) { feature in
                            Text(feature.description)
                        }
                    }
                }
                .formStyle(.grouped)
            }

            Text(String(localized: "extensions.settings-title", defaultValue: "Extension Settings", comment: "Extension settings title"))
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.leading)
            ExtensionSceneView(with: ext.endpoint, sceneID: String(localized: "extensions.settings-scene", defaultValue: "Settings", comment: "Settings scene ID"))
                .padding(.top, -5)
                .ceEnvironment(\.complexValue, ["HAllo"])
        }
        .navigationSubtitle(ext.name)
    }
}
