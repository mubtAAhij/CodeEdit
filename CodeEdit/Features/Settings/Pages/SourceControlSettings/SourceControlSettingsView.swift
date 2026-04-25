//
//  SourceControlSettingsView.swift
//  CodeEdit
//
//  Created by Raymond Vleeshouwer on 02/04/23.
//

import SwiftUI

struct SourceControlSettingsView: View {
    @AppSettings(\.sourceControl.general)
    var settings

    @State var selectedTab: String = "general"

    var body: some View {
        SettingsForm {
            Section {
                sourceControlIsEnabled
            } footer: {
                if settings.sourceControlIsEnabled {
                    Picker("", selection: $selectedTab) {
                        Text(String(localized: "source-control.tab.general", defaultValue: "General", comment: "General tab in source control settings")).tag("general")
                        Text(String(localized: "source-control.tab.git", defaultValue: "Git", comment: "Git tab in source control settings")).tag("git")
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                    .padding(.top, 10)
                }
            }
            if settings.sourceControlIsEnabled {
                switch selectedTab {
                case "general":
                    SourceControlGeneralView()
                case "git":
                    SourceControlGitView()
                default:
                    SourceControlGeneralView()
                }
            }
        }
    }

    private var sourceControlIsEnabled: some View {
        Toggle(
            isOn: $settings.sourceControlIsEnabled
        ) {
            Label {
                Text(String(localized: "source-control.title", defaultValue: "Source Control", comment: "Source control feature title"))
                Text(String(localized: "source-control.description", defaultValue: "Back up your files, collaborate with others, and tag your releases. [Learn more...](https://developer.apple.com/documentation/xcode/source-control-management)", comment: "Source control feature description with link"))
                .font(.callout)
             } icon: {
                FeatureIcon(symbol: "vault", color: Color(.systemBlue), size: 26)
            }
        }
        .controlSize(.large)
    }

}
