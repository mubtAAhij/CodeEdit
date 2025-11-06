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
                        Text(String(localized: "settings.source-control.general", defaultValue: "General", comment: "General source control settings tab")).tag("general")
                        Text(String(localized: "settings.source-control.git", defaultValue: "Git", comment: "Git source control settings tab")).tag("git")
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
                Text(String(localized: "settings.source-control.title", defaultValue: "Source Control", comment: "Source control settings toggle label"))
                Text(String(localized: "settings.source-control.description", defaultValue: "Back up your files, collaborate with others, and tag your releases. [Learn more...](https://developer.apple.com/documentation/xcode/source-control-management)", comment: "Description of source control features with learn more link"))
                .font(.callout)
             } icon: {
                FeatureIcon(symbol: "vault", color: Color(.systemBlue), size: 26)
            }
        }
        .controlSize(.large)
    }

}
